import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key});

  final List<Map<String, dynamic>> promoCards = const [
    {
      'title': 'Subscribe and get discount',
      'discount': '20%',
      'subtitle': 'Unlock all premium AI tools',
      'color1': Color(0xFF8B0000),
      'color2': Color(0xFFD32F2F),
    },
    {
      'title': 'Limited Time Offer',
      'discount': '50%',
      'subtitle': 'First month at half price!',
      'color1': Color(0xFF6A1B9A),
      'color2': Color(0xFF9C27B0),
    },
    {
      'title': 'Pro Plan Special',
      'discount': '30% OFF',
      'subtitle': 'Annual billing saves more',
      'color1': Color(0xFF1565C0),
      'color2': Color(0xFF1976D2),
    },
    {
      'title': 'Student Deal',
      'discount': '40%',
      'subtitle': 'Exclusive for verified students',
      'color1': Color(0xFF2E7D32),
      'color2': Color(0xFF388E3C),
    },
    {
      'title': 'Free Trial',
      'discount': '7 Days Free',
      'subtitle': 'No card required',
      'color1': Color(0xFFE65100),
      'color2': Color(0xFFF57C00),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Unchanged
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Cognix AI',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.lightbulb, color: Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // FULL WIDTH STACKED CARD SWIPER
            SizedBox(
              height: 250, // Adjust height as needed
              child: CardSwiper(
                cardsCount: promoCards.length,
                isLoop: true, // Infinite loop
                numberOfCardsDisplayed: 3, // Shows 3 cards stacked
                backCardOffset: const Offset(0, 40), // Stacking depth
                scale: 0.9, // Smaller scale for back cards
                padding: const EdgeInsets.symmetric(horizontal: 16), // Small side padding
                allowedSwipeDirection: const AllowedSwipeDirection.all(),
                cardBuilder: (context, index, percentX, percentY) {
                  final card = promoCards[index];

                  return Container(
                    width: double.infinity, // Full width
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [card['color1'], card['color2']],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              card['discount'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              card['subtitle'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle subscription
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: card['color1'],
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Get Offer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 100),

            // Grid of AI Features - Completely Unchanged
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _featureCard('assets/icons/text.png', 'Text Analyser'),
                    _featureCard('assets/icons/file.png', 'File Analyser'),
                    _featureCard('assets/icons/file2.png', 'Academic File Generator'),
                    _featureCard('assets/icons/resume.png', 'Resume Generator'),
                    _featureCard('assets/icons/lock.png', 'Answer Interviewer'),
                    _featureCard('assets/icons/lock.png', 'Password Generator'),
                    _featureCard('assets/icons/lock.png', 'Advertiser'),
                    _featureCard('assets/icons/lock.png', 'Dream Interpreter'),
                    _featureCard('assets/icons/settings.png', 'Settings'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(String path, String title) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to feature screen
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              path,
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
        ),
      ),
    );
  }
}