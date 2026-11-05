import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_api.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final Future<Map<String, dynamic>> _details;

  @override
  void initState() {
    super.initState();
    _details = MovieApi().details(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: movie.backdropUrl == null
                  ? Container(color: Colors.grey.shade900)
                  : Image.network(movie.backdropUrl!, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (movie.posterUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Hero(
                            tag: 'poster-${movie.id}',
                            child: Image.network(movie.posterUrl!, width: 110),
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('${movie.voteAverage.toStringAsFixed(1)} / 10'),
                            ]),
                            const SizedBox(height: 4),
                            Text(movie.releaseDate),
                            FutureBuilder(
                              future: _details,
                              builder: (_, snap) {
                                final d = snap.data;
                                if (d == null) return const SizedBox.shrink();
                                final genres = (d['genres'] as List)
                                    .map((g) => g['name'])
                                    .join(', ');
                                final runtime = d['runtime'] ?? 0;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    [if (runtime > 0) '$runtime min', genres]
                                        .where((s) => s.isNotEmpty)
                                        .join(' · '),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Sinopsis', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(movie.overview.isEmpty
                      ? 'Sin sinopsis disponible.'
                      : movie.overview),
                  const SizedBox(height: 24),
                  _CastSection(details: _details),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CastSection extends StatelessWidget {
  final Future<Map<String, dynamic>> details;

  const _CastSection({required this.details});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: details,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null) {
          return const SizedBox.shrink();
        }
        final cast = (snap.data!['credits']?['cast'] as List? ?? []).take(15);
        if (cast.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reparto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final actor = cast.elementAt(i);
                  final photo = actor['profile_path'];
                  return SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: photo == null
                              ? null
                              : NetworkImage(
                                  'https://image.tmdb.org/t/p/w185$photo'),
                          child: photo == null ? const Icon(Icons.person) : null,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          actor['name'] ?? '',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
