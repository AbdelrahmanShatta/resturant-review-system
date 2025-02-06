class Restaurant {
  final String id;
  final String name;
  final String description;
  final double score;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    this.score = 0,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'score': score,
    };
  }
} 