class DemonstrationData {
  final String exerciseName;
  final bool repUnit;
  final String? description;
  final List<String>? muscles;
  final List<String>? advice;
  final String? resourceURL;
  final String? resourceFormat;
  DemonstrationData.fromJson(Map<String, dynamic> json)
      : exerciseName = json['exerciseName'],
        repUnit = json['repUnit'],
        description = json['description'],
        muscles = json['muscles'],
        advice = json['advice'],
        resourceURL = json['resourceURL'],
        resourceFormat = json['resourceFormat'];
  DemonstrationData({
    required this.exerciseName,
    required this.repUnit,
    this.description,
    this.muscles,
    this.advice,
    this.resourceURL,
    this.resourceFormat,
  });
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'repUnit': repUnit,
      'description': description,
      'muscles': muscles,
      'advice': advice,
      'resourceURL': resourceURL,
      'resourceFormat': resourceFormat,
    };
  }
}
