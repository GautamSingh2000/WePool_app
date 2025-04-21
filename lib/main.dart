import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider
import 'package:we_pool_app/domain/use_case/GetAllVehiclesUseCase.dart';
import 'package:we_pool_app/domain/use_case/PublishRideUseCase.dart';
import 'package:we_pool_app/domain/use_case/UpcomingRidesUseCase.dart';
import 'package:we_pool_app/presentation/pages/auth/SplashScreen.dart';
import 'package:we_pool_app/presentation/provider/EditPublishRideProvider.dart';
import 'package:we_pool_app/presentation/provider/ForgetPasswordProvider.dart';
import 'package:we_pool_app/presentation/provider/LoginProvider.dart';
import 'package:we_pool_app/presentation/provider/PublishRideProvider.dart';
import 'package:we_pool_app/presentation/provider/ReSetPasswordProvider.dart';
import 'package:we_pool_app/presentation/provider/RegistrationProvider.dart';
import 'package:we_pool_app/presentation/provider/UpcomingRidesProvider.dart';
import 'package:we_pool_app/presentation/provider/VehicleProvider.dart';
import 'package:we_pool_app/presentation/provider/VerifyOtpProvider.dart';
import 'package:we_pool_app/services/HiveHelper.dart';
import 'package:we_pool_app/utils/colors.dart';

import 'di.dart';
import 'domain/use_case/AddVehicleUseCase.dart';
import 'domain/use_case/DeleteRideUseCase.dart';
import 'domain/use_case/ForgetPasswordUseCase.dart';
import 'domain/use_case/LoginUseCase.dart';
import 'domain/use_case/RegistrationUseCase.dart';
import 'domain/use_case/ResetPasswordUseCase.dart';
import 'domain/use_case/VerifyForgetPasswordUseCase.dart';
import 'domain/use_case/VerifyOtpUseCase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveHelper.init();
  setupDi(); // Initialize dependencies
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => RegistrationProvider(locator<RegisterUserUseCase>()),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(locator<LoginUseCase>()),
        ),
        // ✅ Added New Provider
        ChangeNotifierProvider(
          create:
              (context) => OtpProvider(
                locator<VerifyOtpUseCase>(),
                locator<RegisterUserUseCase>(),
                locator<VerifyForgetPasswordOtpUseCase>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ForgetPasswordProvider(locator<ForgetPasswordUseCase>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ResetPasswordProvider(locator<ResetPasswordUseCase>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => PublishRideProvider(
                locator<GetAllVehiclesUseCase>(),
                locator<PublishRideUseCase>(),
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddVehicleProvider(locator<AddVehicleUseCase>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  UpcomingRidesProvider(locator<UpcomingRidesUseCase>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => EditPublishRideProvider(
                locator<GetAllVehiclesUseCase>(),
                locator<DeleteRideUseCase>(),
              ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary, // Set primary color here
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            onPrimary: AppColors.gray003,
          ),
        ),
        // home: EnterAddress(addressType: "pickUpAddress")
        home: SplashScreen(),
      ),
    );
  }
}
