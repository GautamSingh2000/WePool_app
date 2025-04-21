class CancelRideDto {
  final bool success;
  final String message;

  CancelRideDto({
    required this.success,
    required this.message,
  });

  factory CancelRideDto.fromJson(Map<String, dynamic> json) {
    final msg = json['message'];
    String messageStr;

    if (msg is List) {
      messageStr = msg.join(', '); // join list into a single string
    } else if (msg is String) {
      messageStr = msg;
    } else {
      messageStr = 'Unexpected message format';
    }

    return CancelRideDto(
      success: json['success'],
      message: messageStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
