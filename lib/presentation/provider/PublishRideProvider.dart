
import 'package:flutter/cupertino.dart';
import 'package:we_pool_app/data/models/CommonResponseDto.dart';
import 'package:we_pool_app/domain/use_case/GetAllVehiclesUseCase.dart';

import '../../data/models/GetAllVehicleDto.dart';
import '../../domain/use_case/PublishRideUseCase.dart';

class PublishRideProvider extends ChangeNotifier {
  // final PublishRideProvider registerUserUseCase;
  final GetAllVehiclesUseCase getAllVehiclesUseCase;
  final PublishRideUseCase publishRideUseCase;

  PublishRideProvider(this.getAllVehiclesUseCase,this.publishRideUseCase);

  bool _isLoading = false;
  // bool _publishComplete = false;
  String _errorMessage = "";

  String _pickupAddress = "";
  String _destinationAddress = "";
  String _date = "";
  String _pickuptime = "";
  String _vechileId = "";
  String _numberofSeats = "";
  String _pricePerSeat = "";
  String _additionalInfo = "";
  List<Vehicles> _vehicleList = [] ;
  bool _ridePublished = false;

  // Getters
  // Getters
  String get pickupAddress => _pickupAddress;

  String get destinationAddress => _destinationAddress;

  String get date => _date;

  String get pickuptime => _pickuptime;

  String get vechileId => _vechileId;

  String get numberofSeats => _numberofSeats;

  String get pricePerSeat => _pricePerSeat;

  String get additionalInfo => _additionalInfo;

  String get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  List<Vehicles> get vechilesList => _vehicleList;

  bool get ridePublished => _ridePublished;

  void clearError() {
    _errorMessage = "";
    notifyListeners();
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

  Future<void> publishRider(BuildContext context) async {
    print("API Call Started");
    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      Map<String,dynamic> data = {
          "vehicleId": _vechileId,
          "from": _pickupAddress,
          "fromLat": "0",
          "fromLong": "0",
          "to": _destinationAddress,
          "toLat": "0",
          "toLong": "0",
          "date": _date,
          "time": _pickuptime,
          "noOfSeats": int.parse(_numberofSeats),
          "pricePerSeat": int.parse(_pricePerSeat),
          "summary": _additionalInfo
      };

      CommonResponseDto response = await publishRideUseCase(data);
      print("API Response: ${response?.success}");

      if (response?.success == true) {
        _errorMessage = "";
        _isLoading = false;
        _ridePublished = true;
      } else {
        _isLoading = false;
        _errorMessage = response.message ?? "Unable To publish this ride!";
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      print("API Call Failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void setPickupAddress(String address) {
    print(address);
    _pickupAddress = address;
    notifyListeners();
  }

  void setDropAddress(String address) {
    print(address);
    _destinationAddress = address;
    notifyListeners();
  }

  void addRideDetails(String time, String date , String vehicleId){

    print("ridding details : $date , $time, $vehicleId");
    _date = date;
    _pickuptime = time;
    _vechileId = vehicleId;
    notifyListeners();
  }

  void addOtherDetail(String NoOfSeats, String PrisePerSeats , String description){
    _numberofSeats = NoOfSeats;
    _pricePerSeat = PrisePerSeats;
    _additionalInfo = description;
    notifyListeners();
  }
}