class MessageData {
  final String message;
  final String gymId;
  final String senderId;
  final String? receiverId;
  final int timestamp;
  MessageData.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String,
        gymId = json['gymId'] as String,
        senderId = json['senderId'] as String,
        receiverId = json['receiverId'] as String?,
        timestamp = json['timestamp'] as int;
  MessageData(
      {required this.message,
      required this.gymId,
      required this.senderId,
      required this.receiverId,
      required this.timestamp});
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'gymId': gymId,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }
}
