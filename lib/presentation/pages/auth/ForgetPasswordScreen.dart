import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../widgets/global/GlobalOutlinEditText.dart';
import '../../provider/ForgetPasswordProvider.dart';
import '../../../widgets/global/GlobalRoundedBackBtn.dart';

import '../../../widgets/global/GlobalRoundedBackBtn.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<ForgetPasswordProvider>(
            builder: (context, forgetPasswordProvider, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (forgetPasswordProvider.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(forgetPasswordProvider.errorMessage),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  forgetPasswordProvider.clearError();
                }
              });
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.05,
                        screenHeight * 0.07,
                        screenWidth * 0.05,
                        0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlobalRoundedBackBtn(
                              onPressed: () => Navigator.pop(context),
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.12,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Text(
                              "Forgot password",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.075,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1,
                              ),
                            ),
                            Text(
                              "Enter your email to reset the password",
                              style: GoogleFonts.poppins(
                                color: AppColors.gray001,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.04),
                              child: GlobalOutlineEditText(
                                hintText: "Enter your email",
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                  ).hasMatch(value)) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    forgetPasswordProvider.setEmail(_emailController.text);
                                    forgetPasswordProvider.getOtp(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                                child: Text(
                                  "Reset Password",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w600,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}