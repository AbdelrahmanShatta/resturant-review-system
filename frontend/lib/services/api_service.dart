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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception(
            'Connection timeout. Please check if the backend server is running.'
          );
        },
      );

      developer.log('Leaderboard response status: ${response.statusCode}');
      developer.log('Leaderboard response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching leaderboard', error: e, stackTrace: stackTrace);
      if (e is http.ClientException) {
        throw Exception('Cannot connect to server. Please check if the backend is running.');
      }
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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching reviews', error: e, stackTrace: stackTrace);
      if (e is http.ClientException) {
        throw Exception('Cannot connect to server. Please check if the backend is running.');
      }
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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        return Review.fromJson(json.decode(response.body));
      } else {
        throw _handleErrorResponse(response);
      }
    } catch (e, stackTrace) {
      developer.log('Error submitting review', error: e, stackTrace: stackTrace);
      if (e is http.ClientException) {
        throw Exception('Cannot connect to server. Please check if the backend is running.');
      }
      rethrow;
    }
  }

  Exception _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return Exception(errorData['error'] ?? 'Unknown error occurred');
    } catch (_) {
      switch (response.statusCode) {
        case 404:
          return Exception('Resource not found');
        case 500:
          return Exception('Server error. Please try again later.');
        default:
          return Exception('Error: ${response.statusCode}');
      }
    }
  }
} 