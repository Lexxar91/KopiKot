#!/usr/bin/env python3
"""Собирает локальные Markdown-документы в два PDF без пакетов Python.

Рендерер поддерживает используемое здесь подмножество Markdown, не весь CommonMark.
HTML/PDF — генерируемые артефакты; источники редактируются в docs/*.md.
"""

import base64
import html
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "docs/delivery"
SOURCES = (
    "README.md",
    "docs/setup_ubuntu.md",
    "docs/architecture.md",
    "docs/requirements.md",
    "docs/content_map.md",
    "docs/educational_basis.md",
    "docs/ux_accessibility.md",
    "docs/data_privacy.md",
    "docs/verification.md",
    "docs/device_test_report.md",
    "docs/demo_scenario.md",
    "docs/assets.md",
    "docs/third_party.md",
    "docs/native_licenses.md",
    "docs/interim_submission.md",
    "docs/store/listing.md",
)
ANCHORS = {ROOT / name: f"source-{index}" for index, name in enumerate(SOURCES)}
TOKEN = re.compile(r"`([^`]+)`|\[([^\]]+)\]\(([^\s]+?)\)|\*\*(.+?)\*\*")
BLOCK = re.compile(r"^(#{1,6} |```|\|.*\||> ?|(?:\*|-|\d+\.) )")


def inline(value, source, *, internal_links=True):
    """Экранирует HTML; разрешает ссылки HTTP(S) и локальные якоря сборника."""
    result = []
    position = 0
    for match in TOKEN.finditer(value):
        result.append(html.escape(value[position:match.start()]))
        code, label, target, bold = match.groups()
        if code is not None:
            result.append(f"<code>{html.escape(code)}</code>")
        elif label is not None:
            text = html.escape(label)
            path = (source.parent / target.split("#")[0]).resolve()
            if target.startswith(("https://", "http://")):
                result.append(f'<a href="{html.escape(target, quote=True)}">{text}</a>')
            elif internal_links and path in ANCHORS:
                result.append(f'<a href="#{ANCHORS[path]}">{text}</a>')
            else:
                # Не встраиваем личные file://-пути в передаваемый экспертам PDF.
                result.append(f'{text} <span class="path">({html.escape(target)})</span>')
        else:
            result.append(f"<strong>{html.escape(bold)}</strong>")
        position = match.end()
    result.append(html.escape(value[position:]))
    return "".join(result)


def markdown(value, source, *, internal_links=True):
    lines = value.splitlines()
    output = []
    index = 0

    def rich(text):
        return inline(text, source, internal_links=internal_links)

    while index < len(lines):
        line = lines[index].strip()
        index += 1
        if not line:
            continue
        if line.startswith("```"):
            code = []
            while index < len(lines) and not lines[index].strip().startswith("```"):
                code.append(lines[index])
                index += 1
            if index == len(lines):
                raise ValueError(f"Незакрытый блок кода: {source}")
            index += 1
            output.append("<pre>" + html.escape("\n".join(code)) + "</pre>")
        elif match := re.match(r"^(#{1,6}) (.+)$", line):
            level = len(match[1])
            output.append(f"<h{level}>{rich(match[2])}</h{level}>")
        elif line.startswith("|") and line.endswith("|"):
            rows = [line]
            while index < len(lines) and lines[index].strip().startswith("|"):
                rows.append(lines[index].strip())
                index += 1
            cells = [row.strip("|").split("|") for row in rows]
            if len(cells) < 2 or not all(re.fullmatch(r"\s*:?-+:?\s*", c) for c in cells[1]):
                raise ValueError(f"Неподдерживаемая таблица: {source}")
            output.append("<table><thead><tr>" + "".join(
                f"<th>{rich(c.strip())}</th>" for c in cells[0]
            ) + "</tr></thead><tbody>")
            for row in cells[2:]:
                if len(row) != len(cells[0]):
                    raise ValueError(f"Разное число столбцов: {source}")
                output.append("<tr>" + "".join(f"<td>{rich(c.strip())}</td>" for c in row) + "</tr>")
            output.append("</tbody></table>")
        elif line.startswith("!["):
            match = re.fullmatch(r"!\[([^\]]*)\]\(([^)]+)\)", line)
            if not match:
                raise ValueError(f"Неподдерживаемое изображение: {source}")
            path = (source.parent / match[2]).resolve()
            if not path.is_relative_to(ROOT) or path.suffix != ".png":
                raise ValueError("Разрешены только PNG внутри проекта")
            data = base64.b64encode(path.read_bytes()).decode("ascii")
            output.append(f'<img class="media" alt="{html.escape(match[1])}" src="data:image/png;base64,{data}">')
        else:
            style = ""
            if line.startswith(">"):
                style = ' class="quote"'
                line = line.lstrip("> ")
            elif re.match(r"^(?:\*|-|\d+\.) ", line):
                style = ' class="list-item"'
            paragraph = [line]
            while index < len(lines) and lines[index].strip() and not BLOCK.match(lines[index].strip()):
                if lines[index].strip().startswith("!["):
                    break
                paragraph.append(lines[index].strip())
                index += 1
            output.append(f"<p{style}>{rich(' '.join(paragraph))}</p>")
    return "\n".join(output)


