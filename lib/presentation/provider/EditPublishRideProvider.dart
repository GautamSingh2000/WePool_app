import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/presentation/GlobalScreen.dart';
import 'package:we_pool_app/utils/RLSLideTransition.dart';
import 'package:we_pool_app/utils/colors.dart';

import '../../data/models/CancelRideDto.dart';
import '../../data/models/GetAllVehicleDto.dart';
import '../../data/models/CommonResponseDto.dart';
import '../../domain/use_case/DeleteRideUseCase.dart';
import '../../domain/use_case/GetAllVehiclesUseCase.dart';

class EditPublishRideProvider extends ChangeNotifier {

  final GetAllVehiclesUseCase getAllVehiclesUseCase;
  final DeleteRideUseCase deleteRideUseCase;
  EditPublishRideProvider(this.getAllVehiclesUseCase, this.deleteRideUseCase);

  String _pickupController = "";
  String _dropController = "";
  int _seatCountController = 0;
  int _priceController = 0;
  String _rideDescController = "";
  String _date = "";
  String _time = "";
  String _rideId = "";

  List<Vehicles> _vehicleList = [] ;


  bool _isLoading = false;
  // bool _publishComplete = false;
  String _errorMessage = "";

  // Getters
  String get pickupLocation => _pickupController;
  String get dropLocation => _dropController;
  int get seats => _seatCountController;
  int get price => _priceController;
  String get description => _rideDescController;
  String get date => _date;
  String get time => _time;
  String get rideId => _rideId;

  List<Vehicles> get vechilesList => _vehicleList;

  String get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  void clearError() {
    _errorMessage = "";
    notifyListeners();
  }

  void updateRideId(String rideId) {
    _rideId = rideId;
    print(_rideId);
  }


  Future<void> deleteRide(BuildContext context) async {
    print("API Call Started");
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      Map<String, String> data = {
        "id": _rideId,
      };

      CancelRideDto response = await deleteRideUseCase(data);
      print("API Response: ${response?.success}");

      if (response?.success == true) {
        _errorMessage = "";
        _isLoading = false;
        SnackBar(
          content: Text("Ride Cancel !",style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),),
          backgroundColor: AppColors.lightBlue,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
        );
        Navigator.pushAndRemoveUntil(
          context,
          RLSlideTransition(GlobalScreen()),
              (route) => false,
        );

      } else {
        _isLoading = false;
        _errorMessage = response.message!;
        print(response.message);
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      print("API Call Failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getVehiclesList(BuildContext context) async {
    print("API Call Started");
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      GetAllVehicleDto response = await getAllVehiclesUseCase();
      print("API Response: ${response?.success}");

      if (response?.success == true) {
        _errorMessage = "";
        _isLoading = false;
        _vehicleList = response.vehicles;
      } else {
        _isLoading = false;
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      print("API Call Failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Optional: Reset all fields (e.g., when starting over)
  void resetFields() {
    _pickupController = "";
    _dropController = "";
    _seatCountController = 0;
    _priceController = 0;
    _rideDescController = "";
    notifyListeners();
  }
}