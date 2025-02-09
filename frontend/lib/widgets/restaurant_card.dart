import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';

/// A card widget that displays restaurant information and allows user interaction.
/// 
/// This widget shows restaurant details including name, description, rating,
/// and provides functionality for submitting reviews.
class RestaurantCard extends StatelessWidget {
  /// The restaurant data to display
  final Restaurant restaurant;
  
  /// Controller for the review text input
  final TextEditingController reviewController;
  
  /// Callback function when review is submitted
  final VoidCallback onSubmit;
  
  /// Whether the card is expanded to show review input
  final bool isExpanded;
  
  /// Callback function when card is tapped
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.reviewController,
    required this.onSubmit,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            _buildHeader(context),
            if (isExpanded) _buildReviewSection(context),
          ],
        ),
      ),
    );
  }

  /// Builds the header section of the card containing restaurant information
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRestaurantAvatar(context),
          const SizedBox(width: 16),
          Expanded(
            child: _buildRestaurantInfo(context),
          ),
          _buildExpandIcon(),
        ],
      ),
    );
  }

  /// Builds the restaurant avatar/icon
  Widget _buildRestaurantAvatar(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          restaurant.name[0],
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  /// Builds the restaurant information section
  Widget _buildRestaurantInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          restaurant.description,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildRatingBar(context),
      ],
    );
  }

  /// Builds the rating bar display
  Widget _buildRatingBar(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: (restaurant.score + 5) / 2, // Convert -5 to 5 scale to 0 to 5
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: AppTheme.primaryColor,
          ),
          itemCount: 5,
          itemSize: 20.0,
        ),
        const SizedBox(width: 8),
        Text(
          restaurant.score.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Builds the expand/collapse icon
  Widget _buildExpandIcon() {
    return Icon(
      isExpanded ? Icons.expand_less : Icons.expand_more,
      color: AppTheme.subtitleColor,
    );
  }

  /// Builds the review input section when card is expanded
  Widget _buildReviewSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              hintText: 'Share your experience...',
              prefixIcon: Icon(Icons.rate_review_outlined),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit Review'),
          ),
        ],
      ),
    ).animate().slideY(
      begin: -0.2,
      end: 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
} 