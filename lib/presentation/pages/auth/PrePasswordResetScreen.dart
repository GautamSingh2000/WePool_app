import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/colors.dart';
import '../../../utils/LRSlideTransition.dart';
import '../../../widgets/global/GlobalRoundedButton.dart';
import 'SetNewPasswordScreen.dart';

class PrePasswordResetScreen extends StatelessWidget {
  final String resetToken;
  final String email;

  const PrePasswordResetScreen({super.key, required this.resetToken, required this.email});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.07,
          screenWidth * 0.05,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Back Button
            GlobalRoundedBtn(
              onPressed: () => Navigator.pop(context),
              height: screenHeight * 0.05,
              width: screenWidth * 0.1,
            ),

            /// 🔹 Title
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.03),
              child: Text(
                "Password Reset",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ),

            /// 🔹 Subtitle
            Text(
              "Your password has been successfully reset.\nClick confirm to set a new password",
              style: GoogleFonts.poppins(
                color: AppColors.gray001,
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),

            /// 🔹 Verify Button
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.04),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    LRSlideTransition(SetNewPasswordScreen(resetToken: resetToken, email: email),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  "Confirm",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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