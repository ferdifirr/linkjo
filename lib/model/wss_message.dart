class WssMessage {
  final String type;
  final String message;

  WssMessage({required this.type, required this.message});

  factory WssMessage.fromJson(Map<String, dynamic> json) {
    return WssMessage(
      type: json['type'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'message': message,
      };
}
