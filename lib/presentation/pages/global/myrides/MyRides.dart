import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/utils/LRSlideTransition.dart';

import '../../../../widgets/global/MyRideCard.dart';
import '../../../provider/UpcomingRidesProvider.dart';
import 'RideDetailScreen.dart';

class UpcomingRidesScreen extends StatefulWidget {
  const UpcomingRidesScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingRidesScreen> createState() => _UpcomingRidesScreenState();
}

class _UpcomingRidesScreenState extends State<UpcomingRidesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UpcomingRidesProvider>(
        context,
        listen: false,
      ).upcomingRides(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values based on screen size
    final padding = screenWidth * 0.05; // 5% of screen width
    final fontSizeTitle = screenWidth * 0.08; // 8% of screen width
    final fontSizeSubTitle = screenWidth * 0.035; // 4% of screen width
    final fontSizeBody = screenWidth * 0.045; // 4.5% of screen width

    return Consumer<UpcomingRidesProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
            provider.clearError();
          }
        });

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'wepool',
              style: GoogleFonts.abhayaLibre(
                fontWeight: FontWeight.w800,
                fontSize: fontSizeTitle,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child:
                provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            top: screenHeight * 0.04, // 5% of screen height
                          ),
                          child: Text(
                            'Your Upcoming Rides',
                            style: GoogleFonts.poppins(
                              fontSize: fontSizeSubTitle,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child:
                              provider.upcomingRidesList?.isEmpty ?? true
                                  ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/img_empty_state.svg",
                                          semanticsLabel: 'Dart Logo',
                                          height:
                                              screenHeight *
                                              0.3, // 30% of screen height
                                          width: screenWidth * 0.5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Text(
                                            "No Rides scheduled",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: fontSizeBody,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: padding),
                                itemCount: provider.upcomingRidesList!.length,
                                itemBuilder: (context, index) {
                                  final ride = provider.upcomingRidesList![index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          LRSlideTransition(RideDetailsScreen(ride: ride))
                                        );
                                      },
                                      child: RideCard(
                                        pickupLocation: ride.from,
                                        dropLocation: ride.to,
                                        date: ride.date,
                                        time: ride.time,
                                      ),
                                    ),
                                  );
                                },
                              )
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // disables the glow effect on scroll
  }
}
