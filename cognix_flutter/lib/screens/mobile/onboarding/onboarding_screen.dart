import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognix/config/router.dart';
import '../../../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      image: 'assets/cognix.gif',
      title: 'Welcome to Cognix',
      description: 'Your advanced AI companion for smarter, faster learning.',
    ),
    OnboardingSlide(
      image: 'assets/images_one.png',
      title: 'Study Smarter',
      description:
          'Generate summaries, notes, and quizzes instantly from any text.',
    ),
    OnboardingSlide(
      image: 'assets/images_two.png',
      title: 'Achieve More',
      description:
          'Track your progress and master your subjects with AI-powered insights.',
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSeenKey, true);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSeenKey, true);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _slides[index].image,
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay (Bottom to Mid)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Content Overlay
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _slides[_currentPage].title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _slides[_currentPage].description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 32 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFF6366f1) // Indigo accent
                                  : Colors.white24,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Action Button
                      if (_currentPage == _slides.length - 1)
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _completeOnboarding,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF6366f1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 8,
                                shadowColor:
                                  const Color(0xFF6366f1).withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _skipOnboarding,
                              child: Text(
                                "Skip",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Next",
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final String image;
  final String title;
  final String description;

  OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });
}
