import 'package:flutter/material.dart';
import 'package:machine_test_totalx/presentation/views/users/home_screen.dart';
import '../presentation/views/auth/login_screen.dart';
import '../presentation/views/auth/otp_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String homescreen = '/homescreen';
  static const String searchUser = '/searchUser';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case homescreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
   
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route found')),
          ),
        );
    }
  }
}