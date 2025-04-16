import 'package:flutter/material.dart';
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

  final List<String> vehicles = ["Tata, Punch", "Hyundai Tucson"];

  void _openDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SizedBox(
            height: 350,
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
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.primary,
                    ),
                    elevation: MaterialStateProperty.all<double>(10.0),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllVehiles();
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

      // Save to provider
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

  Widget _timeInput(String label, void Function(String) onChanged) {
    return SizedBox(
      width: 80,
      child: GlobalOutlineEditText(
        hintText: label,
        keyboardType: TextInputType.number,
        onChanged: (text) {
          onChanged(text);
        },
      ),
    );
  }

  void _getAllVehiles() async {
    final provider = Provider.of<PublishRideProvider>(context, listen: false);
    await provider.getVehiclesList(context);
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
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: GlobalRoundedBackBtn(
                    onPressed: () => Navigator.pop(context),
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 6),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Schedule your ride",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GlobalOutlineEditText(
                                  hintText:
                                      selectedDate != null
                                          ? DateFormat(
                                            'yMMMd',
                                          ).format(selectedDate!)
                                          : "Select Date",
                                  editable: false,
                                  suffixIcon: Image.asset(
                                    "assets/icons/ic_calendar.png",
                                    width: screenWidth * 0.022,
                                    height: screenHeight * 0.02,
                                  ),
                                  suffixIconSize: 22,
                                  onTap: () => _openDatePicker(context),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Pickup Time",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _timeInput(
                                        "Hrs",
                                        (val) => selectedHour = val,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _timeInput(
                                        "Min",
                                        (val) => selectedMinute = val,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            ["AM", "PM"].map((period) {
                                              final isSelected =
                                                  selectedPeriod == period;
                                              return GestureDetector(
                                                onTap:
                                                    () => setState(
                                                      () =>
                                                          selectedPeriod =
                                                              period,
                                                    ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                  child: Text(
                                                    period,
                                                    style: TextStyle(
                                                      color:
                                                          isSelected
                                                              ? AppColors
                                                                  .primary
                                                              : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Select your Vehicle",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              vehicleList.isNotEmpty
                                  ? Wrap(
                                    spacing: 8,
                                    children:
                                        vehicleList.map((vehicle) {
                                          final vehicleName =
                                              "${vehicle.brand}, ${vehicle.model}";
                                          final isSelected =
                                              selectedVehicle == vehicle.id;
                                          return ChoiceChip(
                                            backgroundColor:
                                                isSelected
                                                    ? null
                                                    : AppColors.gray002,
                                            label: Text(vehicleName),
                                            selected: isSelected,
                                            onSelected:
                                                (_) => setState(
                                                  () =>
                                                      selectedVehicle =
                                                          vehicle.id,
                                                ),
                                          );
                                        }).toList(),
                                  )
                                  : GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        LRSlideTransition(
                                          const AddVehicleScreen(),
                                        ),
                                      );
                                      _getAllVehiles();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        "Add a vehicle",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),

                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 48),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    AppColors.primary,
                                  ),
                                  elevation: MaterialStateProperty.all(10.0),
                                ),
                                onPressed: _continue,
                                child: Text(
                                  "Continue",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Loading Overlay
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
