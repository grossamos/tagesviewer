import 'package:flutter/material.dart';

import '../models/article_preview.dart';
import '../services/tagesschau_service.dart';
import '../widgets/article_card.dart';
import 'article_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = TagesschauService();
  late Future<List<ArticlePreview>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchHomepage();
  }

  void _refresh() {
    final next = _service.fetchHomepage();
    setState(() { _future = next; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tagesviewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<ArticlePreview>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Fehler: ${snapshot.error}'));
          }
          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text('Keine Artikel gefunden.'));
          }
          return RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              itemCount: articles.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleScreen(url: article.url),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
