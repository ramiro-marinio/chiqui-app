class UserData {
  final String userId;
  String info;
  String displayName;
  String? photoURL;
  bool sex;
  DateTime birthDay;
  final bool staff;
  UserData.fromJson(Map<String, dynamic> map)
      : userId = map['userId'] as String,
        info = map['info'] as String,
        displayName = map['displayName'] as String,
        photoURL = map['photoURL'] as String?,
        sex = map['sex'] as bool,
        birthDay = DateTime.fromMillisecondsSinceEpoch(
          map['birthDay'] as int,
        ),
        staff = map['staff'] as bool;
  UserData({
    required this.userId,
    required this.info,
    required this.sex,
    required this.birthDay,
    required this.staff,
    required this.displayName,
    this.photoURL,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'info': info,
      'sex': sex,
      'birthDay': birthDay.millisecondsSinceEpoch,
      'staff': staff,
      'displayName': displayName,
      'photoUrl': photoURL
    };
  }
}
