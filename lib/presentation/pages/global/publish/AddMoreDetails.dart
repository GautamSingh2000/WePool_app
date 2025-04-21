import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/utils/colors.dart';
import 'package:we_pool_app/widgets/global/GlobalOutlinEditText.dart';
import 'package:we_pool_app/widgets/global/GlobalRoundedBackBtn.dart';

import '../../../../utils/LRSlideTransition.dart';
import '../../../provider/PublishRideProvider.dart';
import '../profile/AddVehicle.dart';
import 'PublishRideScreen.dart';

class AddMoreDetailScreen extends StatefulWidget {
  const AddMoreDetailScreen({Key? key}) : super(key: key);

  @override
  State<AddMoreDetailScreen> createState() => _AddMoreDetailScreenState();
}

class _AddMoreDetailScreenState extends State<AddMoreDetailScreen> {
  DateTime? selectedDate;
  String? selectedHour;
  String? selectedMinute;
  String selectedPeriod = "AM";
  String? selectedVehicle;

  void _openDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return SizedBox(
          height: screenHeight * 0.5,
          child: Column(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: AppColors.primary,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                    onDateChanged: (date) {
                      setState(() => selectedDate = date);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.035,
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

  void _continue() {
    final provider = Provider.of<PublishRideProvider>(context, listen: false);
    if (selectedDate == null) {
      _showError("Please select a date");
    } else if (selectedHour == null || selectedMinute == null) {
      _showError("Please select pickup time");
    } else if (selectedVehicle == null) {
      _showError("Please select a vehicle");
    } else {
      int? hourNullable = int.tryParse(selectedHour!);
      int? minuteNullable = int.tryParse(selectedMinute!);

      if (hourNullable == null || hourNullable < 1 || hourNullable > 12) {
        _showError("Enter a valid hour (1-12)");
        return;
      }
      if (minuteNullable == null || minuteNullable < 0 || minuteNullable > 59) {
        _showError("Enter a valid minute (0-59)");
        return;
      }

      int hour = hourNullable;
      int minute = minuteNullable;

      if (selectedPeriod == "PM" && hour != 12) hour += 12;
      if (selectedPeriod == "AM" && hour == 12) hour = 0;

      DateTime finalTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        hour,
        minute,
      );

      String formattedDate = DateFormat('yMMMd').format(selectedDate!);
      String formattedTime = DateFormat('hh:mm a').format(finalTime);

      provider.addRideDetails(formattedTime, formattedDate, selectedVehicle!);
      Navigator.push(context, LRSlideTransition(PublishRideScreen()));
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _timeInput(String label, void Function(String) onChanged, double width) {
    return SizedBox(
      width: width,
      child: GlobalOutlineEditText(
        hintText: label,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  void _getAllVehiles() async {
    final provider = Provider.of<PublishRideProvider>(context, listen: false);
    await provider.getVehiclesList(context);
  }


  @override
  void initState() {
    super.initState();
    _getAllVehiles();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PublishRideProvider>(context);
    final vehicleList = provider.vechilesList;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Consumer<PublishRideProvider>(
          builder: (context, publishRideProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (publishRideProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(publishRideProvider.errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                publishRideProvider.clearError();
              }
            });

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.04,
                    top: screenHeight * 0.01,
                  ),
                  child: GlobalRoundedBackBtn(
                    onPressed: () => Navigator.pop(context),
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.12,
                  ),
                ),
                Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: screenWidth,
                      margin: EdgeInsets.all(screenWidth * 0.00),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.04,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.0),
                          Text(
                            "Schedule your ride",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          GlobalOutlineEditText(
                            hintText: selectedDate != null
                                ? DateFormat('yMMMd').format(selectedDate!)
                                : "Select Date",
                            editable: false,
                            suffixIcon:SvgPicture.asset(
                              "assets/icons/ic_calendar.svg",
                              width: screenWidth * 0.05,
                              height: screenHeight * 0.025,
                              colorFilter: const ColorFilter.mode( AppColors.gray004 , BlendMode.srcIn),
                              semanticsLabel: 'Calendar icon',
                            ),
                            suffixIconSize: 22,
                            onTap: () => _openDatePicker(context),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "Pickup Time",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              _timeInput("Hrs", (val) => selectedHour = val,
                                  screenWidth * 0.22),
                              SizedBox(width: screenWidth * 0.03),
                              _timeInput("Min", (val) => selectedMinute = val,
                                  screenWidth * 0.22),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: ["AM", "PM"].map((period) {
                                    final isSelected =
                                        selectedPeriod == period;
                                    return GestureDetector(
                                      onTap: () => setState(() {
                                        selectedPeriod = period;
                                      }),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.03,
                                          vertical: screenHeight * 0.01,
                                        ),
                                        child: Text(
                                          period,
                                          style: TextStyle(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: screenWidth * 0.035,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "Select your Vehicle",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          vehicleList.isNotEmpty
                              ? Wrap(
                            spacing: screenWidth * 0.02,
                            children: vehicleList.map((vehicle) {
                              final vehicleName =
                                  "${vehicle.brand}, ${vehicle.model}";
                              final isSelected =
                                  selectedVehicle == vehicle.id;
                              return ChoiceChip(
                                backgroundColor: AppColors.gray002,
                                selectedColor: AppColors.primary,
                                label: Text(
                                  vehicleName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (_) => setState(() {
                                  selectedVehicle = vehicle.id;
                                }),
                              );
                            }).toList(),
                          )
                              : GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                LRSlideTransition(
                                    const AddVehicleScreen()),
                              );
                              _getAllVehiles();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: Text(
                                "Add a vehicle",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.035,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(screenWidth * 0.02),
                              ),
                              minimumSize: Size(double.infinity,
                                  screenHeight * 0.065),
                            ),
                            onPressed: _continue,
                            child: Text(
                              "Continue",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (publishRideProvider.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
