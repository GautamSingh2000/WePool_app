import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../widgets/global/GlobalRoundedButton.dart';

import '../../../utils/LRSlideTransition.dart';
import '../../provider/LoginProvider.dart';
import 'CreateAccountScreen.dart';
import 'ForgetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.05; // Adaptive padding

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, loginProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (loginProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loginProvider.errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                loginProvider.clearError();
              }
            });

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Text(
                            "wepool",
                            style: GoogleFonts.abhayaLibre(
                              fontSize: size.width * 0.08, // Scales text size
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "Welcome back!",
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.07,
                              fontWeight: FontWeight.w300,
                              letterSpacing: -1,
                            ),
                          ),
                          Text(
                            "Glad to see you, Again!",
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),

                          // Email Input
                          GlobalOutlineEditText(
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
                          SizedBox(height: size.height * 0.03),

                          // Password Input
                          GlobalOutlineEditText(
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
                              return null;
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  LRSlideTransition(ForgetPasswordScreen()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.width * 0.025,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.03),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final credentials = {
                                    "email": _emailController.text,
                                    "password": _passwordController.text,
                                  };
                                  loginProvider.loginUser(credentials, context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.018,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don’t have an account?",
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    LRSlideTransition( CreateAccountScreen()),
                                        (route) => false,
                                  );
                                },
                                child: Text(
                                  " Register Now",
                                  style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),

                // Loading Overlay
                if (loginProvider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
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
