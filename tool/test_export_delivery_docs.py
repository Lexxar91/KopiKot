"""Проверки преобразования источников без запуска браузера."""

from pathlib import Path
import unittest

from export_delivery_docs import ROOT, build_html, inline, markdown


class DeliveryDocsTest(unittest.TestCase):
    def test_inline_escapes_html_and_unsafe_links(self):
        result = inline('<script> & `a < b` [x](javascript:alert)', ROOT / 'README.md')
        self.assertNotIn('<script>', result)
        self.assertNotIn('href="javascript:', result)
        self.assertIn('<code>a &lt; b</code>', result)

    def test_local_document_links_become_bundle_anchors(self):
        source = ROOT / 'docs/content_map.md'
        self.assertIn('href="#source-', inline('[UI](ux_accessibility.md)', source))
        self.assertNotIn('href=', inline('[UI](ux_accessibility.md)', source, internal_links=False))

    def test_table_code_and_paragraphs(self):
        value = '# Title\n\n| A | B |\n| --- | --- |\n| 1 | 2 |\n\n```dart\nx < 2\n```\n\nLine\ncontinued.'
        result = markdown(value, Path('example.md'))
        self.assertIn('<h1>Title</h1>', result)
        self.assertIn('<td>2</td>', result)
        self.assertIn('<pre>x &lt; 2</pre>', result)
        self.assertIn('<p>Line continued.</p>', result)

    def test_broken_table_and_fence_fail(self):
        for value in ('```\nnot closed', '| A | B |\n| --- | --- |\n| 1 |'):
            with self.assertRaises(ValueError):
                markdown(value, Path('example.md'))

    def test_all_sources_and_ten_slides_render_without_external_assets(self):
        pages = build_html()
        self.assertIn('НЕ ПРОВЕДЕНА', pages['companion'])
        self.assertEqual(pages['presentation'].count('<article>'), 10)
        self.assertEqual(pages['presentation'].count('src="data:image/png;base64,'), 3)
        for page in pages.values():
            self.assertNotIn('file://', page)
            self.assertNotIn('src="http', page)
            self.assertNotIn('href="javascript:', page)


if __name__ == '__main__':
    unittest.main()
