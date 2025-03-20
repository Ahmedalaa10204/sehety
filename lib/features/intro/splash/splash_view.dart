import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sehety/core/enums/user_type_enum.dart';
import 'package:sehety/core/functions/navigation.dart';
import 'package:sehety/core/services/local_storage.dart';
import 'package:sehety/features/intro/onboarding/onboarding_view.dart';
import 'package:sehety/features/intro/welcome/welcome_view.dart';
import 'package:sehety/features/patient/nav_bar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user;

  getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getUser();
    Future.delayed(const Duration(seconds: 3), () {
      bool isOnboardingShown =
          AppLocalStorage.getCachedData(key: AppLocalStorage.kOnboarding) ==
              true;
      if (user != null) {
        if (user?.photoURL == UserType.doctor.toString()) {
          // navigate to doctor nav bar
        } else {
          pushAndRemoveUntil(context, const PatientNavBarWidget());
        }
      } else {
        if (isOnboardingShown) {
          pushReplacement(context, const WelcomeView());
        } else {
          pushReplacement(context, const OnboardingScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 220,
        ),
      ),
    );
  }
}