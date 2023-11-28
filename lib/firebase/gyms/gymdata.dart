class GymData {
  final String ownerId;
  String name;
  String? description;
  String? photoURL;
  GymData.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'],
        name = json['name'],
        description = json['description'],
        photoURL = json['photoURL'];
  GymData(
      {required this.ownerId,
      required this.name,
      this.description,
      this.photoURL});
  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'photoURL': photoURL
    };
  }
}
