import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:we_pool_app/presentation/provider/PublishRideProvider.dart';
import 'package:we_pool_app/widgets/global/CircularButton.dart';

import '../../../../services/HiveHelper.dart';
import '../../../../utils/LRSlideTransition.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/global/GlobalOutlinEditText.dart';
import '../../../../widgets/global/GlobalRoundedBackBtn.dart';
import 'AddMoreDetails.dart';
import 'DestinationAddressScreen.dart';

class EnterAddress extends StatefulWidget {
  final String addressType;

  const EnterAddress({super.key, required this.addressType});

  @override
  State<EnterAddress> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  final TextEditingController _pickupController = TextEditingController();
  List<String> _recentSearches = []; // List to hold recent searches
  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Load recent searches when the widget initializes
  }

  // Function to load recent searches from Hive
  void _loadRecentSearches() {
    List<String>? searches = HiveHelper.getData(AppConstants.RECENT_SEARCHES);
    if (searches != null && searches.isNotEmpty) {
      _recentSearches = searches.map((item) => item.toString()).toList();
    }
  }

  // Function to save a new search to Hive
  void _saveSearch(String search) {
    if (search.isNotEmpty) {
      _recentSearches.insert(0, search); // Add new search to the beginning
      // Keep only the last 5 searches (or adjust as needed)
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
      HiveHelper.saveData(AppConstants.RECENT_SEARCHES, _recentSearches);
      _loadRecentSearches(); // Reload the list
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print(widget.addressType);
    return Consumer<PublishRideProvider>(
      builder: (
        BuildContext context,
        PublishRideProvider provider,
        Widget? child,
      ) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GlobalRoundedBackBtn(
                    onPressed: () => Navigator.pop(context),
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.12,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Address Input
                  GlobalOutlineEditText(
                    hintText: "Enter your full address",
                    controller: _pickupController,
                    prefixIcon: Image.asset(
                      "assets/icons/ic_search.png",
                      width: screenWidth * 0.035,
                      height: screenHeight * 0.035,
                    ),
                    editable: true,
                    // onChanged: (value) {
                    //   // Save the search when the user submits or navigates away
                    //   _saveSearch(value);
                    // },
                    onTap: () {},
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Current Location Option
                  if (widget.addressType == "pickUpAddress") ...[
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/ic_location.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Use my current location',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: screenHeight * 0.02),
                  // Recent Searches (Conditionally displayed)
                  if (_recentSearches.isNotEmpty)
                    RecentSearchesWidget(recentSearches: _recentSearches),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20.0),
            // Adjust as needed
            child: CircularButton(
              size: 60.0, // Adjust size as needed
              onTap: () {
                if (_pickupController.text.trim().isEmpty) {
                  // Show Snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter address!"),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  if (widget.addressType == "pickUpAddress") {
                    provider.setPickupAddress(_pickupController.text.trim());
                  } else {
                    provider.setDropAddress(_pickupController.text.trim());
                  }
                  Navigator.push(
                    context,
                    LRSlideTransition(
                      widget.addressType == "pickUpAddress"
                          ? DestinationAddressScreen()
                          : AddMoreDetailScreen(),
                    ),
                  );
                }
              },
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endDocked, // Position the button
        );
      },
    );
  }
}

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;

  RecentSearchesWidget({required this.recentSearches});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...recentSearches
            .map(
              (search) => ListTile(
                leading: Icon(Icons.location_on),
                title: Text(search),
              ),
            )
            .toList(),
      ],
    );
  }
}
