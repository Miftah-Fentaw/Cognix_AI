import 'package:flutter/material.dart';

class ConversionProgressCard extends StatelessWidget {
  final double progress;
  final bool isConverting;

  const ConversionProgressCard({
    super.key,
    required this.progress,
    required this.isConverting,
  });

  @override
  Widget build(BuildContext context) {
    if (!isConverting && progress == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sync,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConverting ? 'Converting...' : 'Conversion Complete!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isConverting && progress == 1.0)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF34C759),
                  size: 24,
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF5F5F7),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
