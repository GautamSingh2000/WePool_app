import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';

import '../../../widgets/global/GlobalOutlinEditText.dart';
import '../../provider/RegistrationProvider.dart';

class OnboardingScreen extends StatefulWidget {
  final String email;

  const OnboardingScreen({super.key, required this.email});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showDatePicker(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4, // Responsive height
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Responsive padding
          child: Column(
            children: [
              Text(
                "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(1900),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _dobController.text =
                      "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}";
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02), // Responsive padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    "Done",
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _dobController.addListener(_validateForm);
    _numberController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled =
          _nameController.text.isNotEmpty &&
              _dobController.text.isNotEmpty &&
              _numberController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<RegistrationProvider>(
          builder: (context, registrationProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (registrationProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(registrationProvider.errorMessage),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
                registrationProvider.clearError();
              }
            });
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, screenHeight * 0.08, 0, 0),
                            child: Text(
                              "Welcome Onboard!",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.075,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: Text(
                              "One more step and you’ll be \nready to go",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray001,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          GlobalOutlineEditText(
                            hintText: "Enter your full name",
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name cannot be empty";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          GestureDetector(
                            onTap: () => _showDatePicker(context),
                            child: AbsorbPointer(
                              child: GlobalOutlineEditText(
                                hintText: "Add your birthday",
                                controller: _dobController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Add date of birth";
                                  }
                                  return null;
                                },
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: AppColors.gray003,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          GlobalOutlineEditText(
                            hintText: "Enter your mobile number",
                            controller: _numberController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone Number cannot be empty";
                              }
                              if (value.length < 10) {
                                return "Phone Number must be at least 10 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isButtonEnabled
                                  ? () {
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<RegistrationProvider>(
                                    context,
                                    listen: false,
                                  ).setUserDetails(
                                    _nameController.text,
                                    _dobController.text,
                                    _numberController.text,
                                  );
                                  Provider.of<RegistrationProvider>(
                                    context,
                                    listen: false,
                                  ).registerUser(context);
                                }
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: isButtonEnabled
                                    ? AppColors.primary
                                    : AppColors.gray001,
                              ),
                              child: Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                        ],
                      ),
                    ),
                  ),
                ),
                if (registrationProvider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}