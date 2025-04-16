import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:we_pool_app/domain/use_case/AddVehicleUseCase.dart';

import '../../data/models/verifyOtpDto.dart';

class AddVehicleProvider with ChangeNotifier {

  final AddVehicleUseCase addVehiclesUseCase;

  AddVehicleProvider(this.addVehiclesUseCase);

  bool _isLoading = false;
  String _errorMessage = "";
  bool _success = false;

  String _brand = "";
  String _model = "";
  String _color = "";

  String get brand =>_brand;
  String get model => _model;
  String get color => _color;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get success => _success;

  void clearError() {
    _errorMessage = "";
    notifyListeners();
  }

  Future<void> addVehicle(BuildContext context) async {
    print("API Call Started");
    _isLoading = true;
    notifyListeners();
    if(_brand == "" || _model == "" || _color == ""){
      _errorMessage = "Enter all values !!" ;
      return;
    }

    try {
      Map<String, String> userData = {"brand": _brand, "model": _model ,"color" : _color};

      VerifyOtpDto response = await addVehiclesUseCase(userData);
      if (response != null && response.success == true) {
        _isLoading = false;
        _success = true;
      } else {
        _errorMessage = response?.message ?? "Not able to ad new vehicle!";
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void setVehicleInfo({
    required String brand,
    required String model,
    required String color,
  }) {
    _brand = brand;
    _model = model;
    _color = color;
    notifyListeners();
  }
}
