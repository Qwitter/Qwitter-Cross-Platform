import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_menu.dart';

void main() {
  testWidgets('TweetMenu Widget Test', (WidgetTester tester) async {
    bool menuModalOpened = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: TweetMenu(
              opentweetMenuModal: () {
                menuModalOpened = true;
              },
            ),
          ),
        ),
      ),
    );

    final moreVertIcon = find.byIcon(Icons.more_vert);

    expect(moreVertIcon, findsOneWidget);

    await tester.tap(moreVertIcon);

    // Check if the modal should have opened after tapping the icon
    expect(menuModalOpened, true);
  });
}