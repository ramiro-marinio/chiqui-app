class MembershipData {
  final String userId;
  final String gymId;
  final bool coach;
  final bool admin;
  MembershipData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        gymId = json['gymId'],
        coach = json['coach'] ?? false,
        admin = json['admin'] ?? false;
  MembershipData(
      {required this.userId,
      required this.gymId,
      required this.coach,
      required this.admin});
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'gymId': gymId,
      'coach': coach,
      'admin': admin,
    };
  }
}
