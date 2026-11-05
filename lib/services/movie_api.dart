import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

/// Cliente para la API de TMDB (https://www.themoviedb.org).
/// La API key se pasa al compilar: --dart-define=TMDB_API_KEY=tu_clave
class MovieApi {
  static const _apiKey = String.fromEnvironment('TMDB_API_KEY');
  static const _host = 'api.themoviedb.org';
  static const _language = 'es-ES';

  final http.Client _client;

  MovieApi({http.Client? client}) : _client = client ?? http.Client();

  static bool get hasApiKey => _apiKey.isNotEmpty;

  Future<List<Movie>> popular({int page = 1}) =>
      _getMovies('/3/movie/popular', {'page': '$page'});

  Future<List<Movie>> nowPlaying({int page = 1}) =>
      _getMovies('/3/movie/now_playing', {'page': '$page'});

  Future<List<Movie>> topRated({int page = 1}) =>
      _getMovies('/3/movie/top_rated', {'page': '$page'});

  Future<List<Movie>> search(String query, {int page = 1}) =>
      _getMovies('/3/search/movie', {'query': query, 'page': '$page'});

  Future<Map<String, dynamic>> details(int movieId) =>
      _get('/3/movie/$movieId', {'append_to_response': 'credits'});

  Future<List<Movie>> _getMovies(String path, Map<String, String> params) async {
    final data = await _get(path, params);
    final results = data['results'] as List<dynamic>;
    return results
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> _get(
      String path, Map<String, String> params) async {
    final uri = Uri.https(_host, path, {
      'api_key': _apiKey,
      'language': _language,
      ...params,
    });
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode} al consultar la API');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
