import 'package:flutter/material.dart';
import 'package:we_pool_app/presentation/pages/global/PublishRideScreen.dart';
import 'package:we_pool_app/presentation/pages/global/SearchRideScreen.dart';

import '../widgets/global/BottomNavBar.dart';

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({super.key});

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  int selectedIndex = 1; // Initial screen index

  List<Widget> screenList =  [
    SearchRideScreen(),
    PublishRideScreen(),
    Text("Chat Screen", style: TextStyle(fontSize: 40)),
    Text("Profile Screen", style: TextStyle(fontSize: 40)),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavBar(onItemSelected: onItemTapped),
    );
  }
}