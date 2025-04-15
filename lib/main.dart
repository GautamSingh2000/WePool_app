import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';  // ✅ Import Provider
import 'package:we_pool_app/presentation/pages/global/publish/AddMoreDetails.dart';
import 'package:we_pool_app/presentation/pages/global/publish/EnterAddress.dart';
import 'package:we_pool_app/presentation/pages/global/publish/PickUpAddressScreen.dart';
import 'package:we_pool_app/presentation/pages/global/publish/PublishRideScreen.dart';
import 'package:we_pool_app/presentation/provider/ForgetPasswordProvider.dart';
import 'package:we_pool_app/presentation/provider/LoginProvider.dart';
import 'package:we_pool_app/presentation/provider/PublishRideProvider.dart';
import 'package:we_pool_app/presentation/provider/ReSetPasswordProvider.dart';
import 'package:we_pool_app/presentation/provider/RegistrationProvider.dart';
import 'package:we_pool_app/presentation/provider/VerifyOtpProvider.dart';
import 'package:we_pool_app/services/HiveHelper.dart';
import 'package:we_pool_app/utils/colors.dart';

import 'di.dart';
import 'domain/use_case/ForgetPasswordUseCase.dart';
import 'domain/use_case/LoginUseCase.dart';
import 'domain/use_case/RegistrationUseCase.dart';
import 'domain/use_case/ResetPasswordUseCase.dart';
import 'package:device_preview/device_preview.dart';

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
        ChangeNotifierProvider(create: (context) => RegistrationProvider(locator<RegisterUserUseCase>())),
        ChangeNotifierProvider(create: (context) => LoginProvider(locator<LoginUseCase>())),  // ✅ Added New Provider
        ChangeNotifierProvider(create: (context) => OtpProvider(locator<VerifyOtpUseCase>(), locator<RegisterUserUseCase>(), locator<VerifyForgetPasswordOtpUseCase>())),
        ChangeNotifierProvider(create: (context) => ForgetPasswordProvider(locator<ForgetPasswordUseCase>())),
        ChangeNotifierProvider(create: (context) => ResetPasswordProvider(locator<ResetPasswordUseCase>())),
        ChangeNotifierProvider(create: (context) => PublishRideProvider()),
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
    home: PickUpAddressScreen()
      ));
  }
}