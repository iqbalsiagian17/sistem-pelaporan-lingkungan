class ParameterItem {
  final int id;
  final String? about;
  final String? terms;
  final String? reportGuidelines;
  final String? emergencyContact;
  final String? ambulanceContact;
  final String? policeContact;
  final String? firefighterContact;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParameterItem({
    required this.id,
    this.about,
    this.terms,
    this.reportGuidelines,
    this.emergencyContact,
    this.ambulanceContact,
    this.policeContact,
    this.firefighterContact,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParameterItem.fromJson(Map<String, dynamic> json) {
    return ParameterItem(
      id: json['id'],
      about: json['about'],
      terms: json['terms'],
      reportGuidelines: json['report_guidelines'],
      emergencyContact: json['emergency_contact'],
      ambulanceContact: json['ambulance_contact'],
      policeContact: json['police_contact'],
      firefighterContact: json['firefighter_contact'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about': about,
      'terms': terms,
      'report_guidelines': reportGuidelines,
      'emergency_contact': emergencyContact,
      'ambulance_contact': ambulanceContact,
      'police_contact': policeContact,
      'firefighter_contact': firefighterContact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
