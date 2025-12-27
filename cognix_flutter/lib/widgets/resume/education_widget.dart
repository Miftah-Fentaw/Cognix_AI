import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_models.dart';
import 'resume_input_field.dart';
import 'resume_section.dart';

class EducationWidget extends StatefulWidget {
  final List<Education> educations;
  final Function(List<Education>) onChanged;
  final VoidCallback onShowTip;

  const EducationWidget({
    super.key,
    required this.educations,
    required this.onChanged,
    required this.onShowTip,
  });

  @override
  State<EducationWidget> createState() => _EducationWidgetState();
}

class _EducationWidgetState extends State<EducationWidget> {
  List<Map<String, TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    controllers.clear();
    for (int i = 0; i < widget.educations.length; i++) {
      final edu = widget.educations[i];
      final controllerMap = {
        'degree': TextEditingController(text: edu.degree),
        'institution': TextEditingController(text: edu.institution),
        'dateRange': TextEditingController(text: edu.dateRange),
      };

      // Add listeners
      controllerMap['degree']!.addListener(() => _updateEducation(i));
      controllerMap['institution']!.addListener(() => _updateEducation(i));
      controllerMap['dateRange']!.addListener(() => _updateEducation(i));

      controllers.add(controllerMap);
    }
  }

  void _updateEducation(int index) {
    if (index < widget.educations.length) {
      widget.educations[index].degree = controllers[index]['degree']!.text;
      widget.educations[index].institution = controllers[index]['institution']!.text;
      widget.educations[index].dateRange = controllers[index]['dateRange']!.text;
      widget.onChanged(widget.educations);
    }
  }

  void _addEducation() {
    setState(() {
      widget.educations.add(Education());
      _initializeControllers();
      widget.onChanged(widget.educations);
    });
  }

  void _removeEducation(int index) {
    if (widget.educations.length > 1) {
      setState(() {
        // Dispose controllers
        controllers[index].values.forEach((controller) => controller.dispose());
        
        widget.educations.removeAt(index);
        _initializeControllers();
        widget.onChanged(widget.educations);
      });
    }
  }

  @override
  void dispose() {
    for (var controllerMap in controllers) {
      controllerMap.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResumeSection(
      title: 'Education',
      subtitle: 'Your academic background',
      icon: Icons.school_outlined,
      tipMessage: 'Include your highest degree first, then other relevant education. Mention honors, relevant coursework, or academic achievements if they strengthen your application. Include GPA only if it\'s 3.5 or higher.',
      onTipPressed: widget.onShowTip,
      child: Column(
        children: [
          ...List.generate(widget.educations.length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Education ${index + 1}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      if (widget.educations.length > 1)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeEducation(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ResumeInputField(
                    label: 'Degree / Qualification',
                    hint: 'Bachelor of Computer Science',
                    controller: controllers[index]['degree']!,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Degree is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ResumeInputField(
                    label: 'Institution',
                    hint: 'University of Technology',
                    controller: controllers[index]['institution']!,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Institution is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ResumeInputField(
                    label: 'Date Range',
                    hint: '2016 - 2020',
                    controller: controllers[index]['dateRange']!,
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addEducation,
              icon: Icon(Icons.add, color: Colors.orange),
              label: Text(
                'Add Another Education',
                style: GoogleFonts.outfit(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}