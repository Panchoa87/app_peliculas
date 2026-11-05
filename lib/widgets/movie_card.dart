import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: 'poster-${movie.id}',
                child: movie.posterUrl == null
                    ? Container(
                        color: Colors.grey.shade800,
                        child: const Center(child: Icon(Icons.movie, size: 48)),
                      )
                    : Image.network(
                        movie.posterUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Text(movie.year, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
