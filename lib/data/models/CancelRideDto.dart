class CancelRideDto {
  final bool success;
  final String message;

  CancelRideDto({
    required this.success,
    required this.message,
  });

  factory CancelRideDto.fromJson(Map<String, dynamic> json) {
    return CancelRideDto(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
