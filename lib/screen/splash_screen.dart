import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/util/asset.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _duration = 2;
  
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = HiveService.getUserData().isNotEmpty;
    Future.delayed(Duration(seconds: _duration), () {
      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? Routes.home : Routes.login,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(width * 0.1),
        child: Center(
          child: Image.asset(
            Asset.logo,
          ),
        ),
      ),
    );
  }
}
