import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/colors.dart';

import '../../../services/HiveHelper.dart';
import '../../../utils/LRSlideTransition.dart';
import '../../../utils/constants.dart';
import '../../GlobalScreen.dart';
import 'PreSignupScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkLoginStatus(); // Directly call instead of delaying
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Show splash briefly
    bool? isLoggedIn = await HiveHelper.getBoolData(AppConstants.LOGIN_STATUS);

    if (!mounted) return; // Prevent navigation errors
    Navigator.pushReplacement(
      context,
      LRSlideTransition(isLoggedIn == true ? GlobalScreen() : PreSignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/lg_app.svg",
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.15,
                  semanticsLabel: 'App icon',
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'wepool',
                  style: GoogleFonts.abhayaLibre(
                    color: Colors.white,
                    fontSize: screenWidth * 0.085,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text.rich(
                  TextSpan(
                    text: 'Think ',
                    style: GoogleFonts.poppins(
                      color: AppColors.gray005,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Ride sharing\n',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Think ',
                        style: GoogleFonts.poppins(
                          color: AppColors.gray005,
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Wepool',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.025),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Made in',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Image.asset(
                    'assets/icons/ic_indian_flag.png',
                    height: screenHeight * 0.03,
                    width: screenWidth * 0.05,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}