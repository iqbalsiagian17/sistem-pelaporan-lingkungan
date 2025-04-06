class ParameterEntity {
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

  ParameterEntity({
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
}
