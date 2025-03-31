import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/colors.dart';
import '../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../widgets/global/GlobalRoundedButton.dart';

class SearchRideScreen extends StatefulWidget {
  const SearchRideScreen({super.key});

  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  final TextEditingController _leavingFromController = TextEditingController();
  final TextEditingController _goingToController = TextEditingController();
  int seats = 4; // Default seat count
  DateTime? selectedDate;

  void _swapAddresses() {
    setState(() {
      String temp = _leavingFromController.text;
      _leavingFromController.text = _goingToController.text;
      _goingToController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.1),
                  child: Text(
                    "Search your Ride",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.0625,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.025),
                  child: Text(
                    "Leaving From",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.0125, bottom: screenHeight * 0.025),
                  child: GlobalOutlineEditText(
                    hintText: "Enter your full address",
                    controller: _leavingFromController,
                    prefixIcon: Image.asset(
                      "assets/icons/ic_search.png",
                      width: screenWidth * 0.045,
                      height: screenWidth * 0.045,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Going to",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.055,
                      height: screenWidth * 0.055,
                      child: IconButton(
                        onPressed: _swapAddresses,
                        icon: Icon(
                          Icons.swap_vert,
                          color: Colors.white,
                          size: screenWidth * 0.04,
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
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.0125, bottom: screenHeight * 0.025),
                  child: GlobalOutlineEditText(
                    hintText: "Enter your full address",
                    controller: _goingToController,
                    prefixIcon: Image.asset(
                      "assets/icons/ic_search.png",
                      width: screenWidth * 0.045,
                      height: screenWidth * 0.045,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Going to",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.0125),
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.0175,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundGray01,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: AppColors.borderGray01,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate == null
                                        ? "Select Date"
                                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: AppColors.hintGray,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    size: screenWidth * 0.045,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No of seats",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.0125),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: screenHeight * 0.035,
                                width: screenWidth * 0.07,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGray01,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.borderGray01,
                                  ),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                      size: screenWidth * 0.04,
                                      color: AppColors.iconGray02,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      if (seats > 1) setState(() => seats--);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.borderGray01,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$seats",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Container(
                                height: screenHeight * 0.035,
                                width: screenWidth * 0.07,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundGray01,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.borderGray01,
                                  ),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: screenWidth * 0.04,
                                      color: AppColors.iconGray02,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      if (seats < 10) setState(() => seats++);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _validateAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.0175),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  void _validateAndProceed() {
    if (_leavingFromController.text.isEmpty) {
      _showSnackbar("Please enter your leaving address.");
      return;
    }
    if (_goingToController.text.isEmpty) {
      _showSnackbar("Please enter your destination address.");
      return;
    }
    if (selectedDate == null) {
      _showSnackbar("Please select a date.");
      return;
    }
    if (seats < 1) {
      _showSnackbar("Please select at least one seat.");
      return;
    }
    print("All fields are valid, proceeding...");
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }
}