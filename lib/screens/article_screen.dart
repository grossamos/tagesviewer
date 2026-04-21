import 'package:flutter/material.dart';

import '../models/article_detail.dart';
import '../services/tagesschau_service.dart';
import '../widgets/article_card.dart';

class ArticleScreen extends StatefulWidget {
  final String url;

  const ArticleScreen({super.key, required this.url});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _service = TagesschauService();
  late Future<ArticleDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchArticle(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('tagesviewer')),
      body: FutureBuilder<ArticleDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          final article = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (article.topline.isNotEmpty)
                Text(
                  article.topline,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                article.headline,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (article.shorttext.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  article.shorttext,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (article.imageUrl.isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ...article.bodyParagraphs.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(p, style: theme.textTheme.bodyMedium),
                ),
              ),
              if (article.relatedArticles.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Weitere Meldungen',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...article.relatedArticles.map(
                  (related) => ArticleCard(
                    article: related,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleScreen(url: related.url),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
