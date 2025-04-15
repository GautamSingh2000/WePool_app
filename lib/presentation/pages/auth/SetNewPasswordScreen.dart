import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/LRSlideTransition.dart';
import '../../../utils/colors.dart';
import '../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../provider/ReSetPasswordProvider.dart';
import 'LoginScreen.dart';
import 'SuccessMessageWidget.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String resetToken;
  final String email;

  const SetNewPasswordScreen({
    super.key,
    required this.resetToken,
    required this.email,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void SetNewPassword() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<ResetPasswordProvider>(
          context,
          listen: false,
        ).resetPassword();

        final resetPasswordProvider = Provider.of<ResetPasswordProvider>(
          context,
          listen: false,
        );

        if (resetPasswordProvider.nextScreen) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => SuccessMessageWidget(
              title: "Successful",
              message: "Your password has been changed.",
              btnTitle: "Login",
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  Navigator.pushAndRemoveUntil(
                    context,
                      LRSlideTransition(LoginScreen()),
                        (route) => false,
                  );
                });
              },
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ResetPasswordProvider>(
          builder: (context, resetPasswordProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (resetPasswordProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(resetPasswordProvider.errorMessage),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
                resetPasswordProvider.clearError();
              }
            });
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.02,
                      screenWidth * 0.05,
                      0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 Back Button
                          GlobalRoundedBackBtn(
                            onPressed: () => Navigator.pop(context),
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.1,
                          ),

                          /// 🔹 Title
                          Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.03),
                            child: Text(
                              "Set a new password",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1,
                              ),
                            ),
                          ),

                          /// 🔹 Subtitle
                          Text(
                            "Create a new password",
                            style: GoogleFonts.poppins(
                              color: AppColors.gray001,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.5,
                            ),
                          ),

                          // EditText for new password
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: GlobalOutlineEditText(
                              hintText: "Enter your new password",
                              controller: _newPasswordController,
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
                          ),

                          // EditText for confirm password
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                            child: GlobalOutlineEditText(
                              hintText: "Re-enter your password",
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                if (value != _newPasswordController.text) {
                                  return "Password must be equal to above password";
                                }
                                return null;
                              },
                            ),
                          ),

                          /// 🔹 update Button
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.04),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      !resetPasswordProvider.isLoading) {
                                    resetPasswordProvider.setResetToken(
                                      widget.resetToken,
                                    );
                                    resetPasswordProvider.setEmailPassword(
                                      widget.email,
                                      _newPasswordController.text,
                                    );
                                    SetNewPassword();
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
                                  "Update Password",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (resetPasswordProvider.isLoading)
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