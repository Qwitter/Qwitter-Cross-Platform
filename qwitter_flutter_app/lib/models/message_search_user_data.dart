class MessageSearchUserData {
  MessageSearchUserData({
    required this.imagePath,
    required this.name,
    required this.userName,
    required this.isFollowing,
    required this.isFollowed,
    required this.inConversation,
  });
  final String? imagePath;
  final String name;
  final String userName;
  final bool isFollowing;
  final bool isFollowed;
  final bool inConversation;
}
