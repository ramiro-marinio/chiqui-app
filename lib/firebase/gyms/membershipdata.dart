class MembershipData {
  final String userId;
  final String gymId;
  final bool coach;
  final bool admin;
  final bool accepted;
  MembershipData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        gymId = json['gymId'],
        coach = json['coach'] ?? false,
        admin = json['admin'] ?? false,
        accepted = json['accepted'] ?? true;
  MembershipData(
      {required this.userId,
      required this.gymId,
      required this.coach,
      required this.admin,
      required this.accepted});
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'gymId': gymId,
      'coach': coach,
      'admin': admin,
      'accepted': accepted
    };
  }
}
