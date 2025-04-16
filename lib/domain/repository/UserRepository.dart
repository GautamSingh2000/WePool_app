import 'package:we_pool_app/data/models/GetAllVehicleDto.dart';

import '../../data/models/LoginResponseDto.dart';
import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/UpcomingRideDto.dart';
import '../../data/models/VerifyForgetPasswordOtpDto.dart';
import '../../data/models/verifyOtpDto.dart';

abstract class UserRepository {
  Future<RegistrationResponseDto> userRegistration(Map<String, dynamic> userData);
  Future<LoginResponseDto> userLogin(Map<String,dynamic> credentials);
  Future<VerifyOtpDto> verifyOtp(Map<String,dynamic> data);
  Future<VerifyForgetPasswordOtpDto> verifyForgetPasswordOtp(Map<String,dynamic> data);
  Future<VerifyOtpDto> forgetPassword(Map<String,dynamic> data);
  Future<VerifyOtpDto> resetPassword(Map<String,dynamic> data);
  Future<VerifyOtpDto> addNewVehicle(Map<String,dynamic> data);
  Future<GetAllVehicleDto> getAllVehicles();
  Future<VerifyOtpDto> publishRide(Map<String,dynamic> data);
  Future<UpcomingRideDto> upcomingRides();
}