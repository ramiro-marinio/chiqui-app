class DemonstrationData {
  String id;
  final String? gymId;
  final String exerciseName;
  final bool repUnit;
  final String? description;
  final List<String> workAreas;
  final String? advice;
  String? resourceURL;
  String? resourceName;
  DemonstrationData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        exerciseName = json['exerciseName'],
        repUnit = json['repUnit'],
        description = json['description'],
        workAreas = List.generate((json['workAreas'] as List).length,
            (index) => json['workAreas'][index] as String),
        advice = json['advice'],
        resourceURL = json['resourceURL'],
        resourceName = json['resourceName'],
        gymId = json['gymId'];
  DemonstrationData({
    required this.exerciseName,
    required this.repUnit,
    this.description,
    required this.workAreas,
    this.advice,
    this.resourceURL,
    required this.id,
    this.gymId,
  });
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'repUnit': repUnit,
      'description': description,
      'workAreas': workAreas,
      'advice': advice,
      'resourceURL': resourceURL,
      'resourceName': resourceName,
      'gymId': gymId,
      'id': id,
    };
  }
}
