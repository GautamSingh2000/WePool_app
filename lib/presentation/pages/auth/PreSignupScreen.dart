import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../utils/GetDeviceInfo.dart';
import '../../../utils/LRSlideTransition.dart';
import '../../../utils/colors.dart';
import '../../../data/models/DeviceInfoModel.dart';
import '../../../services/HiveHelper.dart';
import '../../../widgets/global/HoloCircularIndicatorWithChild.dart';
import 'LoginScreen.dart';

class PreSignupScreen extends StatefulWidget {
  @override
  _PreSignupScreenState createState() => _PreSignupScreenState();
}

class _PreSignupScreenState extends State<PreSignupScreen> {
  int _currentIndex = 0;
  double _opacity = 1.0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/img_presignup_1.png",
      "title": "Ride & Share",
      "subtitle": "Get colleagues who are going in the same office on your way!",
    },
    {
      "image": "assets/images/img_presignup_2.png",
      "title": "Travel Together",
      "subtitle": "Enjoy your commute with friendly colleagues.",
    },
    {
      "image": "assets/images/img_presignup_3.png",
      "title": "Save Fuel & Money",
      "subtitle": "Share rides and contribute to a greener planet.",
    },
  ];

  void _nextStep() {
    if (_currentIndex < onboardingData.length - 1) {
      setState(() => _opacity = 0); // Start fade-out animation

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _currentIndex++;
          _opacity = 1; // Fade-in new content
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushAndRemoveUntil(
          context,
          LRSlideTransition(LoginScreen()),
              (route) => false,
        );
      });
    }
  }

  void saveDeviceData() async {
    DeviceInfoModel deviceInfo = await getDeviceInfo();
    HiveHelper.saveDeviceInfo(deviceInfo);
    print("Device Info Saved!");
    DeviceInfoModel deviceData = HiveHelper.getDeviceInfo();
    print(deviceData.deviceId);
    print(deviceData.deviceType);
    print(deviceData.deviceName);
  }

  @override
  void initState() {
    super.initState();
    saveDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final currentData = onboardingData[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Image with Responsive Margin
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _opacity,
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                child: Image.asset(
                  currentData['image']!,
                  width: screenWidth * 0.65,
                  height: screenWidth * 0.65,
                ),
              ),
            ),

            // Animated Title with Responsive Margin
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _opacity,
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                child: Text(
                  currentData['title']!,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Animated Subtitle with Responsive Padding and Margin
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: _opacity,
                child: Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.1),
                  child: Text(
                    currentData['subtitle']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Circular Progress Indicator with Responsive Button
            HoloCircularIndicatorWithChild(
              progress: (_currentIndex + 1) / onboardingData.length,
              size: screenWidth * 0.22,
              strokeWidth: 4,
              child: Container(
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                height: screenWidth * 0.19,
                width: screenWidth * 0.19,
                child: IconButton(
                  onPressed: _nextStep,
                  icon: Icon(
                    _currentIndex < onboardingData.length - 1 ? Icons.arrow_forward : Icons.check,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: PreSignupScreen()));
}