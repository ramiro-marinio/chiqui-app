class GymData {
  final String ownerId;
  String? id;
  String name;
  String? description;
  String? photoURL;
  GymData.fromJson(Map<String, dynamic> json)
      : ownerId = json['ownerId'],
        name = json['name'],
        description = json['description'],
        photoURL = json['photoURL'],
        id = json['id'];
  GymData(
      {required this.ownerId,
      required this.name,
      this.description,
      this.photoURL,
      this.id});
  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'photoURL': photoURL,
      'id': id,
    };
  }
}
