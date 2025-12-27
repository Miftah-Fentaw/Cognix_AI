class PersonalInfo {
  String fullName;
  String jobTitle;
  String phone;
  String email;
  String location;
  String? photoPath;

  PersonalInfo({
    this.fullName = '',
    this.jobTitle = '',
    this.phone = '',
    this.email = '',
    this.location = '',
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'jobTitle': jobTitle,
      'phone': phone,
      'email': email,
      'location': location,
      'photoPath': photoPath,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      photoPath: json['photoPath'],
    );
  }
}

class SocialLinks {
  String linkedin;
  String github;
  String portfolio;

  SocialLinks({
    this.linkedin = '',
    this.github = '',
    this.portfolio = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'linkedin': linkedin,
      'github': github,
      'portfolio': portfolio,
    };
  }

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      portfolio: json['portfolio'] ?? '',
    );
  }
}

class WorkExperience {
  String jobTitle;
  String companyName;
  String dateRange;
  String responsibilities;

  WorkExperience({
    this.jobTitle = '',
    this.companyName = '',
    this.dateRange = '',
    this.responsibilities = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'companyName': companyName,
      'dateRange': dateRange,
      'responsibilities': responsibilities,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      jobTitle: json['jobTitle'] ?? '',
      companyName: json['companyName'] ?? '',
      dateRange: json['dateRange'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
    );
  }
}

class Education {
  String degree;
  String institution;
  String dateRange;

  Education({
    this.degree = '',
    this.institution = '',
    this.dateRange = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'dateRange': dateRange,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      dateRange: json['dateRange'] ?? '',
    );
  }
}

class Certification {
  String name;
  String issuedBy;
  String year;

  Certification({
    this.name = '',
    this.issuedBy = '',
    this.year = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuedBy': issuedBy,
      'year': year,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] ?? '',
      issuedBy: json['issuedBy'] ?? '',
      year: json['year'] ?? '',
    );
  }
}

class ResumeData {
  PersonalInfo personalInfo;
  SocialLinks socialLinks;
  String professionalSummary;
  List<WorkExperience> workExperiences;
  List<Education> educations;
  String skills;
  List<Certification> certifications;

  ResumeData({
    PersonalInfo? personalInfo,
    SocialLinks? socialLinks,
    this.professionalSummary = '',
    List<WorkExperience>? workExperiences,
    List<Education>? educations,
    this.skills = '',
    List<Certification>? certifications,
  })  : personalInfo = personalInfo ?? PersonalInfo(),
        socialLinks = socialLinks ?? SocialLinks(),
        workExperiences = workExperiences ?? [WorkExperience()],
        educations = educations ?? [Education()],
        certifications = certifications ?? [Certification()];

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'socialLinks': socialLinks.toJson(),
      'professionalSummary': professionalSummary,
      'workExperiences': workExperiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills,
      'certifications': certifications.map((e) => e.toJson()).toList(),
    };
  }

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      socialLinks: SocialLinks.fromJson(json['socialLinks'] ?? {}),
      professionalSummary: json['professionalSummary'] ?? '',
      workExperiences: (json['workExperiences'] as List?)
          ?.map((e) => WorkExperience.fromJson(e))
          .toList() ?? [WorkExperience()],
      educations: (json['educations'] as List?)
          ?.map((e) => Education.fromJson(e))
          .toList() ?? [Education()],
      skills: json['skills'] ?? '',
      certifications: (json['certifications'] as List?)
          ?.map((e) => Certification.fromJson(e))
          .toList() ?? [Certification()],
    );
  }
}