import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onItemSelected;

  const BottomNavBar({super.key, required this.onItemSelected});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int myIndex = 1;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: AppColors.gray001, width: 0.4),
        ),
        height: 89,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
            widget.onItemSelected(
              index,
            ); // Call the callback with the selected index
          },
          currentIndex: myIndex,
          iconSize: 24,
          unselectedItemColor: AppColors.gray004,
          selectedItemColor: AppColors.primary,
          selectedFontSize: 10,
          backgroundColor: Colors.transparent,
          unselectedFontSize: 9,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myIndex == 0 ? AppColors.primary : AppColors.gray004,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_search.svg", // ✅ Make sure it's .svg
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconGray01,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'Search icon',
                  ),
                ),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myIndex == 1 ? AppColors.primary : AppColors.gray004,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_publish.svg", // ✅ Make sure it's .svg
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconGray01,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'Publish icon',
                  ),
                ),
              ),
              label: 'Publish',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myIndex == 2 ? AppColors.primary : AppColors.gray004,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_app_icon.svg", // ✅ Make sure it's .svg
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconGray01,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'MyRide icon',
                  ),
                ),
              ),
              label: 'Your Rides',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myIndex == 3 ? AppColors.primary : AppColors.gray004,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/ic_message.svg", // ✅ Make sure it's .svg
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconGray01,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'Message icon',
                  ),
                ),
              ),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    myIndex == 4 ? AppColors.primary : AppColors.gray004,
                    BlendMode.srcIn,
                  ),
                  child:SvgPicture.asset(
                    "assets/icons/ic_profile.svg", // ✅ Make sure it's .svg
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.iconGray01,
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: 'Profile icon',
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
