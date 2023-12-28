import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/select_languages_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('SelectLanguagesScreen widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: SelectLanguagesScreen(),
      ),
    ));

    // Verify the presence of certain widgets
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(CustomScrollView), findsWidgets);
    expect(find.byType(SliverToBoxAdapter), findsWidgets);
    expect(find.text('Select your language(s)'), findsWidgets);
  });
}
