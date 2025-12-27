import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_models.dart';
import 'resume_input_field.dart';
import 'resume_section.dart';

class WorkExperienceWidget extends StatefulWidget {
  final List<WorkExperience> workExperiences;
  final Function(List<WorkExperience>) onChanged;
  final VoidCallback onShowTip;

  const WorkExperienceWidget({
    super.key,
    required this.workExperiences,
    required this.onChanged,
    required this.onShowTip,
  });

  @override
  State<WorkExperienceWidget> createState() => _WorkExperienceWidgetState();
}

class _WorkExperienceWidgetState extends State<WorkExperienceWidget> {
  List<Map<String, TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    controllers.clear();
    for (int i = 0; i < widget.workExperiences.length; i++) {
      final exp = widget.workExperiences[i];
      final controllerMap = {
        'jobTitle': TextEditingController(text: exp.jobTitle),
        'companyName': TextEditingController(text: exp.companyName),
        'dateRange': TextEditingController(text: exp.dateRange),
        'responsibilities': TextEditingController(text: exp.responsibilities),
      };

      // Add listeners
      controllerMap['jobTitle']!.addListener(() => _updateExperience(i));
      controllerMap['companyName']!.addListener(() => _updateExperience(i));
      controllerMap['dateRange']!.addListener(() => _updateExperience(i));
      controllerMap['responsibilities']!.addListener(() => _updateExperience(i));

      controllers.add(controllerMap);
    }
  }

  void _updateExperience(int index) {
    if (index < widget.workExperiences.length) {
      widget.workExperiences[index].jobTitle = controllers[index]['jobTitle']!.text;
      widget.workExperiences[index].companyName = controllers[index]['companyName']!.text;
      widget.workExperiences[index].dateRange = controllers[index]['dateRange']!.text;
      widget.workExperiences[index].responsibilities = controllers[index]['responsibilities']!.text;
      widget.onChanged(widget.workExperiences);
    }
  }

  void _addExperience() {
    setState(() {
      widget.workExperiences.add(WorkExperience());
      _initializeControllers();
      widget.onChanged(widget.workExperiences);
    });
  }

  void _removeExperience(int index) {
    if (widget.workExperiences.length > 1) {
      setState(() {
        // Dispose controllers
        controllers[index].values.forEach((controller) => controller.dispose());
        
        widget.workExperiences.removeAt(index);
        _initializeControllers();
        widget.onChanged(widget.workExperiences);
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
      title: 'Work Experience',
      subtitle: 'Your professional work history',
      icon: Icons.work_history_outlined,
      tipMessage: 'List your work experience in reverse chronological order (most recent first). Use bullet points to describe achievements, not just duties. Quantify your impact with numbers, percentages, or specific results whenever possible.',
      onTipPressed: widget.onShowTip,
      child: Column(
        children: [
          ...List.generate(widget.workExperiences.length, (index) {
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
                          'Experience ${index + 1}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      if (widget.workExperiences.length > 1)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeExperience(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ResumeInputField(
                    label: 'Job Title',
                    hint: 'Senior Software Developer',
                    controller: controllers[index]['jobTitle']!,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Job title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ResumeInputField(
                    label: 'Company Name',
                    hint: 'Tech Solutions Inc.',
                    controller: controllers[index]['companyName']!,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Company name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ResumeInputField(
                    label: 'Date Range',
                    hint: 'Jan 2020 - Present',
                    controller: controllers[index]['dateRange']!,
                  ),
                  const SizedBox(height: 16),
                  ResumeInputField(
                    label: 'Key Responsibilities & Achievements',
                    hint: '• Led development of mobile applications\n• Increased user engagement by 40%\n• Mentored junior developers',
                    controller: controllers[index]['responsibilities']!,
                    maxLines: 3,
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addExperience,
              icon: Icon(Icons.add, color: Colors.orange),
              label: Text(
                'Add Another Experience',
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