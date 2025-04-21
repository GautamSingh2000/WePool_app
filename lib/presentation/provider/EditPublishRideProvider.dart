import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/data/models/CommonResponseDto.dart';
import 'package:we_pool_app/presentation/GlobalScreen.dart';
import 'package:we_pool_app/utils/RLSLideTransition.dart';
import 'package:we_pool_app/utils/colors.dart';

import '../../data/models/CancelRideDto.dart';
import '../../data/models/GetAllVehicleDto.dart';
import '../../domain/use_case/DeleteRideUseCase.dart';
import '../../domain/use_case/GetAllVehiclesUseCase.dart';
import '../../domain/use_case/UpdateRideUseCase.dart';

class EditPublishRideProvider extends ChangeNotifier {
  final GetAllVehiclesUseCase getAllVehiclesUseCase;
  final DeleteRideUseCase deleteRideUseCase;
  final UpdateRideUseCase updateRideUseCase;

  EditPublishRideProvider(this.getAllVehiclesUseCase, this.deleteRideUseCase, this.updateRideUseCase);

  String _pickupController = "";
  String _dropController = "";
  int _seatCountController = 0;
  int _priceController = 0;
  String _rideDescController = "";
  String _date = "";
  String _time = "";
  String _rideId = "";
  String _vechileIdController = "";
  String _period = "";

  List<Vehicles> _vehicleList = [];

  bool _isLoading = false;

  // bool _publishComplete = false;
  String _errorMessage = "";

  // Getters
  String get pickupLocation => _pickupController;

  String get dropLocation => _dropController;

  int get seats => _seatCountController;

  int get price => _priceController;

  String get description => _rideDescController;
  String get vechileId => _vechileIdController;
  String get period => _period;

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

  void updatePickupLocation(String pickup) {
    _pickupController = pickup;
    print("_pickupController $_pickupController");
  }

  void updateDropLocation(String drop) {
    _dropController = drop;
    print("_dropController $_dropController");
  }

  void updatePeriod(String period) {
    _period = period;
    print("_period $_period");
  }

  void updateNumberOfSeats(int seats) {
    _seatCountController = seats;
    print("_seatCountController $_seatCountController");
  }

  void updatePricePerSeat (int price) {
    _priceController = price;
    print("_priceController $_priceController");
  }

  void updateRideDescription(String description) {
    _rideDescController = description;
    print("_rideDescController $_rideDescController");
  }

  void updateDate(String date) {
    _date = date;
    print("_date $_date");
  }
  void updateTime(String time) {
    _time = time;
    print("_time $_time");
  }

  void updateVehicleId(String vehicleId) {
    _vechileIdController = vehicleId;
    print("_vechileIdController $_vechileIdController");
  }

  void updateRideId(String rideId) {
    _rideId = rideId;
    print("_rideId $_rideId");
  }

  Future<void> deleteRide(BuildContext context) async {
    print("API Call Started");
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      Map<String, String> data = {"id": _rideId};
      print("api request param $data");
      CancelRideDto response = await deleteRideUseCase(data);
      print("API Response: ${response}");

      if (response?.success == true) {
        _errorMessage = "";
        _isLoading = false;

        // ✅ Create the SnackBar
        final snackBar = SnackBar(
          content: Text(
            "Ride Cancelled!",
            style: GoogleFonts.poppins(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: AppColors.lightBlue,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        );

        // ✅ Show and wait for it to close
        await ScaffoldMessenger.of(context).showSnackBar(snackBar).closed;

        // ✅ Then navigate
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



  Future<void> updateRide(BuildContext context) async {
    print("API Call Started");
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      Map<String,dynamic> data = {
        "id": _rideId,
        "vehicleId": _vechileIdController,
        "from": _pickupController,
        "fromLat": "0",
        "fromLong": "0",
        "to": _dropController,
        "toLat": "0",
        "toLong": "0",
        "date": _date,
        "time": _time,
        "noOfSeats": _seatCountController,
        "pricePerSeat": _priceController,
        "summary": _rideDescController
      };

      print("api request param $data");
      CommonResponseDto response = await updateRideUseCase(data);
      print("API Response: ${response}");

      if (response?.success == true) {
        _errorMessage = "";
        _isLoading = false;

        // ✅ Create the SnackBar
        final snackBar = SnackBar(
          content: Text(
            "Ride Updated Successfully!",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.lightGreen,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        );

        // ✅ Show and wait for it to close
        await ScaffoldMessenger.of(context).showSnackBar(snackBar).closed;

        // ✅ Then navigate
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
