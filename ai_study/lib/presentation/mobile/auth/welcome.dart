import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Dark overlay
          // Container(color: Colors.black.withOpacity(0.6)),

          Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
            
                    // 🔹 Top Grid Item (Icon + Text)
                    Align(
                      alignment: AlignmentGeometry.center,
                      child: Row(
                        children: const [
                            Icon(Icons.psychology, color: Colors.white, size: 40),
                            SizedBox(height: 15),
                            Text(
                              'Cognix AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                      ),
                    ),
            
                    const SizedBox(height: 20),
            
                    // 🔹 Let's get started
                    const Text(
                      "Let's get started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            
                    const SizedBox(height: 30),
            
                    // 🔹 Fixed Grid (Sign In / Sign Up)
                    Row(
                      children: [
                        Expanded(
                          child: _authButton(
                            text: 'Sign In',
                            filled: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _authButton(
                            text: 'Sign Up',
                            filled: true,
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 20),
            
                    // 🔹 OR Text
                    const Text(
                      'or',
                      style: TextStyle(color: Colors.white70),
                    ),
            
                    const SizedBox(height: 20),
            
                    // 🔹 Continue with Google (Full Width)
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            height: 22,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            
                    const Spacer(),
            
                    // 🔹 Bottom Center Text
                    Column(
                      children: const [
                        Text(
                          'Cognix AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Your academic partner',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Button
  Widget _authButton({required String text, required bool filled}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: filled
            ? null
            : Border.all(color: Colors.white, width: 1.2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: filled ? Colors.black : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
