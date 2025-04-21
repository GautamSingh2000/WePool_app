import 'dart:async';


import 'package:we_pool_app/data/models/GetAllVehicleDto.dart';
import 'package:we_pool_app/data/models/UpcomingRideDto.dart';

import '../../api/ap_client.dart';
import '../../api/api_endpoints.dart';
import '../../domain/repository/UserRepository.dart';
import '../../services/HiveHelper.dart';
import '../../utils/constants.dart';
import '../models/CancelRideDto.dart';
import '../models/LoginResponseDto.dart';
import '../models/RegistrationResponseDto.dart';
import '../models/VerifyForgetPasswordOtpDto.dart';
import '../models/CommonResponseDto.dart';

class UserRepositoryImp implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImp(this.apiClient);

  //for registration
  @override
  Future<RegistrationResponseDto> userRegistration(Map<String, dynamic> userData) async {
    final response = await apiClient.post(ApiEndpoints.registration, body:userData);
    return RegistrationResponseDto.fromJson(response);
  }

  //for login
  @override
  Future<LoginResponseDto> userLogin(Map<String, dynamic> credentials) async {
    final response = await apiClient.post(ApiEndpoints.login,body:credentials);
    return LoginResponseDto.fromJson(response);
  }

  //verify otp
  @override
  Future<CommonResponseDto> verifyOtp(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.verify_otp,body:data);
    return CommonResponseDto.fromJson(response);
  }

  //Forget Password
  @override
  Future<CommonResponseDto> forgetPassword(Map<String, dynamic> data) async{
    final response = await apiClient.post(ApiEndpoints.forget_password,body:data);
    return CommonResponseDto.fromJson(response);
  }

  //verfy otp after forget password
  @override
  Future<VerifyForgetPasswordOtpDto> verifyForgetPasswordOtp(Map<String, dynamic> data) async{
    final response = await apiClient.post(ApiEndpoints.forget_password_otp,body:data);
    return VerifyForgetPasswordOtpDto.fromJson(response);
  }


  //reset Password
  @override
  Future<CommonResponseDto> resetPassword(Map<String, dynamic> data) async{
    final response = await apiClient.post(ApiEndpoints.rest_password,body:data);
    return CommonResponseDto.fromJson(response);
  }

  @override
  Future<CommonResponseDto> addNewVehicle(Map<String, dynamic> data) async{
    final token = HiveHelper.getData(AppConstants.TOKEN);
    print("token value in api call $token");
    if (token == null) {throw Exception("Authorization token not found in Hive");}
    final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
    final response = await apiClient.post(ApiEndpoints.add_new_vehicle,body: data , headers: headers);
    return CommonResponseDto.fromJson(response);
  }

  @override
  Future<GetAllVehicleDto> getAllVehicles() async {
      final token = HiveHelper.getData(AppConstants.TOKEN);
      print("token value in api call $token");
      if (token == null) {throw Exception("Authorization token not found in Hive");}
      final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
      final response = await apiClient.get(ApiEndpoints.get_all_vehicle, headers: headers,);
      return GetAllVehicleDto.fromJson(response);
    }

  @override
  Future<CommonResponseDto> publishRide(Map<String, dynamic> data) async {
    final token = HiveHelper.getData(AppConstants.TOKEN);
    print("token value in api call $token");
    if (token == null) {throw Exception("Authorization token not found in Hive");}
    final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
    final response = await apiClient.post(ApiEndpoints.publish_ride,body: data, headers: headers,);
    return CommonResponseDto.fromJson(response);
  }

  @override
  Future<UpcomingRideDto> upcomingRides() async {
    final token = HiveHelper.getData(AppConstants.TOKEN);
    print("token value in api call $token");
    if (token == null) {throw Exception("Authorization token not found in Hive");}
    final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
    final response = await apiClient.post(ApiEndpoints.upcoming_ride, headers: headers);
    return UpcomingRideDto.fromJson(response);
  }

  @override
  Future<CancelRideDto> deleteRide(Map<String, String> data) async {
    final token = HiveHelper.getData(AppConstants.TOKEN);
    print("token value in api call $token");
    if (token == null) {throw Exception("Authorization token not found in Hive");}
    final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
    final response = await apiClient.delete(ApiEndpoints.cancel_ride, body : data , headers: headers);
    print("response from delete ride ${response}");
    return CancelRideDto.fromJson(response);
  }

  @override
  Future<CommonResponseDto> updateRide(Map<String, dynamic> data) async {
    final token = HiveHelper.getData(AppConstants.TOKEN);
    print("token value in api call $token");
    if (token == null) {throw Exception("Authorization token not found in Hive");}
    final headers = {'Authorization': 'Bearer $token', 'Accept': '*/*',};
    final response = await apiClient.put(ApiEndpoints.update_ride,body: data, headers: headers);
    print("response from delete ride ${response}");
    return CommonResponseDto.fromJson(response);
  }


}

