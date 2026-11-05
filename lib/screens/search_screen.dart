import 'dart:async';

import 'package:flutter/material.dart';

import '../services/movie_api.dart';
import '../widgets/movie_grid.dart';

class SearchScreen extends StatefulWidget {
  final MovieApi api;

  const SearchScreen({super.key, required this.api});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _query = value.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar películas...',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Escribe el nombre de una película'))
          : MovieGrid(
              // La key fuerza a recrear la grilla cuando cambia la búsqueda
              key: ValueKey(_query),
              loader: (page) => widget.api.search(_query, page: page),
            ),
    );
  }
}
