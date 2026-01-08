import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';

class PromoSlider extends StatelessWidget {
  PromoSlider({super.key});

  final List<Map<String, dynamic>> promoCards = const [
    {
      'title': 'Smart Translation',
      'discount': 'Free',
      'subtitle': 'Translate any text in real-time in more than 6 languages',
      'color1': Color(0xFFFF7700),
      'color2': Color(0xFFFF7700),
      'buttonText': 'Try Now',
    },
    {
      'title': 'Smart Resume',
      'discount': "Free",
      'subtitle': 'Create a professional resume in minutes',
      'color1': Color(0xFF021BFF),
      'color2': Color(0xFF021BFF),
      'buttonText': 'Check Now',
    },
    {
      'title': 'Are you tutor/teacher?',
      'discount': 'Free',
      'subtitle': 'Generate learning materials for your students',
      'color1': Color(0xFFFF0000),
      'color2': Color(0xFFFF0000),
      'buttonText': 'Generate Now',
    },
    {
      'title': 'File Conversion',
      'discount': 'Free',
      'subtitle': 'Convert Multiple file formats images, pdf, doc,...in minutes',
      'color1': Color(0xFF00A6FF),
      'color2': Color(0xFF00A6FF),
      'buttonText': 'Try Now',
    },
    {
      'title': 'File Analyser',
      'discount':'Free',
      'subtitle':'Analyze files to get detailed and structured information about them',
      'color1': Color(0xFFD400FF),
      'color2': Color(0xFFD400FF),
      'buttonText': 'Try it out',
    },
  ];

  final List<String> screens = [
    'translator',
    'resume',
    'filegenerator',
    'converter',
    'chat',
  ];



  @override
  Widget build(BuildContext context) {
    //function to be called on navigation to route to destination screen
  void _onButtonPressed(int index) {
    context.push('/${screens[index]}');
  }

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
                    _onButtonPressed(index);
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
