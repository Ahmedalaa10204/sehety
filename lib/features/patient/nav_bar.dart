import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sehety/core/utils/colors.dart';
import 'package:sehety/core/utils/text_styles.dart';

import 'appointments/appointments_view.dart';
import 'home/presentation/page/home_view.dart';
import 'profile/page/profile_view.dart';
import 'search/page/search_view.dart';

class PatientNavBarWidget extends StatefulWidget {
  const PatientNavBarWidget({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<PatientNavBarWidget> {
  int _selectedIndex = 0;
  final List _pages = [
    const PatientHomeView(),
    const SearchView(),
    const MyAppointments(),
    const PatientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.2),
            ),
          ],
        ),
        child: GNav(
          curve: Curves.easeOutExpo,
          rippleColor: Colors.grey,
          hoverColor: Colors.grey,
          haptic: true,
          tabBorderRadius: 20,
          gap: 5,
          activeColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: AppColors.color1,
          textStyle: getbodyStyle(color: AppColors.white),
          tabs: const [
            GButton(
              iconSize: 28,
              icon: Icons.home,
              text: 'الرئيسية',
            ),
            GButton(
              icon: Icons.search,
              text: 'البحث',
            ),
            GButton(
              iconSize: 28,
              icon: Icons.calendar_month_rounded,
              text: 'المواعيد',
            ),
            GButton(
              iconSize: 29,
              icon: Icons.person,
              text: 'الحساب',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}