CSS = """
@page { size: A4; margin: 17mm 15mm 19mm;
  @bottom-center { content: counter(page); font: 9pt 'DejaVu Sans'; color: #356c64; } }
* { box-sizing: border-box; }
body { font: 10pt/1.45 'DejaVu Sans', sans-serif; color: #243d39; margin: 0; }
h1 { font-size: 22pt; line-height: 1.15; color: #356c64; }
h2 { font-size: 15pt; margin-top: 7mm; }
h3 { font-size: 12pt; }
h1,h2,h3,h4 { break-after: avoid; }
p { orphans: 3; widows: 3; }
a { color: #23594f; overflow-wrap: anywhere; }
code,pre { font-family: 'DejaVu Sans Mono', monospace; font-size: 8pt; }
code { overflow-wrap: anywhere; }
pre { white-space: pre-wrap; overflow-wrap: anywhere; background: #eef4f1; padding: 3mm; }
table { border-collapse: collapse; width: 100%; font-size: 8pt; margin: 4mm 0; }
th,td { padding: 2mm; border: 0.25mm solid #c6d5ce; vertical-align: top; overflow-wrap: anywhere; }
th { background: #e4efe9; text-align: left; }
th:first-child,td:first-child { min-width: 20mm; }
th:nth-child(2),td:nth-child(2) { min-width: 26mm; }
th:last-child,td:last-child { min-width: 22mm; }
tr { break-inside: avoid; }
thead { display: table-header-group; }
article { break-before: page; }
.source,.path { color: #56655e; font-size: 8pt; overflow-wrap: anywhere; }
.list-item { padding-left: 4mm; }
.quote { border-left: 1mm solid #d7a04c; padding-left: 4mm; }
.cover { min-height: 220mm; padding-top: 15mm; }
.warning { background: #fff1d9; padding: 5mm; }
.media { max-width: 70mm; max-height: 115mm; object-fit: contain; }
"""


def document(title, content, *, slides=False):
    style = CSS
    if slides:
        style += """
        @page { size: 320mm 180mm; margin: 0; @bottom-center { content: none; } }
        body { font-size: 17pt; line-height: 1.35; }
        article { position: relative; height: 180mm; padding: 12mm 16mm 15mm;
                  break-before: auto; break-after: page; }
        article:last-child { break-after: auto; }
        h2 { font-size: 27pt; margin: 0 0 7mm; color: #356c64; }
        p { margin: 4mm 0; }
        code,.path { font-size: 12pt; }
        .media { float: right; margin: 0 0 4mm 9mm; max-width: 68mm; max-height: 118mm; }
        footer { position: absolute; bottom: 5mm; left: 16mm; right: 16mm;
                 font-size: 10pt; color: #56655e; border-top: 0.4mm solid #d7a04c; padding-top: 2mm; }
        """
    return f'<!doctype html><html lang="ru"><head><meta charset="utf-8"><title>{html.escape(title)}</title><style>{style}</style></head><body>{content}</body></html>'


def build_html():
    cover = '<section class="cover"><h1>Питомец Финни</h1><h2>Сопроводительная документация MVP</h2>'
    cover += '<p>Рабочая редакция · 17 сентября 2026 года · Android / RuStore</p>'
    cover += '<p class="warning">Черновик, не акт готовности. Нет результатов физической Android-приёмки, финальной подписи и опубликованного комплекта сдачи. Реестр Pub/Android готов; нативные лицензии требуют дополнительной сверки. Контакты команды ещё не указаны.</p>'
    cover += '<p>Разделы формируются из файлов репозитория. Архитектура и планируемые модели различаются в исходном документе. Ссылки на исходники означают файлы проекта, а не подтверждение их публикации.</p><h2>Содержание</h2>'
    bodies = []
    for name in SOURCES:
        path = ROOT / name
        source = path.read_text(encoding="utf-8")
        title = source.splitlines()[0].lstrip("# ")
        cover += f'<p><a href="#{ANCHORS[path]}">{html.escape(title)}</a></p>'
        bodies.append(f'<article id="{ANCHORS[path]}"><p class="source">Источник: {name}</p>{markdown(source, path)}</article>')
    companion = document("Питомец Финни — сопроводительная документация", cover + "</section>" + "".join(bodies))
    path = ROOT / "docs/presentation.md"
    sections = path.read_text(encoding="utf-8").split("\n## ")[1:]
    if len(sections) != 10:
        raise ValueError("Ожидалось 10 слайдов")
    slides = "".join(
        f'<article>{markdown("## " + section, path, internal_links=False)}<footer>Питомец Финни · Черновик MVP · {index} / 10</footer></article>'
        for index, section in enumerate(sections, start=1)
    )
    return {"companion": companion, "presentation": document("Питомец Финни — презентация", slides, slides=True)}


def main():
    chrome = shutil.which("google-chrome") or shutil.which("chromium")
    if chrome is None:
        raise SystemExit("Для PDF нужен установленный Google Chrome или Chromium")
    pages = build_html()
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for name, page in pages.items():
        source = OUTPUT / f"{name}.html"
        pdf = OUTPUT / f"{name}.pdf"
        source.write_text(page, encoding="utf-8")
        # Отдельный временный профиль: не трогаем пользовательский браузер.
        with tempfile.TemporaryDirectory(prefix="finny-docs-") as profile:
            temporary_pdf = Path(profile) / f"{name}.pdf"
            result = subprocess.run([
                chrome, "--headless", "--disable-gpu", "--disable-background-networking",
                "--no-first-run", "--no-default-browser-check", "--no-pdf-header-footer",
                f"--user-data-dir={profile}", f"--print-to-pdf={temporary_pdf}", source.as_uri(),
            ], capture_output=True, text=True, timeout=55)
            if result.returncode or not temporary_pdf.is_file():
                raise SystemExit(result.stderr[-2000:] or f"Не создан {pdf}")
            with temporary_pdf.open('rb') as created:
                if created.read(5) != b'%PDF-':
                    raise SystemExit(f"Некорректный PDF: {name}")
            # Старый документ сохраняется, если экспорт завершился ошибкой.
            shutil.move(temporary_pdf, pdf)
        print(f"{pdf.relative_to(ROOT)}: {pdf.stat().st_size} bytes", flush=True)


if __name__ == "__main__":
    main()
