import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/movie_api.dart';

void main() {
  runApp(const PeliculasApp());
}

class PeliculasApp extends StatelessWidget {
  const PeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Películas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: MovieApi.hasApiKey
          ? HomeScreen(api: MovieApi())
          : const _MissingKeyScreen(),
    );
  }
}

class _MissingKeyScreen extends StatelessWidget {
  const _MissingKeyScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Falta la API key de TMDB.\n\nEjecuta la app con:\n'
            'flutter run --dart-define=TMDB_API_KEY=tu_clave',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
