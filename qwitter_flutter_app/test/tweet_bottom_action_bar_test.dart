import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/Components/tweet/tweet_bottom_action_bar.dart';

void main() {
  testWidgets('TweetBottomActionBar Widget Test', (WidgetTester tester) async {
    // Create a test widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: TweetBottomActionBar(
              commentsCount: 5,
              repostsCount: 10,
              likesCount: 15,
              makeFollow: () {},
              makeComment: () {},
              openRepostModal: () {},
              makeLike: () {},
              reposted: false,
              liked: false,
            ),
          ),
        ),
      ),
    );

    // Find the icons and text widgets
    final commentIcon = find.byIcon(Icons.chat_bubble_outline);
    final repostIcon = find.byIcon(Icons.repeat_outlined);
    final likeIcon = find.byIcon(Icons.favorite_border);
    final shareIcon = find.byIcon(Icons.share_outlined);

    final commentText = find.text('5');
    final repostText = find.text('10');
    final likeText = find.text('15');

    // Verify if the widgets are present
    expect(commentIcon, findsOneWidget);
    expect(repostIcon, findsOneWidget);
    expect(likeIcon, findsOneWidget);
    expect(shareIcon, findsOneWidget);

    expect(commentText, findsOneWidget);
    expect(repostText, findsOneWidget);
    expect(likeText, findsOneWidget);

    // Perform a tap on the comment icon and verify the action
    await tester.tap(commentIcon);
    // Add further expectations for the action triggered by the comment icon

    // Perform a tap on the repost icon and verify the action
    await tester.tap(repostIcon);
    // Add further expectations for the action triggered by the repost icon

    // Perform a tap on the like icon and verify the action
    await tester.tap(likeIcon);
    // Add further expectations for the action triggered by the like icon

    // Perform a tap on the share icon and verify the action
    await tester.tap(shareIcon);
    // Add further expectations for the action triggered by the share icon
  });
}
