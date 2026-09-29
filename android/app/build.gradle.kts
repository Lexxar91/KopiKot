import java.io.File
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releasePropertiesFile = rootProject.file("key.properties")
val releaseProperties = Properties()
if (releasePropertiesFile.isFile) {
    releasePropertiesFile.reader(Charsets.UTF_8).use { releaseProperties.load(it) }
}

android {
    namespace = "com.lexxar91.kopikot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.lexxar91.kopikot"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = releaseProperties.getProperty("keyAlias")
            keyPassword = releaseProperties.getProperty("keyPassword")
            storePassword = releaseProperties.getProperty("storePassword")
            storeFile = releaseProperties.getProperty("storeFile")
                ?.takeIf { it.isNotBlank() }
                ?.let { file(it) }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

// Не допускает случайную сдачу шаблонного пакета или подмену релизного ключа debug-ключом.
val verifyReleaseSigning = tasks.register("verifyReleaseSigning") {
    group = "verification"
    description = "Checks release identity and local signing settings without printing secrets."
    doLast {
        val problems = mutableListOf<String>()
        val appId = android.defaultConfig.applicationId.orEmpty()
        if (appId.isBlank() || appId.startsWith("com.example.")) {
            problems += "Выбери постоянный applicationId вместо com.example.*."
        }
        if (!releasePropertiesFile.isFile) {
            problems += "Создай локальный android/key.properties по key.properties.example."
        } else {
            for (name in listOf("storeFile", "storePassword", "keyAlias", "keyPassword")) {
                if (releaseProperties.getProperty(name).isNullOrBlank()) {
                    problems += "Заполни параметр $name в android/key.properties."
                }
            }
            val storePath = releaseProperties.getProperty("storeFile")
            if (!storePath.isNullOrBlank()) {
                val keyFile = File(storePath)
                if (!keyFile.isAbsolute || !keyFile.isFile) {
                    problems += "storeFile должен указывать абсолютный путь к существующему ключу."
                }
            }
            if (releaseProperties.getProperty("keyAlias") == "androiddebugkey") {
                problems += "Для release нужен отдельный ключ, не стандартный androiddebugkey."
            }
        }
        if (problems.isNotEmpty()) {
            throw GradleException(
                "Release не настроен:\n" + problems.joinToString("\n") +
                    "\nИнструкция: docs/setup_ubuntu.md, раздел 6. Пароли не публикуй.",
            )
        }
    }
}

tasks.matching { it.name == "preReleaseBuild" || it.name == "validateSigningRelease" }
    .configureEach { dependsOn(verifyReleaseSigning) }

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
