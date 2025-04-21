import 'package:we_pool_app/data/models/GetAllVehicleDto.dart';

import '../../data/models/CancelRideDto.dart';
import '../../data/models/LoginResponseDto.dart';
import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/UpcomingRideDto.dart';
import '../../data/models/VerifyForgetPasswordOtpDto.dart';
import '../../data/models/CommonResponseDto.dart';

abstract class UserRepository {
  Future<RegistrationResponseDto> userRegistration(Map<String, dynamic> userData);
  Future<LoginResponseDto> userLogin(Map<String,dynamic> credentials);
  Future<CommonResponseDto> verifyOtp(Map<String,dynamic> data);
  Future<VerifyForgetPasswordOtpDto> verifyForgetPasswordOtp(Map<String,dynamic> data);
  Future<CommonResponseDto> forgetPassword(Map<String,dynamic> data);
  Future<CommonResponseDto> resetPassword(Map<String,dynamic> data);
  Future<CommonResponseDto> addNewVehicle(Map<String,dynamic> data);
  Future<GetAllVehicleDto> getAllVehicles();
  Future<CommonResponseDto> publishRide(Map<String,dynamic> data);
  Future<CancelRideDto> deleteRide(Map<String,String> data);
  Future<UpcomingRideDto> upcomingRides();
}