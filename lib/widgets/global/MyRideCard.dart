import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:we_pool_app/utils/colors.dart';

class RideCard extends StatelessWidget {
  final String pickupLocation;
  final String dropLocation;
  final DateTime rideDateTime;

  const RideCard({
    Key? key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.rideDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEE, d MMMM').format(rideDateTime);
    String formattedTime = DateFormat('h:mm a').format(rideDateTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                pickupLocation,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
            height: 18,
            width: 1.5,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              Image.asset(
                  "assets/icons/ic_drop_location.png",color: Colors.red, height: 16,width: 16,),
              const SizedBox(width: 8),
              Text(
                dropLocation ,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset(
                  "assets/icons/ic_calendar.png" , color: AppColors.primary, height: 18,width: 18),
              const SizedBox(width: 6),
              Text(formattedDate,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),),
              const SizedBox(width: 40),
              Icon(Icons.access_time, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text(formattedTime,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),),
            ],
          ),
        ],
      ),
    );
  }
}
