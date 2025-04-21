import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/data/models/UpcomingRideDto.dart';

import '../../../../utils/LRSlideTransition.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import '../../../../widgets/global/WePoolDialog.dart';
import '../../../provider/EditPublishRideProvider.dart';
import '../profile/AddVehicle.dart';

class EditPublishedRideScreen extends StatefulWidget {
  final Ride ride;
  const EditPublishedRideScreen({super.key, required this.ride});

  @override
  State<EditPublishedRideScreen> createState() =>
      _EditPublishedRideScreenState();
}



class _EditPublishedRideScreenState extends State<EditPublishedRideScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController leavingFromController = TextEditingController(text: widget.ride.from);
  late TextEditingController goingToController = TextEditingController(text: widget.ride.to);
  late TextEditingController dateController = TextEditingController(text: widget.ride.date);
  late TextEditingController hourController = TextEditingController();
  late TextEditingController minuteController = TextEditingController();
  late TextEditingController _noteController = TextEditingController(text: widget.ride.summary);
  late TextEditingController _seatController  = TextEditingController(text:widget.ride.noOfSeats.toString());
  late TextEditingController _priceController =  TextEditingController(text:(widget.ride.noOfSeats * widget.ride.pricePerSeat).toString());

  DateTime? selectedDate;
  String selectedPeriod = "AM";
  String? selectedVehicle;


  void _getAllVehiles() async {
    final provider = Provider.of<EditPublishRideProvider>(context, listen: false);
    await provider.getVehiclesList(context);
  }


  void parseTime(String timeString) {
    try {
      print('Raw input: "$timeString"');

      // Step 1: Clean and normalize the string
      final cleaned = timeString
          .replaceAll('\u202f', '') // Narrow no-break space
          .replaceAll('\u00a0', '') // Non-breaking space
          .replaceAll('\u200b', '') // Zero-width space
          .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces
          .trim()
          .toUpperCase(); // Normalize to uppercase for AM/PM

      print('Cleaned input: "$cleaned"');

      // Step 2: Extract parts using RegExp
      final regex = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
      final match = regex.firstMatch(cleaned);

      if (match != null) {
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!;

        // Step 3: Set controller values
        hourController.text =  hour.toString() ;
        minuteController.text = minute.toString().padLeft(2, '0') ;
        selectedPeriod = period;

        print('Parsed hour: ${hourController.text}');
        print('Parsed minute: ${minuteController.text}');
        print('Period: $selectedPeriod');
      } else {
        print("Time parsing failed: format doesn't match.");
      }
    } catch (e) {
      print("Unexpected error during time parsing: $e");
    }
  }




  @override
  void initState() {
    super.initState();
    _getAllVehiles();
    parseTime(widget.ride.time);
  }


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<EditPublishRideProvider>(context, listen: false);
      if (selectedDate == null) {
        _showErrorSnackbar("Please select a date");
      } else if (hourController.text == null || minuteController.text == null) {
        _showErrorSnackbar("Please select pickup time");
      } else if (selectedVehicle == null) {
        _showErrorSnackbar("Please select a vehicle");
      } else {
        int? hourNullable = int.tryParse(hourController.text);
        int? minuteNullable = int.tryParse(minuteController.text);

        if (hourNullable == null || hourNullable < 1 || hourNullable > 12) {
          _showErrorSnackbar("Enter a valid hour (1-12)");
          return;
        }
        if (minuteNullable == null || minuteNullable < 0 ||
            minuteNullable > 59) {
          _showErrorSnackbar("Enter a valid minute (0-59)");
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
      }
    }else {
      _showErrorSnackbar("Please fill all required fields correctly.");
    }
  }

  Widget _buildCounterRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    required TextEditingController controller,
    bool currency = false,
  }) {
    // Ensure controller is in sync without resetting cursor
    if (controller.text != value.toString()) {
      controller.text = value.toString();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: context.screenHeight * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: context.screenWidth * 0.034,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              _roundIconBtn(Icons.remove, () {
                if (value > 1) onChanged(value - 1);
              }),
              SizedBox(width: context.screenWidth * 0.02),
              Container(
                width: context.screenWidth * 0.18,
                height: context.screenHeight * 0.06,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: context.screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        if (label == 'No of seats' && parsed > 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("You can’t add more than 5 seats."),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                bottom: context.screenHeight * 0.08,
                                left: 16,
                                right: 16,
                              ),
                            ),
                          );
                          return;
                        }
                        onChanged(parsed);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: context.screenWidth * 0.02),
              _roundIconBtn(Icons.add, () {
                if (label == 'No of seats' && value >= 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You can’t add more than 5 seats."),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: context.screenHeight * 0.08,
                        left: 16,
                        right: 16,
                      ),
                    ),
                  );
                  return;
                }
                onChanged(value + 1);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundIconBtn(IconData icon, VoidCallback onPressed) {
    return Center(
      child: Container(
        width: context.screenWidth * 0.06,
        height: context.screenWidth * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: Icon(
              icon,
              size: context.screenWidth * 0.045,
              color: AppColors.iconGray02,
            ),
            splashRadius: context.screenWidth * 0.06,
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Padding(
      padding: EdgeInsets.only(top: context.screenHeight * 0.02),
      child: TextField(
        controller: _noteController,
        maxLines: 5,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: context.screenWidth * 0.031,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.borderGray01),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          hintText: "Type anything specific",
          hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: AppColors.iconGray02,
            fontSize: context.screenWidth * 0.031,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.all(context.screenWidth * 0.03),
        ),
      ),
    );
  }

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
                      setState(() {
                        selectedDate = date;
                        dateController.text = DateFormat('yMMMd').format(selectedDate!);
                      });
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

  @override
  void dispose() {
    _seatController.dispose();
    _priceController.dispose();
    leavingFromController.dispose();
    goingToController.dispose();
    dateController.dispose();
    hourController.dispose();
    minuteController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<EditPublishRideProvider>(context);
    final vehicleList = provider.vechilesList;

    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;

    return Scaffold(
      body: SafeArea(
        child: Consumer<EditPublishRideProvider>(
          builder: (context, editPublishRideProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (editPublishRideProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(editPublishRideProvider.errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                editPublishRideProvider.clearError();
              }
            });
            editPublishRideProvider.updateRideId(widget.ride.id);
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          GlobalRoundedBackBtn(
                            onPressed: () => Navigator.pop(context),
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.12,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit your publication',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
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
                                      editPublishRideProvider.deleteRide(context);
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
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Leaving From",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),

                          GlobalOutlineEditText(
                            hintText: 'Select City Walk, Hauz Khaz',
                            controller: leavingFromController,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Please enter leaving location'
                                        : null,
                          ),
                          SizedBox(height: screenHeight * 0.030),
                          Text(
                            "Going to",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),

                          GlobalOutlineEditText(
                            hintText: 'Kings Mall, Rohini',
                            controller: goingToController,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Please enter destination'
                                        : null,
                          ),
                          SizedBox(height: screenHeight * 0.030),
                          Text(
                            "Schedule your ride",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),

                          GlobalOutlineEditText(
                            hintText: dateController.text,
                            controller: dateController,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Please select a date'
                                        : null,
                            editable: false,
                            suffixIcon: SvgPicture.asset(
                              "assets/icons/ic_calendar.svg",
                              width: screenWidth * 0.05,
                              height: screenHeight * 0.025,
                              colorFilter: const ColorFilter.mode( AppColors.gray004 , BlendMode.srcIn),
                              semanticsLabel: 'Calendar icon',
                            ),
                            suffixIconSize: 22,
                            onTap: () => _openDatePicker(context),
                          ),

                          SizedBox(height: screenHeight * 0.030),
                          Text(
                            "Time",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),

                          Row(
                            children: [
                              Expanded(
                                child: GlobalOutlineEditText(
                                  hintText: 'Hrs',
                                  suffixText: 'Hrs',
                                  controller: hourController,
                                  validator:
                                      (val) =>
                                          val == null || val.isEmpty
                                              ? 'Hour required'
                                              : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlobalOutlineEditText(
                                  hintText: 'Min',
                                  suffixText: 'Min',
                                  controller: minuteController,
                                  validator:
                                      (val) =>
                                          val == null || val.isEmpty
                                              ? 'Minute required'
                                              : null,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      ["AM", "PM"].map((period) {
                                        final isSelected =
                                            selectedPeriod == period;
                                        return GestureDetector(
                                          onTap:
                                              () => setState(() {
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
                                                color:
                                                    isSelected
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
                          SizedBox(height: screenHeight * 0.035),
                          Text(
                            "Select your Vehicle",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),
                          if (vehicleList.isNotEmpty)
                            Wrap(
                              spacing: screenWidth * 0.02,
                              children:
                                  vehicleList.map((vehicle) {
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
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected:
                                          (_) => setState(() {
                                            selectedVehicle = vehicle.id;
                                          }),
                                    );
                                  }).toList(),
                            )
                          else
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  LRSlideTransition(const AddVehicleScreen()),
                                );
                              },

                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                ),
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

                          Column(
                            children: [
                              _buildCounterRow(
                                label: 'No of seats',
                                value: int.tryParse(_seatController.text) ?? 0,
                                onChanged: (val) {
                                  setState(() {
                                    _seatController.text = val.toString();
                                  });
                                },
                                controller: _seatController,
                              ),
                              SizedBox(width: 16),
                              _buildCounterRow(
                                label: 'Price per seat',
                                value: int.tryParse(_priceController.text) ?? 0,
                                onChanged: (val) {
                                  setState(() {
                                    _priceController.text = val.toString();
                                  });
                                },
                                controller: _priceController,
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.035),
                          Text(
                            "Anything to add about the ride",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.010),

                          _buildTextArea(),

                          SizedBox(height: screenHeight * 0.035),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _onSavePressed,
                              child: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                if (editPublishRideProvider.isLoading)
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

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;
}
