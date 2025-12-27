import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/resume_models.dart';
import 'resume_input_field.dart';
import 'resume_section.dart';

class PersonalInfoWidget extends StatefulWidget {
  final PersonalInfo personalInfo;
  final Function(PersonalInfo) onChanged;
  final VoidCallback onPhotoUpload;
  final VoidCallback onShowTip;

  const PersonalInfoWidget({
    super.key,
    required this.personalInfo,
    required this.onChanged,
    required this.onPhotoUpload,
    required this.onShowTip,
  });

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  late final TextEditingController fullNameController;
  late final TextEditingController jobTitleController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.personalInfo.fullName);
    jobTitleController = TextEditingController(text: widget.personalInfo.jobTitle);
    phoneController = TextEditingController(text: widget.personalInfo.phone);
    emailController = TextEditingController(text: widget.personalInfo.email);
    locationController = TextEditingController(text: widget.personalInfo.location);

    fullNameController.addListener(() {
      widget.personalInfo.fullName = fullNameController.text;
      widget.onChanged(widget.personalInfo);
    });
    jobTitleController.addListener(() {
      widget.personalInfo.jobTitle = jobTitleController.text;
      widget.onChanged(widget.personalInfo);
    });
    phoneController.addListener(() {
      widget.personalInfo.phone = phoneController.text;
      widget.onChanged(widget.personalInfo);
    });
    emailController.addListener(() {
      widget.personalInfo.email = emailController.text;
      widget.onChanged(widget.personalInfo);
    });
    locationController.addListener(() {
      widget.personalInfo.location = locationController.text;
      widget.onChanged(widget.personalInfo);
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    jobTitleController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = widget.personalInfo;

    return ResumeSection(
      title: 'Personal Information',
      subtitle: 'Your basic contact details',
      icon: Icons.person_outline,
      tipMessage: 'Use your full legal name as it appears on official documents. Choose a professional job title that matches your target role. Include a professional photo with good lighting and neutral background.',
      onTipPressed: widget.onShowTip,
      child: Column(
        children: [
          ResumeInputField(
            label: 'Full Name',
            hint: 'John Doe',
            icon: Icons.person_outline,
            controller: fullNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ResumeInputField(
            label: 'Job Title',
            hint: 'Software Developer',
            icon: Icons.work_outline,
            controller: jobTitleController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Job title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ResumeInputField(
                  label: 'Phone',
                  hint: '+1 (555) 123-4567',
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ResumeInputField(
                  label: 'Email',
                  hint: 'john@example.com',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ResumeInputField(
            label: 'Location',
            hint: 'New York, NY',
            icon: Icons.location_on_outlined,
            controller: locationController,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: widget.onPhotoUpload,
                icon: Icon(Icons.photo_camera_outlined, size: 18),
                label: Text(
                  personalInfo.photoPath != null ? 'Change Photo' : 'Upload Photo',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.grey[700],
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (personalInfo.photoPath != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Photo uploaded',
                        style: GoogleFonts.inter(
                          color: Colors.green[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}