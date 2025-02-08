import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A screen that displays user profile information and settings.
/// 
/// This screen shows user details, statistics, and provides access to various
/// account-related actions through a menu interface.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileAvatar(),
            const SizedBox(height: 16),
            _buildUserInfo(context),
            const SizedBox(height: 32),
            _buildStatistics(context),
            const SizedBox(height: 32),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  /// Builds the profile avatar section
  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      child: const Icon(
        Icons.person,
        size: 50,
        color: AppTheme.primaryColor,
      ),
    );
  }

  /// Builds the user information section
  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          'John Doe',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'john.doe@example.com',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Builds the statistics section showing user activity metrics
  Widget _buildStatistics(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(context, '12', 'Reviews'),
        _buildStatItem(context, '8', 'Restaurants'),
        _buildStatItem(context, '4.5', 'Avg Rating'),
      ],
    );
  }

  /// Builds a single statistic item
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Builds the menu items section
  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.edit,
          title: 'Edit Profile',
          onTap: () {
            // TODO: Implement edit profile functionality
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications,
          title: 'Notifications',
          onTap: () {
            // TODO: Implement notifications functionality
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            // TODO: Implement settings functionality
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.help,
          title: 'Help & Support',
          onTap: () {
            // TODO: Implement help & support functionality
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  /// Builds a single menu item
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 