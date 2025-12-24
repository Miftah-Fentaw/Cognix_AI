import 'package:flutter/material.dart';

class QAScreen extends StatefulWidget {
  final List<String> questions;
  final List<String> answers;

  const QAScreen({super.key, required this.questions, required this.answers});

  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  int currentIndex = 0;
  int score = 0;
  List<int?> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    selectedChoices = List<int?>.filled(widget.questions.length, null);
  }

  void selectAnswer(int choiceIndex, List<String> choices) {
    setState(() {
      selectedChoices[currentIndex] = choiceIndex;
      if (choices[choiceIndex] == widget.answers[currentIndex]) score++;

      if (currentIndex < widget.questions.length - 1) {
        currentIndex++;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Finished'),
        content: Text('Your score: $score / ${widget.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('❓ Q&A')),
        body: const Center(child: Text('No questions available')),
      );
    }

    // Generate choices: answer + dummy options
    List<String> choices = [widget.answers[currentIndex]];
    int dummyCount = 3;
    for (int i = 0; i < dummyCount; i++) {
      choices.add('Option ${i + 1}');
    }
    choices.shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${currentIndex + 1} / ${widget.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.questions[currentIndex],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              choices.length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedChoices[currentIndex] == i
                        ? Colors.blue
                        : null,
                  ),
                  onPressed: () => selectAnswer(i, choices),
                  child: Text(choices[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
