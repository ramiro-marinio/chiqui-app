class UserData {
  final String userId;
  String info;
  String displayName;
  String? photoURL;
  bool sex;
  DateTime birthDay;
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
        birthDay = DateTime.fromMillisecondsSinceEpoch(
          map['birthDay'] as int,
        ),
        stature = (map['stature'] as double?) ?? 175,
        weight = (map['weight'] as double?) ?? 70,
        staff = map['staff'] as bool,
        injuries = (map['injuries'] as String?) ?? '';
  UserData({
    required this.userId,
    required this.info,
    required this.sex,
    required this.birthDay,
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
      'birthDay': birthDay.millisecondsSinceEpoch,
      'staff': staff,
      'displayName': displayName,
      'photoURL': photoURL,
      'stature': stature,
      'weight': weight,
      'injuries': injuries,
    };
  }
}
