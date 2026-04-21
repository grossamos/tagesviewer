import 'article_preview.dart';

class ArticleDetail extends ArticlePreview {
  final List<String> bodyParagraphs;
  final List<ArticlePreview> relatedArticles;

  const ArticleDetail({
    required super.topline,
    required super.headline,
    required super.shorttext,
    required super.imageUrl,
    required super.url,
    required this.bodyParagraphs,
    required this.relatedArticles,
  });
}
