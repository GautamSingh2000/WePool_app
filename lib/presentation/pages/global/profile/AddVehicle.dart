import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../provider/VehicleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../provider/VehicleProvider.dart';
import '../../auth/SuccessMessageWidget.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _carController = TextEditingController();

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _carController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final vehicleProvider = Provider.of<AddVehicleProvider>(
          context, listen: false);
      vehicleProvider.setVehicleInfo(
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        color: _carController.text.trim(),
      );
      await vehicleProvider.addVehicle(context);
      if(Provider.of<AddVehicleProvider>(context,listen: false).success){
        // Navigate or show success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Vehicle details are saved !"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Consumer<AddVehicleProvider>(
      builder: (context, vehicleProvider, child) {
        // Show error Snackbar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vehicleProvider.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(vehicleProvider.errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            vehicleProvider.clearError();
          }
        });

        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      GlobalRoundedBackBtn(
                        onPressed: () => Navigator.pop(context),
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.12,
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        "Add your Vehicle",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Vehicle’s brand",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: GlobalOutlineEditText(
                                    hintText: "Enter brand",
                                    controller: _brandController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter vehicle brand";
                                      }
                                      return null;
                                    },
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.04),

                                Text("Vehicle’s Model",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: GlobalOutlineEditText(
                                    hintText: "Enter Vehicle's Model",
                                    controller: _modelController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter vehicle model";
                                      }
                                      return null;
                                    },
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.04),

                                Text("Color",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: GlobalOutlineEditText(
                                    hintText: "Enter Vehicle's Car",
                                    controller: _carController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter vehicle car";
                                      }
                                      return null;
                                    },
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B54F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                              "Add", style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),

            // Loading Overlay
            if (vehicleProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}