import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/review.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<List<Restaurant>> getLeaderboard({int limit = 10}) async {
    try {
      developer.log('Fetching leaderboard from: $baseUrl/leaderboard?limit=$limit');
      
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      developer.log('Leaderboard response status: ${response.statusCode}');
      developer.log('Leaderboard response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching leaderboard', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<List<Review>> getRestaurantReviews(String restaurantId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?restaurantId=$restaurantId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching reviews', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Review> submitReview({
    required String restaurantId,
    required String text,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'restaurantId': restaurantId,
          'text': text,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to submit review: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      developer.log('Error submitting review', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
} 