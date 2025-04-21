import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/presentation/GlobalScreen.dart';

import '../../../../utils/RLSLideTransition.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../../widgets/global/SuccessMessageWidget.dart';
import '../../../provider/PublishRideProvider.dart';

class PublishRideScreen extends StatefulWidget {
  @override
  _PublishRideScreenState createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends State<PublishRideScreen> {
  int seatCount = 2;
  int pricePerSeat = 20;
  final TextEditingController _noteController = TextEditingController();
  late TextEditingController _seatController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _seatController = TextEditingController(text: seatCount.toString());
    _priceController = TextEditingController(text: pricePerSeat.toString());
  }

  @override
  void dispose() {
    _seatController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.03,
            horizontal: screenWidth * 0.04,
          ),
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
                onChanged: (val) {
                  setState(() {
                    seatCount = val;
                    _seatController.text = val.toString(); // okay here
                  });
                },
                controller: _seatController,
              ),
              SizedBox(height: screenHeight * 0.03),

              _buildCounterRow(
                label: 'Price per seat',
                value: pricePerSeat,
                onChanged: (val) { setState(() {
                  pricePerSeat = val;
                  _priceController.text = val.toString();
                });
                  },
                controller: _priceController,
              ),
              SizedBox(height: screenHeight * 0.06),
              _buildLabel('Anything to add about the ride'),
              _buildTextArea(),
              SizedBox(height: screenHeight * 0.06),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.04,
          0,
          screenWidth * 0.04,
          screenHeight * 0.025,
        ),
        child: _buildPublishButton(),
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: context.screenWidth * 0.035,
        fontWeight: FontWeight.w500,
      ),
    );
  }


  Widget _buildCounterRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    required TextEditingController controller,
    bool currency = false,
  }) {
    // Ensure controller is in sync without resetting cursor
    if (controller.text != value.toString()) {
      controller.text = value.toString();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: context.screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: context.screenWidth * 0.034,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _roundIconBtn(Icons.remove, () {
                if (value > 1) onChanged(value - 1);
              }),
              SizedBox(width: context.screenWidth * 0.02),
              Container(
                width: context.screenWidth * 0.18,
                height: context.screenHeight * 0.06,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: context.screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        if (label == 'No of seats' && parsed > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You can’t add more than 5 seats."),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                bottom: context.screenHeight * 0.08,
                                left: 16,
                                right: 16,
                              ),
                            ),
                          );
                          return;
                        }
                        onChanged(parsed);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: context.screenWidth * 0.02),
              _roundIconBtn(Icons.add, () {
                if (label == 'No of seats' && value >= 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You can’t add more than 5 seats."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: context.screenHeight * 0.08,
                        left: 16,
                        right: 16,
                      ),
                    ),
                  );
                  return;
                }
                onChanged(value + 1);
              }),
            ],
          ),
        ],
      ),
    );
  }


  Widget _roundIconBtn(IconData icon, VoidCallback onPressed) {
    return Center(
      child: Container(
        width: context.screenWidth * 0.06,
        height: context.screenWidth * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: context.screenWidth * 0.045,
              color: AppColors.iconGray02,
            ),
            splashRadius: context.screenWidth * 0.06,
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Padding(
      padding: EdgeInsets.only(top: context.screenHeight * 0.02),
      child: TextField(
        controller: _noteController,
        maxLines: 5,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: context.screenWidth * 0.031,
          fontWeight: FontWeight.w400,
        ),
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
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: AppColors.iconGray02,
            fontSize: context.screenWidth * 0.031,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.all(context.screenWidth * 0.03),
        ),
      ),
    );
  }

  Widget _buildPublishButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(double.infinity, context.screenHeight * 0.06),
        ),
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
              margin: EdgeInsets.only(
                bottom: context.screenHeight * 0.08,
                left: 16,
                right: 16,
              ),
            ),
          );
          return;
        }

        final provider = Provider.of<PublishRideProvider>(
          context,
          listen: false,
        );
        provider.addOtherDetail(
          _seatController.text,
          _priceController.text,
          _noteController.text.trim(),
        );

        await provider.publishRider(context);
        if (provider.ridePublished) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => SuccessMessageWidget(
                  title: "Successful",
                  message: "Your ride is published!",
                  btnTitle: "Done",
                  onPressed: () {
                    Navigator.of(context).pop(); // close dialog
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
          fontSize: context.screenWidth * 0.04,
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
