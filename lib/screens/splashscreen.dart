import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/Service/UserService.dart';
import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/providers/UserDataProvider.dart';
import 'package:travel_app/screens/homescreen.dart';
import 'package:travel_app/screens/logiinscreen.dart';
import 'package:travel_app/screens/onboardingslider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void transferScreen(bool isOpen, bool isLogin, {String? username}) {
    Timer(const Duration(seconds: 1), () {
      if (isLogin) {
        UserDataProvider().setLoggedInUser(UserDto(username: username)); // Store the logged-in user
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => isLogin
              ? HomeScreen()
              : isOpen
              ? const LoginScreen()
              : const Onboardingslider(),
        ),
            (route) => false,
      );
    });
  }

  void checkUserIsFirstTimeOnApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? firstTime = prefs.getString('userfirsttime');
    final String? isLogin = prefs.getString('userloginornot');
    if (firstTime == null) {
      await prefs.setString('userfirsttime', 'Welcome to our app');
      transferScreen(false, false);
    } else if (isLogin == null) {
      transferScreen(true, false);
    } else {
      // Use isLogin to determine the screen to navigate to
      transferScreen(true, isLogin == 'true');
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserIsFirstTimeOnApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: const SafeArea(child: Center(child: Text("Loading..."))),
    );
  }
}
