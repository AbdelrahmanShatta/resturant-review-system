import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/restaurant.dart';
import '../theme/app_theme.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final TextEditingController reviewController;
  final VoidCallback onSubmit;
  final bool isExpanded;
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
            // Restaurant Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Icon/Avatar
                  Container(
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
                  ),
                  const SizedBox(width: 16),
                  // Restaurant Info
                  Expanded(
                    child: Column(
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
                        // Score Display
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: (restaurant.score + 5) / 2, // Convert -5 to 5 scale to 0 to 5
                              itemBuilder: (context, index) => const Icon(
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
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Icon
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppTheme.subtitleColor,
                  ),
                ],
              ),
            ),
            // Review Section
            if (isExpanded)
              Container(
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
              ),
          ],
        ),
      ),
    );
  }
} 