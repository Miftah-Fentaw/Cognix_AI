import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cognix/config/router.dart';
import 'package:cognix/widgets/chat_drawer.dart';
import 'package:cognix/widgets/home/feature_card.dart';
import 'package:cognix/widgets/home/promo_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({super.key});

  void lock_dialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.lock, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'You must subscribe to unlock this premium feature. Get access to all AI tools with our subscription plan.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Upgrade Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          SystemNavigator.pop(); // Exit the app
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        drawer: ChatDrawer(
          onShowHistory: () {
            context.push(AppRoutes.chatHistory);
          },
          onResumeHistory: () {
            context.push(AppRoutes.resumeHistory);
          },
          onShowSettings: () {
            context.push(AppRoutes.settings);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cognix AI',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bubble_chart,
                        color: Colors.orange,
                        size: 28,
                      ),
                      onPressed: () => AwesomeDialog(
                        context: context,
                        dialogBackgroundColor: Colors.transparent,
                        animType: AnimType.topSlide,
                        dialogType: DialogType.info,
                        body: Center(
                          child: Text(
                            // help message about app crashing and premium feature
                            ' - premium features are only available for premium users\n'
                            ' - app may crash if you try to use premium features without a subscription\n'
                            ' - resume generated from resume generation highly depend on the data you give\n'
                            ' - some features of the app still being developed, wait coming soon',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        title: 'This is Ignored',
                        desc: 'This is also Ignored',
                        btnOkOnPress: () {},
                      )..show(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // FULL WIDTH STACKED CARD SWIPER
              const PromoSlider(),

              const SizedBox(height: 100),

              // Grid of AI Features
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      FeatureCard(
                          iconPath: 'assets/icons/text.png',
                          title: 'Text Analyser',
                          onTap: () {
                            context.go(AppRoutes.chat);
                          }),
                      FeatureCard(
                          iconPath: 'assets/icons/file.png',
                          title: 'File Analyser',
                          onTap: () {
                            context.go(AppRoutes.chat);
                          }),
                      FeatureCard(
                          iconPath: 'assets/icons/file2.png',
                          title: 'Academic File Generator',
                          onTap: () {
                            context.go(AppRoutes.premiumFeature);
                          }),
                      FeatureCard(
                          iconPath: 'assets/icons/resume.png',
                          title: 'Resume Generator',
                          onTap: () {
                            context.go(AppRoutes.resume);
                          }),
                      FeatureCard(
                          iconPath: 'assets/icons/ad.png',
                          title: 'Ad Maker',
                          onTap: () => lock_dialogue(context),
                          isLocked: true),
                      FeatureCard(
                          iconPath: 'assets/icons/presentation.png',
                          title: 'Presentation Builder',
                          onTap: () => lock_dialogue(context),
                          isLocked: true),
                      FeatureCard(
                          iconPath: 'assets/icons/code.png',
                          title: 'Code Generator',
                          onTap: () => lock_dialogue(context),
                          isLocked: true),
                      FeatureCard(
                          iconPath: 'assets/icons/translator.png',
                          title: 'Smart Translator',
                          onTap: () => lock_dialogue(context),
                          isLocked: true),
                      FeatureCard(
                          iconPath: 'assets/icons/settings.png',
                          title: 'Settings',
                          onTap: () {
                            context.push(AppRoutes.settings);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
