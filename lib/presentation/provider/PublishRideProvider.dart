
import 'package:flutter/cupertino.dart';

class PublishRideProvider extends ChangeNotifier {
  // final PublishRideProvider registerUserUseCase;

  PublishRideProvider();


  String _pickupAddress = "";
  String _destinationAddress = "";
  String _date = "";
  String _pickuptime = "";
  String _vechile = "";
  String _numberofSeats = "";
  String _pricePerSeat = "";
  String _additionalInfo = "";

  // Getters
  // Getters
  String get pickupAddress => _pickupAddress;

  String get destinationAddress => _destinationAddress;

  String get date => _date;

  String get pickuptime => _pickuptime;

  String get vechile => _vechile;

  String get numberofSeats => _numberofSeats;

  String get pricePerSeat => _pricePerSeat;

  String get additionalInfo => _additionalInfo;

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

  void addRideDetails(String time, String date , String vehicle){

    print("ridding details : $date , $time, $vehicle");
    _date = date;
    _pickuptime = time;
    _vechile = vehicle;
    notifyListeners();
  }

  void addOtherDetail(String NoOfSeats, String PrisePerSeats , String description){
    _numberofSeats = NoOfSeats;
    _pricePerSeat = PrisePerSeats;
    _additionalInfo = description;
    notifyListeners();
  }
}