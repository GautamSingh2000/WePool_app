
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/LoginResponseDto.dart';
import '../../domain/use_case/LoginUseCase.dart';
import '../../services/HiveHelper.dart';
import '../../utils/constants.dart';
import '../GlobalScreen.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider(this.loginUseCase);

  bool isLoading = false;
  String errorMessage = "";
  LoginResponseDto? response;
  bool nextScreen = false;

  String _email = "";
  String _password = "";

  // Getters
  String get email => _email;
  String get password => _password;

  void setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    errorMessage = "";
    notifyListeners();
  }



  // Setters
  void setEmailPassword(String email, String password) {
    _email = email;
    _password = password;
    print("data save in provider : $_email $_password");
    notifyListeners(); // Notify UI
  }

  Future<void> loginUser(Map<String, dynamic> credential, BuildContext context) async {
    print("API Call Started");
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      response = await loginUseCase(credential);
      print("API Response: ${response?.success}");

      if (response?.success == true) {
        errorMessage = "";
        isLoading = false;
        HiveHelper.saveData(AppConstants.LOGIN_STATUS, true);
        HiveHelper.saveData(AppConstants.TOKEN, response?.token);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GlobalScreen()),
                (route) => false,
          );
        });
      } else {
        errorMessage = response?.message ?? "Something went wrong!";
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
      print("API Call Failed: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}