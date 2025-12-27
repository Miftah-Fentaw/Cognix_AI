import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({super.key});

  final List<Map<String, dynamic>> promoCards = const [
    {
      'title': 'First month at half price!',
      'discount': '50%',
      'subtitle': 'Get access to some of our AI tools',
      'color1': Color.fromARGB(255, 255, 119, 0),
      'color2': Color.fromARGB(255, 255, 119, 0),
      'buttonText': 'Get Offer',
    },
    {
      'title': 'Get Premium Plan',
      'discount': "20 per month",
      'subtitle': 'Get access to all AI tools',
      'color1': Color.fromARGB(231, 2, 27, 255),
      'color2': Color.fromARGB(231, 2, 27, 255),
      'buttonText': 'Subscribe',
    },
    {
      'title': 'Are you tutor/teacher?',
      'discount': 'Free',
      'subtitle': 'Generate learning materials for your students',
      'color1': Color.fromARGB(255, 255, 0, 0),
      'color2': Color.fromARGB(255, 255, 0, 0),
      'buttonText': 'Generate Now',
    },
    {
      'title': 'Stunning Resume',
      'discount': '3 trials per month',
      'subtitle': 'Creating a professional resume in minutes',
      'color1': Color.fromARGB(255, 0, 166, 255),
      'color2': Color.fromARGB(255, 0, 166, 255),
      'buttonText': 'Try Now',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Adjust height as needed
      child: CardSwiper(
        cardsCount: promoCards.length,
        isLoop: true, // Infinite loop
        numberOfCardsDisplayed: 3, // Shows 3 cards stacked
        backCardOffset: const Offset(0, 40), // Stacking depth
        scale: 0.9, // Smaller scale for back cards
        padding:
            const EdgeInsets.symmetric(horizontal: 16), // Small side padding
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
                  child: Text(
                    card['buttonText'],
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
    );
  }
}
