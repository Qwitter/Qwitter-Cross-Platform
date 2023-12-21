class Trend {
  final String hashtag;
  final int count;
  Trend({required this.count, required this.hashtag});

  factory Trend.fromJson(Map<String, dynamic> trend) {
    return Trend(count: trend['count'], hashtag: trend['trend']);
  }
}
