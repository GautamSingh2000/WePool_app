import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/utils/colors.dart';

class RideCard extends StatelessWidget {
  final String pickupLocation;
  final String dropLocation;
  final String date;
  final String time;

  const RideCard({
    Key? key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive font sizes and padding
    final fontSize = screenWidth * 0.03; // 3.5% of screen width for text
    final iconSize = screenWidth * 0.045; // 4.5% of screen width for icons
    final padding = screenWidth * 0.03; // 5% of screen width for padding
    final lineWidth = screenWidth * 0.005; // 3% of screen width for line width

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.00, vertical: screenHeight * 0.015),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: AppColors.primary, size: iconSize),
              SizedBox(width: screenWidth * 0.02),
              Text(
                pickupLocation,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005, horizontal: screenWidth * 0.02),
            height: screenHeight * 0.022, // 2.2% of screen height for line height
            width: lineWidth,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/ic_drop_location.svg", // ✅ Make sure it's .svg
                width: iconSize,
                height: iconSize,
                semanticsLabel: 'Drop Location icon',
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                dropLocation,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02), // 2% of screen height for spacing
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/ic_calendar.svg", // ✅ Make sure it's .svg
                width: iconSize,
                height: iconSize,
                semanticsLabel: 'Calendar icon',
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(date,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: screenWidth * 0.1), // Responsive spacing
              Icon(Icons.access_time, color: AppColors.primary, size: iconSize),
              SizedBox(width: screenWidth * 0.02),
              Text(time,
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
