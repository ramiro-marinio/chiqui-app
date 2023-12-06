class InviteData {
  final String code;
  final String gymId;
  InviteData.fromJson(Map<String, dynamic> json)
      : code = json['code'] as String,
        gymId = json['gymId'] as String;
  InviteData({required this.code, required this.gymId});
  Map<String, String> toJson() {
    return {
      'code': code,
      'gymId': gymId,
    };
  }
}
