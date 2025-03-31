import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/colors.dart';

class SuccessMessageWidget extends StatelessWidget {
  final String title;
  final String message;
  final String btnTitle;
  final VoidCallback onPressed;

  const SuccessMessageWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.btnTitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06), // Responsive margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ✅ Success Icon
            Lottie.asset(
              'assets/anim/done_animation.json',
              repeat: true,
              height: screenHeight * 0.08, // Responsive height
              width: screenWidth * 0.15, // Responsive width
            ),

            /// 🎉 Title
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045, // Responsive font size
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // Responsive SizedBox

            /// 📜 Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: AppColors.gray001,
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive SizedBox

            /// 🔹 Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015), // Responsive padding
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  btnTitle,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04, // Responsive font size
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