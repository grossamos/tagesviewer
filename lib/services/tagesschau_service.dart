import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

import '../models/article_detail.dart';
import '../models/article_preview.dart';

const _base = 'https://www.tagesschau.de';

class TagesschauService {
  final http.Client _client;

  TagesschauService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ArticlePreview>> fetchHomepage() async {
    final response = await _client.get(Uri.parse(_base));
    final document = html_parser.parse(response.body);
    return document
        .querySelectorAll('div.teaser')
        .map(_parsePreviewFromTeaser)
        .where((a) => a.url.isNotEmpty && a.headline.isNotEmpty)
        .toList();
  }

  Future<ArticleDetail> fetchArticle(String url) async {
    final fullUrl = url.startsWith('http') ? url : '$_base$url';
    final response = await _client.get(Uri.parse(fullUrl));
    final document = html_parser.parse(response.body);

    final topline =
        document.querySelector('span.article-head__topline')?.text.trim() ?? '';
    final headline =
        document
            .querySelector('span.article-head__headline--text')
            ?.text
            .trim() ??
        '';
    final shorttext =
        document
            .querySelector('p.article-head__shorttext')
            ?.text
            .trim() ??
        '';
    final imageUrl = _extractImageUrl(document.querySelector('img.ts-image'));

    final bodyParagraphs = document
        .querySelectorAll('p.textabsatz')
        .map((e) => e.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final related = [
      ...document
          .querySelectorAll('div.teaser-absatz')
          .map(_parsePreviewFromTeaserAbsatz),
      ...document
          .querySelectorAll('li.teaser-xs')
          .map(_parsePreviewFromTeaserXs),
    ]
        .where((a) => a.url.isNotEmpty && a.headline.isNotEmpty)
        .toList();

    return ArticleDetail(
      topline: topline,
      headline: headline,
      shorttext: shorttext,
      imageUrl: imageUrl,
      url: fullUrl,
      bodyParagraphs: bodyParagraphs,
      relatedArticles: related,
    );
  }

  ArticlePreview _parsePreviewFromTeaser(Element el) {
    final link = el.querySelector('a.teaser__link');
    final href = _resolveUrl(link?.attributes['href'] ?? '');
    return ArticlePreview(
      topline: el.querySelector('span.teaser__topline')?.text.trim() ?? '',
      headline: el.querySelector('span.teaser__headline')?.text.trim() ?? '',
      shorttext: el.querySelector('p.teaser__shorttext')?.text.trim() ?? '',
      imageUrl: _extractImageUrl(el.querySelector('img.ts-image')),
      url: href,
    );
  }

  ArticlePreview _parsePreviewFromTeaserAbsatz(Element el) {
    final link = el.querySelector('a.teaser-absatz__link');
    final href = _resolveUrl(link?.attributes['href'] ?? '');
    return ArticlePreview(
      topline:
          el.querySelector('span.teaser-absatz__topline')?.text.trim() ?? '',
      headline:
          el.querySelector('span.teaser-absatz__headline')?.text.trim() ?? '',
      shorttext:
          el.querySelector('p.teaser-absatz__shorttext')?.text.trim() ?? '',
      imageUrl: _extractImageUrl(el.querySelector('img.ts-image')),
      url: href,
    );
  }

  ArticlePreview _parsePreviewFromTeaserXs(Element el) {
    final link = el.querySelector('a.teaser-xs__link');
    final href = _resolveUrl(link?.attributes['href'] ?? '');
    return ArticlePreview(
      topline: el.querySelector('span.teaser-xs__topline')?.text.trim() ?? '',
      headline: el.querySelector('span.teaser-xs__headline')?.text.trim() ?? '',
      shorttext: '',
      imageUrl: _extractImageUrl(
        el.querySelector('img.teaser-xs__image') ??
            el.querySelector('img.ts-image'),
      ),
      url: href,
    );
  }

  String _extractImageUrl(Element? img) {
    if (img == null) return '';
    final src = img.attributes['src'] ?? '';
    return src.startsWith('http') ? src : '$_base$src';
  }

  String _resolveUrl(String href) {
    if (href.isEmpty) return '';
    if (href.startsWith('http')) return href;
    return '$_base$href';
  }
}
