import 'package:flutter/material.dart';
import 'package:task_2/screens/home_page.dart';
import 'package:task_2/screens/login_page.dart';
import 'package:task_2/screens/register_page.dart';
import 'package:task_2/screens/reset_password.dart';
import 'package:task_2/screens/share_page.dart';
import 'package:task_2/screens/verification_page.dart';

class NavigationService {
  late final GlobalKey<NavigatorState> _navigatorKey;

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  final Map<String, Widget Function(BuildContext)> _routes = {
    '/registerPage': (context) => const RegisterPage(),
    '/loginPage': (context) => const MyLoginPage(),
    '/verificationPage':(context) => const VerificationPage(), 
    '/homePage': (context) => const HomePage(),
    '/resetPassword': (context) => const ResetPassword(),
    '/sharePage':(context) => const SharePage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  void pushNamed(String routeName)
  {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName)
  {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack()
  {
    _navigatorKey.currentState?.pop();
  }
}
