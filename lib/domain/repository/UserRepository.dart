import '../../data/models/LoginResponseDto.dart';
import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/VerifyForgetPasswordOtpDto.dart';
import '../../data/models/verifyOtpDto.dart';

abstract class UserRepository {
  Future<RegistrationResponseDto> userRegistration(Map<String, dynamic> userData);
  Future<LoginResponseDto> userLogin(Map<String,dynamic> credentials);
  Future<VerifyOtpDto> verifyOtp(Map<String,dynamic> data);
  Future<VerifyForgetPasswordOtpDto> verifyForgetPasswordOtp(Map<String,dynamic> data);
  Future<VerifyOtpDto> forgetPassword(Map<String,dynamic> data);
  Future<VerifyOtpDto> resetPassword(Map<String,dynamic> data);
}