class DemonstrationData {
  final String? id;
  final String? gymId;
  final String exerciseName;
  final bool repUnit;
  final String? description;
  final List workAreas;
  final String? advice;
  String? resourceURL;
  String? resourceFormat;
  DemonstrationData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        exerciseName = json['exerciseName'],
        repUnit = json['repUnit'],
        description = json['description'],
        workAreas = json['muscles'],
        advice = json['advice'],
        resourceURL = json['resourceURL'],
        resourceFormat = json['resourceFormat'],
        gymId = json['gymId'];
  DemonstrationData({
    required this.exerciseName,
    required this.repUnit,
    this.description,
    required this.workAreas,
    this.advice,
    this.resourceURL,
    this.resourceFormat,
    this.id,
    this.gymId,
  });
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'repUnit': repUnit,
      'description': description,
      'muscles': workAreas,
      'advice': advice,
      'resourceURL': resourceURL,
      'resourceFormat': resourceFormat,
      'gymId': gymId,
    };
  }
}
