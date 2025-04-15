import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../services/HiveHelper.dart';
import '../../../utils/LRSlideTransition.dart';
import '../../../utils/colors.dart';

import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../utils/constants.dart';
import '../../GlobalScreen.dart';
import '../../provider/VerifyOtpProvider.dart';
import 'PrePasswordResetScreen.dart';
import 'SuccessMessageWidget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String? purpose;
  final Widget? route;
  final Map<String, String>? userData;

  const OtpVerificationScreen({super.key, required this.email, this.route, this.userData, this.purpose});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int otpLength = 4;
  final List<TextEditingController> _otpControllers = List.generate(
    otpLength,
        (index) => TextEditingController(),
  );

  int _secondsRemaining = 60;
  bool _isResendActive = false;
  bool _isOtpComplete = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startResendCountdown();
    for (var controller in _otpControllers) {
      controller.addListener(_checkOtpComplete);
    }
  }

  void startResendCountdown() {
    setState(() {
      _isResendActive = false;
      _secondsRemaining = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _isResendActive = true);
        _timer?.cancel();
      }
    });
  }

  void _checkOtpComplete() {
    setState(() {
      _isOtpComplete = _otpControllers.every(
            (controller) => controller.text.length == 1,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp(String purpose) async {
    String otp = _otpControllers.map((c) => c.text).join();
    try {
      if (purpose == "ForgetPasswordOtpVerification") {
        await Provider.of<OtpProvider>(context, listen: false).verifyForgetPasswordOtp(otp);
      } else {
        await Provider.of<OtpProvider>(context, listen: false).verifyOtp(otp);
      }
      if (Provider.of<OtpProvider>(context, listen: false).nextScreen) {
        if (purpose == "ForgetPasswordOtpVerification") {
          Navigator.push(
            context,
            LRSlideTransition( PrePasswordResetScreen(
                    resetToken: Provider.of<OtpProvider>(context, listen: false).resetToken, email: widget.email)),
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SuccessMessageWidget(
              title: "Verified",
              message: "Congratulations! Your OTP has \nbeen verified.",
              btnTitle: "Let's Go !",
              onPressed: () {
                HiveHelper.saveData(AppConstants.LOGIN_STATUS, true);
                Navigator.pushAndRemoveUntil(
                  context,
                  LRSlideTransition( GlobalScreen()),
                      (route) => false,
                );
              },
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _clearOtpFields() async {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    try {
      await Provider.of<OtpProvider>(context, listen: false).reSendOtp();
      setState(() {
        startResendCountdown();
        _isOtpComplete = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to resend OTP: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String getFormattedEmail(String email) {
    if (!email.contains("@")) return email;
    List<String> parts = email.split("@");
    String firstPart = parts[0].length > 3 ? parts[0].substring(0, 3) : parts[0];
    return "$firstPart...@${parts[1]}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<OtpProvider>(
      builder: (context, otpProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (otpProvider.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(otpProvider.errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            otpProvider.clearError();
          }
        });
        otpProvider.setEmail(widget.email);
        return Stack(
          children: [
            GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.07,
                      screenWidth * 0.05,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GlobalRoundedBackBtn(
                          onPressed: () => Navigator.pop(context),
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.1,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          "Check your email",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          "We sent a reset link to ${getFormattedEmail(widget.email)}\nEnter the 4-digit code",
                          style: GoogleFonts.poppins(
                            color: AppColors.gray001,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(otpLength, (index) {
                              return SizedBox(
                                width: screenWidth * 0.12,
                                child: TextField(
                                  controller: _otpControllers[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.055,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.gray002,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < otpLength - 1) {
                                      FocusScope.of(context).nextFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isResendActive ? "" : "Resend OTP in $_secondsRemaining s",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.025,
                                color: AppColors.gray003,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: _isResendActive
                                  ? () {
                                otpProvider.setUserData(widget.userData);
                                _clearOtpFields();
                              }
                                  : null,
                              child: Text(
                                "Resend OTP",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.025,
                                  color: _isResendActive ? AppColors.primary : AppColors.gray003,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isOtpComplete ? () => _verifyOtp(widget.purpose ?? '') : null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: _isOtpComplete ? AppColors.primary : AppColors.gray001,
                            ),
                            child: Text(
                              "Verify",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.06),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (otpProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        );
      },
    );
  }
}