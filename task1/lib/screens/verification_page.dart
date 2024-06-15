import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/navigation_service.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    with TickerProviderStateMixin {
  final GetIt getIt = GetIt.instance;
  late final AuthService auth;
  late final NavigationService navigationService;

  late final AnimationController _controller;
  int animationIndex = 1;

  StreamSubscription<User?>? _authChangeSubscription;

  @override
  void initState() {
    super.initState();
    auth = getIt.get<AuthService>();
    navigationService = getIt.get<NavigationService>();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        navigationService.pushReplacementNamed("/loginPage");
      }
    });

    auth.user!.sendEmailVerification();
    _startEmailVerificationCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    _authChangeSubscription?.cancel();
    super.dispose();
  }

void _startEmailVerificationCheck() async {
  Timer.periodic(const Duration(seconds: 3), (timer) async {
    User? user = auth.user;

    if (user != null) {
      await user.reload();
      User? updatedUser = auth.auth.currentUser;
      
      if (updatedUser != null && updatedUser.emailVerified) {
        timer.cancel();

        setState(() {
          animationIndex = 2;
        });

        _controller.forward();
      }
    }
  });
}

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widhtScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: heightScreen / 5,
              child: const Center(
                  child: Text("Check Your Email",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 40),
                height: 400,
                width: widhtScreen,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: (Radius.circular(35)),
                      topRight: Radius.circular(35)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Hello!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade800),
                    ),
                    Text(auth.user!.email!,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade800)),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text("We sent a verification link to your email ",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w400)),
                    animationIndex == 1
                        ? SizedBox(
                            height: heightScreen * 0.45,
                            width: widhtScreen * 0.8,
                            child: Lottie.asset(
                                "assets/animations/animation$animationIndex.json",
                                height: heightScreen / 3,
                                width: widhtScreen / 3))
                        : SizedBox(
                            height: heightScreen * 0.45,
                            width: widhtScreen * 0.8,
                            child: Lottie.asset(
                              "assets/animations/animation$animationIndex.json",
                              height: heightScreen / 3,
                              width: widhtScreen / 3,
                              controller: _controller,
                              onLoaded: (value) {
                                _controller.duration = value.duration;
                                _controller.forward();
                              },
                            ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
