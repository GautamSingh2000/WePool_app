import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/global/MyRideCard.dart';
import '../../../provider/UpcomingRidesProvider.dart';

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
                fontSize: 34,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 40,
                  ),
                  child: Text(
                    'Your Upcoming Rides',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: provider.upcomingRidesList?.isEmpty ?? true
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/img_empty_state.png",
                          height: 222,
                          width: 258,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "No Rides scheduled",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: provider.upcomingRidesList!.length,
                    itemBuilder: (context, index) {
                      final ride = provider.upcomingRidesList![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: RideCard(
                          pickupLocation: ride.from,
                          dropLocation: ride.to,
                          rideDateTime: DateTime.tryParse(
                            "${ride.date} ${ride.time}",
                          ) ??
                              DateTime.now(),
                        ),
                      );
                    },
                  ),
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
