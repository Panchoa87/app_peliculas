import 'package:flutter/material.dart';

import '../services/movie_api.dart';
import '../widgets/movie_grid.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final MovieApi api;

  const HomeScreen({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Películas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(api: api)),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Populares'),
              Tab(text: 'En cines'),
              Tab(text: 'Mejor valoradas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MovieGrid(loader: (page) => api.popular(page: page)),
            MovieGrid(loader: (page) => api.nowPlaying(page: page)),
            MovieGrid(loader: (page) => api.topRated(page: page)),
          ],
        ),
      ),
    );
  }
}
