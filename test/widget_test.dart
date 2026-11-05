import 'package:flutter_test/flutter_test.dart';

import 'package:app_peliculas/main.dart';

void main() {
  testWidgets('Muestra aviso si falta la API key', (tester) async {
    await tester.pumpWidget(const PeliculasApp());
    expect(find.textContaining('Falta la API key'), findsOneWidget);
  });
}
