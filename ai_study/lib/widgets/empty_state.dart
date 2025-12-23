import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Image.asset("assets/cognix.png", height: 50,),
          SizedBox(height: 16),
          Text('Welcome to Cognix'),
          SizedBox(height: 8),
          Text('Paste text to get summaries, notes, and Q&A'),
        ],
      ),
    );
  }
}
