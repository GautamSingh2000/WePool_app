import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/presentation/GlobalScreen.dart';

import '../../../../utils/RLSLideTransition.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../provider/PublishRideProvider.dart';
import '../../auth/SuccessMessageWidget.dart';

class PublishRideScreen extends StatefulWidget {
  @override
  _PublishRideScreenState createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends State<PublishRideScreen> {
  int seatCount = 2;
  int pricePerSeat = 20;
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalRoundedBackBtn(
                onPressed: () => Navigator.pop(context),
                height: screenHeight * 0.06,
                width: screenWidth * 0.12,
              ),
              _buildCounterRow(
                label: 'No of seats',
                value: seatCount,
                onIncrement: () => setState(() => seatCount++),
                onDecrement: () {
                  if (seatCount > 1) setState(() => seatCount--);
                },
              ),
              SizedBox(height: 24),
              _buildCounterRow(
                label: 'Price per seat',
                value: pricePerSeat,
                currency: true,
                onIncrement: () => setState(() => pricePerSeat++),
                onDecrement: () {
                  if (pricePerSeat > 1) setState(() => pricePerSeat--);
                },
              ),
              SizedBox(height: context.screenHeight * 0.06),
              _buildLabel('Anything to add about the ride'),
              _buildTextArea(),
              SizedBox(height: 40), // extra space above the button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _buildPublishButton(),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    bool currency = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _roundIconBtn(Icons.remove, onDecrement),
              SizedBox(width: 8),
              Container(
                width: 70,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  currency ? '₹ $value' : '$value',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8),
              _roundIconBtn(Icons.add, onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundIconBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        splashRadius: 20,
      ),
    );
  }

  Widget _buildTextArea() {
    return Padding(
      padding: EdgeInsets.only(top: context.screenHeight * 0.02),
      child: TextField(
        controller: _noteController,
        maxLines: 5,
        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.borderGray01),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          hintText: "Type anything specific",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.primary),
        elevation: MaterialStateProperty.all(10.0),
      ),
      onPressed: () async {
        if (seatCount <= 0 || pricePerSeat <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Seats and price per seat must be greater than 0"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 70, left: 16, right: 16),
            ),
          );
          return;
        }

        final provider = Provider.of<PublishRideProvider>(
          context,
          listen: false,
        );
        provider.addOtherDetail(
          seatCount.toString(),
          pricePerSeat.toString(),
          _noteController.text.trim(),
        );
        await provider.publishRider(context);
        if (provider.ridePublished) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => SuccessMessageWidget(
              title: "Successful",
              message: "Your ride is published!",
              btnTitle: "Done",
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog first
                Navigator.of(context).pushAndRemoveUntil(
                  RLSlideTransition(GlobalScreen()),
                    (route) => false,
                );
              },
            ),
          );
        }
      },
      child: Text(
        "Publish your ride",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;
}
