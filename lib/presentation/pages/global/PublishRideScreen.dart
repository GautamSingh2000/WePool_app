import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/colors.dart';

import '../../../widgets/global/GlobalOutlinEditText.dart';

class PublishRideScreen extends StatefulWidget {
  @override
  _PublishRideScreenState createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends State<PublishRideScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Publish your ride",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.07,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.025),

            // Pickup Field
            Text(
              "Pickup From",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            GlobalOutlineEditText(
              hintText: "Enter your full address",
              controller: _pickupController,
              prefixIcon: Image.asset(
                "assets/icons/ic_search.png",
                width: screenWidth * 0.045,
                height: screenWidth * 0.045,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Destination Field
            Text(
              "Destination",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            GlobalOutlineEditText(
              hintText: "Enter your full address",
              controller: _destinationController,
              prefixIcon: Image.asset(
                "assets/icons/ic_search.png",
                width: screenWidth * 0.045,
                height: screenWidth * 0.045,
              ),
            ),
            SizedBox(height: screenHeight * 0.035),

            // Add Stopover
            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.055,
                  height: screenWidth * 0.055,
                  child: IconButton(
                    onPressed: () {
                      // Add your action here
                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: screenWidth * 0.045,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Text(
                  "Add a Stopover",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Handle button click
                },
                child: Text(
                  "Continue",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
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