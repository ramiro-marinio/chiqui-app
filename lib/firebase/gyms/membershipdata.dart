class MembershipData {
  final String userId;
  final String gymId;
  MembershipData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        gymId = json['gymId'];
  MembershipData({required this.userId, required this.gymId});
  Map<String, String> toJson() {
    return {
      'userId': userId,
      'gymId': gymId,
    };
  }
}
