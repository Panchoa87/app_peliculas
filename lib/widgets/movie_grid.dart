import 'package:flutter/material.dart';

import '../models/movie.dart';
import 'movie_card.dart';

/// Grilla de películas con paginación infinita.
class MovieGrid extends StatefulWidget {
  final Future<List<Movie>> Function(int page) loader;

  const MovieGrid({super.key, required this.loader});

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid>
    with AutomaticKeepAliveClientMixin {
  final _movies = <Movie>[];
  final _scroll = ScrollController();
  int _page = 0;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) {
        _loadMore();
      }
    });
    _loadMore();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final next = await widget.loader(_page + 1);
      setState(() {
        _page++;
        _movies.addAll(next);
        _hasMore = next.isNotEmpty;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _movies.clear();
      _page = 0;
      _hasMore = true;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_movies.isEmpty && _loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_movies.isEmpty && _error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _refresh, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    if (_movies.isEmpty) {
      return const Center(child: Text('No se encontraron películas'));
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: GridView.builder(
        controller: _scroll,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: _movies.length,
        itemBuilder: (_, i) => MovieCard(movie: _movies[i]),
      ),
    );
  }
}
