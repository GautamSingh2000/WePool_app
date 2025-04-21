import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_pool_app/presentation/pages/global/myrides/EditPublishRides.dart';
import 'package:we_pool_app/utils/colors.dart';
import 'package:we_pool_app/widgets/global/GlobalRoundedBackBtn.dart';

import '../../../../data/models/UpcomingRideDto.dart';
import '../../../../utils/LRSlideTransition.dart';
import '../../../../widgets/global/WePoolDialog.dart';

class RideDetailsScreen extends StatelessWidget {
  final Ride ride;
  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
        child: SizedBox(
          width: double.infinity,
          height: screenHeight * 0.065,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  LRSlideTransition(EditPublishedRideScreen(ride: ride))
              );
            },
            child: Text(
              "Edit your publication",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.03,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back button
              GlobalRoundedBackBtn(
                onPressed: () => Navigator.pop(context),
                height: screenHeight * 0.06,
                width: screenWidth * 0.12,
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Title & Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ride Details',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      WePoolDialog(
                        context: context,
                        titleText: "Are you sure you want to cancel your ride?",
                        primaryButtonText: "Yes, Cancel",
                        secondaryButtonText: "No, keep it",
                        highlightedButton: HighlightedButton.primary,
                        onPrimaryPressed: () {
                          // Your logic
                        },
                        onSecondaryPressed: () {
                          // Your logic
                        },
                      );
                    },
                    child: Text(
                      'Cancel your ride',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.025,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              /// Ride Info Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Pickup & Drop Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Icon + Dotted Line Column
                        Column(
                          children: [
                            /// Pickup Icon
                            SvgPicture.asset(
                              "assets/icons/ic_pickup.svg",
                              width: screenWidth * 0.05,
                              height: screenWidth * 0.05,
                            ),
                            /// Dashed Line
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight * 0.04,
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  int dashCount = (constraints.maxHeight / 6).floor();
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(dashCount, (_) {
                                      return Container(
                                        width: 1,
                                        height: 4,
                                        color: Colors.grey.shade400,
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),

                            /// Drop Icon
                            SvgPicture.asset(
                              "assets/icons/ic_drop_location.svg",
                              width: screenWidth * 0.05,
                              height: screenWidth * 0.05,
                            ),
                          ],
                        ),
                        SizedBox(width: padding / 2),

                        /// Pickup & Drop Info Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Pickup
                              Text(
                                ride.from,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.004),
                              Text(
                                "", // Optional: replace with real address if available
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.gray001,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),

                              /// Drop
                              Text(
                                ride.to,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.004),
                              Text(
                                "",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    /// Date & Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/ic_calendar.svg",
                              width: screenWidth * 0.04,
                              height: screenWidth * 0.04,
                            ),
                            SizedBox(width: 8),
                            Text(
                              ride.date,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              ride.time,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Divider(height: 2, thickness: 1, color: AppColors.gray005),
                    SizedBox(height: screenHeight * 0.025),

                    /// Payment
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pay in Cash",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.03,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${ride.noOfSeats} Seats",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.025,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "₹${ride.noOfSeats * ride.pricePerSeat}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
