class LoginResponseDto {
  final bool _success;
  final String _message;
  final String? _token;

  LoginResponseDto({
    required bool success,
    required String message,
    String? token,
  })  : _success = success,
        _message = message,
        _token = token;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }

  LoginResponseDto copyWith({
    bool? success,
    String? message,
    String? token,
  }) {
    return LoginResponseDto(
      success: success ?? _success,
      message: message ?? _message,
      token: token ?? _token,
    );
  }

  bool get success => _success;
  String get message => _message;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    return {
      'success': _success,
      'message': _message,
      'token': _token,
    };
  }
}
