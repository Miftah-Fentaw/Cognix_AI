// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cognix/models/AIResponse.dart';
import 'package:google_fonts/google_fonts.dart';

class QAScreen extends StatefulWidget {
  final List<QuizQuestion> quiz;

  const QAScreen({super.key, required this.quiz});

  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedOption;

  void _checkAnswer(String option) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedOption = option;
      if (option == widget.quiz[_currentIndex].answer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.quiz.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedOption = null;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text('Quiz Completed!',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'You scored $_score out of ${widget.quiz.length}',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child:
                const Text('Close', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quiz.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("No questions generated.")),
      );
    }

    final question = widget.quiz[_currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Quiz (${_currentIndex + 1}/${widget.quiz.length})',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / widget.quiz.length,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                  const SizedBox(height: 30),

                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      question.question,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: question.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final option = question.options[index];
                        final isSelected = _selectedOption == option;
                        final isCorrect = option == question.answer;

                        // Determine colors based on state
                        Color borderColor = Colors.white24;
                        Color bgColor = Colors.transparent;
                        IconData? icon;

                        if (_answered) {
                          if (isCorrect) {
                            borderColor = Colors.green;
                            bgColor = Colors.green.withOpacity(0.2);
                            icon = Icons.check_circle;
                          } else if (isSelected) {
                            borderColor = Colors.red;
                            bgColor = Colors.red.withOpacity(0.2);
                            icon = Icons.cancel;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _checkAnswer(option),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (icon != null)
                                  Icon(icon, color: borderColor),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (_answered)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: FilledButton(
                        onPressed: _nextQuestion,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _currentIndex == widget.quiz.length - 1
                              ? 'Finish Quiz'
                              : 'Next Question',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
