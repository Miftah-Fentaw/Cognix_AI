import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_models.dart';
import 'resume_input_field.dart';
import 'resume_section.dart';

class CertificationsWidget extends StatefulWidget {
  final List<Certification> certifications;
  final Function(List<Certification>) onChanged;
  final VoidCallback onShowTip;

  const CertificationsWidget({
    super.key,
    required this.certifications,
    required this.onChanged,
    required this.onShowTip,
  });

  @override
  State<CertificationsWidget> createState() => _CertificationsWidgetState();
}

class _CertificationsWidgetState extends State<CertificationsWidget> {
  List<Map<String, TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    controllers.clear();
    for (int i = 0; i < widget.certifications.length; i++) {
      final cert = widget.certifications[i];
      final controllerMap = {
        'name': TextEditingController(text: cert.name),
        'issuedBy': TextEditingController(text: cert.issuedBy),
        'year': TextEditingController(text: cert.year),
      };

      // Add listeners
      controllerMap['name']!.addListener(() => _updateCertification(i));
      controllerMap['issuedBy']!.addListener(() => _updateCertification(i));
      controllerMap['year']!.addListener(() => _updateCertification(i));

      controllers.add(controllerMap);
    }
  }

  void _updateCertification(int index) {
    if (index < widget.certifications.length) {
      widget.certifications[index].name = controllers[index]['name']!.text;
      widget.certifications[index].issuedBy = controllers[index]['issuedBy']!.text;
      widget.certifications[index].year = controllers[index]['year']!.text;
      widget.onChanged(widget.certifications);
    }
  }

  void _addCertification() {
    setState(() {
      widget.certifications.add(Certification());
      _initializeControllers();
      widget.onChanged(widget.certifications);
    });
  }

  void _removeCertification(int index) {
    if (widget.certifications.length > 1) {
      setState(() {
        // Dispose controllers
        controllers[index].values.forEach((controller) => controller.dispose());
        
        widget.certifications.removeAt(index);
        _initializeControllers();
        widget.onChanged(widget.certifications);
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
      title: 'Certifications & Awards',
      subtitle: 'Additional qualifications and achievements',
      icon: Icons.emoji_events_outlined,
      tipMessage: 'Include relevant certifications, professional licenses, awards, or recognitions. Focus on recent certifications (within 3-5 years) unless they\'re evergreen credentials. Include the issuing organization and date.',
      onTipPressed: widget.onShowTip,
      child: Column(
        children: [
          ...List.generate(widget.certifications.length, (index) {
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
                          'Certification ${index + 1}',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      if (widget.certifications.length > 1)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeCertification(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ResumeInputField(
                    label: 'Certification or Award',
                    hint: 'Google Cloud Professional Developer',
                    controller: controllers[index]['name']!,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ResumeInputField(
                          label: 'Issued By',
                          hint: 'Google Cloud',
                          controller: controllers[index]['issuedBy']!,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ResumeInputField(
                          label: 'Year',
                          hint: '2023',
                          controller: controllers[index]['year']!,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addCertification,
              icon: Icon(Icons.add, color: Colors.orange),
              label: Text(
                'Add Another Certificate',
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