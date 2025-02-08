import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, TextEditingController> _reviewControllers = {};
  final Set<String> _expandedCards = {};
  List<Restaurant> _leaderboard = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  @override
  void dispose() {
    for (var controller in _reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = context.read<ApiService>();
      final leaderboard = await apiService.getLeaderboard();
      setState(() {
        _leaderboard = leaderboard;
        for (var restaurant in leaderboard) {
          if (!_reviewControllers.containsKey(restaurant.id)) {
            _reviewControllers[restaurant.id] = TextEditingController();
          }
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview(String restaurantId) async {
    final controller = _reviewControllers[restaurantId];
    if (controller == null || controller.text.isEmpty) {
      _showSnackBar('Please enter a review', isError: true);
      return;
    }

    try {
      final apiService = context.read<ApiService>();
      await apiService.submitReview(
        restaurantId: restaurantId,
        text: controller.text,
        userId: 'user123',
      );
      controller.clear();
      await _loadLeaderboard();
      _showSnackBar('Review submitted successfully');
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 150,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: 100,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadLeaderboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Restaurant Reviews',
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: false,
          displayFullTextOnTap: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadLeaderboard,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingShimmer()
          : _error != null
              ? _buildErrorView()
              : ListView.builder(
                  itemCount: _leaderboard.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemBuilder: (context, index) {
                    final restaurant = _leaderboard[index];
                    final isExpanded = _expandedCards.contains(restaurant.id);
                    return RestaurantCard(
                      restaurant: restaurant,
                      reviewController: _reviewControllers[restaurant.id]!,
                      onSubmit: () => _submitReview(restaurant.id),
                      isExpanded: isExpanded,
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedCards.remove(restaurant.id);
                          } else {
                            _expandedCards.add(restaurant.id);
                          }
                        });
                      },
                    );
                  },
                ),
    );
  }
} 