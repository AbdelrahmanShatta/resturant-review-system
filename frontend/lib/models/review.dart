class Review {
  final String id;
  final String restaurantId;
  final String text;
  final String userId;
  final String sentiment;
  final double score;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.restaurantId,
    required this.text,
    required this.userId,
    required this.sentiment,
    required this.score,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      restaurantId: json['restaurant_id'] ?? '',
      text: json['text'] ?? '',
      userId: json['user_id'] ?? '',
      sentiment: json['sentiment'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'text': text,
      'user_id': userId,
    };
  }
} 