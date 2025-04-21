
import 'package:flutter/cupertino.dart';
import 'package:we_pool_app/data/models/UpcomingRideDto.dart';
import 'package:we_pool_app/domain/use_case/UpcomingRidesUseCase.dart';

class UpcomingRidesProvider extends ChangeNotifier {
  final UpcomingRidesUseCase upcomingRidesUseCase;

  UpcomingRidesProvider(this.upcomingRidesUseCase);

  bool isLoading = false;
  String errorMessage = "";
  List<Ride>? _upcomingRidesList = [];
  bool nextScreen = false;

  // Getters

  List<Ride>? get upcomingRidesList => _upcomingRidesList;

  void setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    errorMessage = "";
    notifyListeners();
  }



  Future<void> upcomingRides(BuildContext context) async {
    print("API Call Started");
    try {
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      UpcomingRideDto response = await upcomingRidesUseCase();
      print("API Response: ${response?.success}");

      if (response.success == true) {
        errorMessage = "";
        isLoading = false;
        _upcomingRidesList = response.rides;
        print("API Response: ${response.rides}");
      } else {
        errorMessage = response.message;
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