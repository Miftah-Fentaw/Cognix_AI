// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final bool isLocked;

  const FeatureCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLocked ? _buildLockedContent() : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 48,
          height: 48,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLockedContent() {
    return Stack(
      children: [
        // Main content
        Center(child: _buildContent()),
        // Shadow overlay with lock icon
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Subscribe to Unlock',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
