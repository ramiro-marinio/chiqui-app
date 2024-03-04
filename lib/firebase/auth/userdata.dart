class UserData {
  final String userId;
  String info;
  String displayName;
  String? photoURL;
  bool sex;
  DateTime birthday;
  double stature;
  double weight;
  String injuries;
  final bool staff;
  UserData.fromJson(Map<String, dynamic> map)
      : userId = map['userId'] as String,
        info = map['info'] as String,
        displayName = map['displayName'] as String,
        photoURL = map['photoURL'] as String?,
        sex = map['sex'] as bool,
        birthday = DateTime.fromMillisecondsSinceEpoch(
          (map['birthday'] as num?)?.toInt() ?? 0,
        ),
        stature = (map['stature'] as num?)?.toDouble() ?? 175,
        weight = (map['weight'] as num?)?.toDouble() ?? 70,
        staff = map['staff'] as bool,
        injuries = (map['injuries'] as String?) ?? '';
  UserData({
    required this.userId,
    required this.info,
    required this.sex,
    required this.birthday,
    required this.staff,
    required this.displayName,
    required this.weight,
    required this.stature,
    required this.injuries,
    this.photoURL,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'info': info,
      'sex': sex,
      'birthday': birthday.millisecondsSinceEpoch,
      'staff': staff,
      'displayName': displayName.trim().isNotEmpty ? displayName : 'New User',
      'photoURL': photoURL,
      'stature': stature,
      'weight': weight,
      'injuries': injuries,
    };
  }
}
