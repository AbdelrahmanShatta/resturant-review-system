import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  final _reviewController = TextEditingController();
  List<Review> _reviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ApiService();
      final reviews = await apiService.getRestaurantReviews(widget.restaurant.id);
      setState(() => _reviews = reviews);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a review')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final apiService = ApiService();
      await apiService.submitReview(
        restaurantId: widget.restaurant.id,
        text: _reviewController.text,
        userId: 'user123',
      );
      _reviewController.clear();
      await _loadReviews();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Restaurant Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.restaurant.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://source.unsplash.com/800x600/?restaurant,${widget.restaurant.name}',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Restaurant Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Score
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: (widget.restaurant.score + 5) / 2,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: AppTheme.primaryColor,
                        ),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.restaurant.score.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    widget.restaurant.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Review Input
                  Text(
                    'Write a Review',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      prefixIcon: Icon(Icons.rate_review_outlined),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReview,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Submit Review'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews Section
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),

          // Reviews List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final review = _reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              child: Text(
                                review.userId[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User ${review.userId}',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    review.createdAt.toString(),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: review.sentiment == 'POSITIVE'
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                review.sentiment,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review.text),
                      ],
                    ),
                  ),
                );
              },
              childCount: _reviews.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
} 