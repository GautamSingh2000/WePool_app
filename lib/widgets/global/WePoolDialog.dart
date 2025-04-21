import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/utils/colors.dart';

enum HighlightedButton { primary, secondary }

void WePoolDialog({
  required BuildContext context,
  required String titleText,
  required String primaryButtonText,
  required String secondaryButtonText,
  required HighlightedButton highlightedButton,
  required VoidCallback onPrimaryPressed,
  required VoidCallback onSecondaryPressed,
}) {
  final mediaQuery = MediaQuery.of(context);
  final screenWidth = mediaQuery.size.width;
  final screenHeight = mediaQuery.size.height;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and close button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      titleText,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      "assets/icons/ic_cancel_btn.svg",
                      height: screenHeight * 0.03,
                      width: screenHeight * 0.03,
                      semanticsLabel: 'cancel icon',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),

              // Buttons row
              Row(
                children: [
                  // Secondary button
                  Expanded(
                    child: highlightedButton == HighlightedButton.secondary
                        ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSecondaryPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    )
                        : OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSecondaryPressed();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText,
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),

                  // Primary button
                  Expanded(
                    child: highlightedButton == HighlightedButton.primary
                        ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onPrimaryPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        primaryButtonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    )
                        : OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onPrimaryPressed();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        primaryButtonText,
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
