import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../utils/LRSlideTransition.dart';

import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../utils/colors.dart';
import '../../provider/RegistrationProvider.dart';
import 'LoginScreen.dart';
import 'OnboardingScreen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Use Padding instead of Container's margin for responsiveness
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "wepool",
                    style: GoogleFonts.abhayaLibre(
                      fontSize: screenWidth * 0.08, // Responsive font size
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Getting Started!",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.07, // Responsive font size
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1,
                    ),
                  ),

                  Text(
                    "Create your account!",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065, // Responsive font size
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),

                  Padding(
                    // Use Padding for responsive margin
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

                  Padding(
                    // Use Padding for responsive margin
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    child: GlobalOutlineEditText(
                      hintText: "Enter your password",
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        if (value.length >= 15) {
                          return "Password must be less then 15 character";
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    // Use Padding for responsive margin
                    padding: EdgeInsets.only(top: screenHeight * 0.04),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Provider.of<RegistrationProvider>(
                              context,
                              listen: false,
                            ).setEmailPassword(
                              _emailController.text,
                              _passwordController.text,
                            );

                            Navigator.push(
                              context,
                              LRSlideTransition(OnboardingScreen(email: _emailController.text),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          "Register",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            // Responsive font size
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    // Use Padding for responsive margin
                    padding: EdgeInsets.only(top: screenHeight * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            // Responsive font size
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              LRSlideTransition(LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            " Login",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.03,
                              // Responsive font size
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
