import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _storyAsset = 'assets/images/story_reference.png';
const _ink = Color(0xFF662718);

const _storyParagraphs = [
  'Говорят, что много лет назад, там, где садится солнце за Синими холмами, старый мудрый кот по имени Кот-Хранитель посадил в землю первую монетку-коткоин. Из неё выросло удивительное Котодерево — оно и сегодня стоит в самом сердце города, роняя на землю золотистые монетки тем, кто умеет их беречь.',
  'Так родился КопиКот-Сити — волшебный город, куда каждое утро, едва взойдёт солнце, спешат котята со всех окрестностей. Они приходят сюда, чтобы научиться главному коты-искусству: обращаться со своими коткоинами мудро и бережно.',
  'В городе никогда не бывает скучно. На шумном Котомаркете витрины ломятся от самых заманчивых лакомств и игрушек — тут-то и учишься решать, что действительно нужно, а что подождёт. В уютных копилках-норках дремлют сбережения, а под кроной Котодерева всегда можно найти мудрого кота-наставника, который подскажет, как спланировать покупку, позаботиться о себе и копить на самую большую мечту.',
];

const _storyIllustrations = [
  Rect.fromLTWH(42, 659, 410, 290),
  Rect.fromLTWH(42, 988, 412, 277),
  Rect.fromLTWH(42, 1304, 412, 311),
];

/// Сказка о появлении КопиКот-Сити. Не связана с историей покупок.
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: Scaffold(
      backgroundColor: const Color(0xFF88C9F6),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fairytale_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 18),
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => Stack(
                        children: [
                          const _StoryCrop(
                            source: Rect.fromLTWH(0, 0, 941, 548),
                          ),
                          Positioned(
                            left: constraints.maxWidth * .015,
                            top: constraints.maxWidth * .015,
                            width: constraints.maxWidth * .17,
                            height: constraints.maxWidth * .15,
                            child: Semantics(
                              button: true,
                              label: 'Назад',
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.of(context).maybePop(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFFFC64C),
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x8853240B),
                            blurRadius: 9,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const _StoryCrop(
                            source: Rect.fromLTWH(9, 548, 923, 99),
                          ),
                          for (
                            var index = 0;
                            index < _storyParagraphs.length;
                            index++
                          ) ...[
                            if (index > 0) const _StoryDivider(),
                            _StorySection(
                              source: _storyIllustrations[index],
                              text: _storyParagraphs[index],
                            ),
                          ],
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StorySection extends StatelessWidget {
  const _StorySection({required this.source, required this.text});

  final Rect source;
  final String text;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final narrow = constraints.maxWidth < 470;
      final illustration = ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: _StoryCrop(source: source),
      );
      final paragraph = Text(
        text,
        style: TextStyle(
          color: _ink,
          fontSize: narrow ? 12 : 17,
          height: 1.24,
          fontWeight: FontWeight.w600,
        ),
      );
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: narrow ? 10 : 16,
          vertical: 9,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: illustration),
            SizedBox(width: narrow ? 9 : 16),
            Expanded(child: paragraph),
          ],
        ),
      );
    },
  );
}

class _StoryDivider extends StatelessWidget {
  const _StoryDivider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 6),
    child: Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFF9BA6E), thickness: 1.5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.pets_rounded, color: Color(0xFFF4A04C), size: 24),
        ),
        Expanded(child: Divider(color: Color(0xFFF9BA6E), thickness: 1.5)),
      ],
    ),
  );
}

/// Показывает область исходной иллюстрации без изменения файла макета.
class _StoryCrop extends StatelessWidget {
  const _StoryCrop({required this.source});

  final Rect source;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: source.width / source.height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / source.width;
        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: -source.left * scale,
                top: -source.top * scale,
                width: 941 * scale,
                height: 1672 * scale,
                child: Image.asset(_storyAsset, fit: BoxFit.fill),
              ),
            ],
          ),
        );
      },
    ),
  );
}
