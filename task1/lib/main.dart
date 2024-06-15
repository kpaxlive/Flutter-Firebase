import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/navigation_service.dart';
import 'package:task_2/utils.dart';

void main() async {
  //
  await setUp();
  //
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
  runApp(MyApp());});
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  late final NavigationService _navigationService;
  late final AuthService _authService;
  MyApp({super.key}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      title: "Authentication",
      routes: _navigationService.routes,
      debugShowCheckedModeBanner: false,
      initialRoute: _authService.user != null ? '/homePage' : '/loginPage',
    );
  }
}
