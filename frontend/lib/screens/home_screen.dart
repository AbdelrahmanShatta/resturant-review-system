import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, TextEditingController> _reviewControllers = {};
  List<Restaurant> _leaderboard = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    try {
      final apiService = context.read<ApiService>();
      final leaderboard = await apiService.getLeaderboard();
      setState(() {
        _leaderboard = leaderboard;
        // Initialize controllers for new restaurants
        for (var restaurant in leaderboard) {
          if (!_reviewControllers.containsKey(restaurant.id)) {
            _reviewControllers[restaurant.id] = TextEditingController();
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview(String restaurantId) async {
    final controller = _reviewControllers[restaurantId];
    if (controller == null || controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review')),
      );
      return;
    }

    try {
      final apiService = context.read<ApiService>();
      await apiService.submitReview(
        restaurantId: restaurantId,
        text: controller.text,
        userId: 'user123', // In a real app, this would come from auth
      );
      controller.clear();
      await _loadLeaderboard();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final restaurant = _leaderboard[index];
                final controller = _reviewControllers[restaurant.id];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(restaurant.name),
                    subtitle: Text('Score: ${restaurant.score.toStringAsFixed(1)}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(restaurant.description),
                            const SizedBox(height: 16),
                            if (controller != null) TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                labelText: 'Write a review',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _submitReview(restaurant.id),
                              child: const Text('Submit Review'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
} 