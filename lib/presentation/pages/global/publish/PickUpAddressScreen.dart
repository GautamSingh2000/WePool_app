import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/LRSlideTransition.dart';
import '../../../../utils/RLSLideTransition.dart';
import '../../../../utils/colors.dart';

import '../../../../widgets/global/GlobalOutlinEditText.dart';
import 'EnterAddress.dart';

class PickUpAddressScreen extends StatefulWidget {
  @override
  _PickUpAddressScreenState createState() => _PickUpAddressScreenState();
}

class _PickUpAddressScreenState extends State<PickUpAddressScreen> {
  bool editable = false;
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
              "Where are you\ntravelling from?",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.07,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenHeight * 0.025),

            GlobalOutlineEditText(
              hintText: "Enter your full address",
              controller: _pickupController,
              prefixIcon: Image.asset(
                "assets/icons/ic_search.png",
                width: screenWidth * 0.035,
                height: screenWidth * 0.035,
              ),
                editable: editable,
              onTap:(){
                  Navigator.push(context, LRSlideTransition( EnterAddress(addressType : "pickUpAddress")));
                },
            ),
          ],
        ),
      ),
    );
  }
}