import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/widgets/global/CircularButton.dart';

import '../../../../services/HiveHelper.dart';
import '../../../../utils/LRSlideTransition.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import 'EnterAddress.dart';

class DestinationAddressScreen extends StatefulWidget {
  const DestinationAddressScreen({super.key});

  @override
  State<DestinationAddressScreen> createState() => _DestinationAddressScreenState();
}

class _DestinationAddressScreenState extends State<DestinationAddressScreen> {
  final TextEditingController _pickupController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GlobalRoundedBackBtn(
                onPressed: () => Navigator.pop(context),
                height: screenHeight * 0.06,
                width: screenWidth * 0.12,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Where are you\nheading?",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: screenWidth * 0.064,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Address Input
              GlobalOutlineEditText(
                hintText: "Enter your full address",
                controller: _pickupController,
                prefixIcon: SvgPicture.asset(
                  "assets/icons/ic_search.svg", // ✅ Make sure it's .svg
                  width: screenWidth * 0.035,
                  height: screenHeight * 0.035,
                  semanticsLabel: 'Search icon',
                ),
                editable: false,
                onTap:(){
                  Navigator.push(context,LRSlideTransition(EnterAddress(addressType : "dropAddress")));
                },
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}