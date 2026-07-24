import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthChecker
    extends StatefulWidget {

  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() =>
      _AuthCheckerState();
}

class _AuthCheckerState
    extends State<AuthChecker> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {

    String? token =
    await AuthService.getToken();

    if (!mounted) return;

    if (token != null) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomeScreen(),
        ),
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return const Scaffold(
      body: Center(
        child:
        CircularProgressIndicator(),
      ),
    );
  }
}