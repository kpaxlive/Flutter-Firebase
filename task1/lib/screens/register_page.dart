// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/components/my_button.dart';
import 'package:task_2/components/my_richtext.dart';
import 'package:task_2/components/my_textfield.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/navigation_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GetIt _getIt = GetIt.instance;
  late final AuthService auth;
  late final NavigationService navigationService;

  @override
  void initState() {
    auth = _getIt.get<AuthService>();
    navigationService = _getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 35),
              //
              Icon(Icons.adjust_sharp, size: 200, color: Colors.grey.shade100),
              //
              const SizedBox(
                height: 20,
              ),
              //
              Text(
                "SIGN UP",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade100),
              ),
              //
              const SizedBox(height: 50),
              //
              MyTextField(
                  fieldText: "Email",
                  hide: false,
                  fieldControl: mailController),
              //
              const SizedBox(height: 25),
              //
              MyTextField(
                  fieldText: "Password",
                  hide: true,
                  fieldControl: passwordController),
              //
              const SizedBox(height: 35),
              //
              MyButton(
                  buttonText: "Sign Up",
                  onTap: () {
                    auth.register(mailController.text, passwordController.text);
                  }),

              //
              const SizedBox(height: 25),
              //
              const MyRichText(
                firstString: "Have you registered before? ",
                secondString: "Sign In",
                routeName: '/loginPage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
