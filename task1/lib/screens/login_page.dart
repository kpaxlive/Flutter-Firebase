
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/components/my_button.dart';
import 'package:task_2/components/my_richtext.dart';
import 'package:task_2/components/my_textfield.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/navigation_service.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
    final GetIt _getIt = GetIt.instance;
    late AuthService auth;
    late NavigationService navigationService;
    
    TextEditingController mailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    @override
  void initState() {
    navigationService = _getIt.get<NavigationService>();
    auth = _getIt.get<AuthService>();
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
                "LOGIN",
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
                fieldControl: mailController,
              ),
              //
              const SizedBox(height: 25),
              //
              MyTextField(
                fieldText: "Password",
                hide: true,
                fieldControl: passwordController,
              ),
              //
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyRichText(
                    fontSize: 14,
                    secondString: "Forgot password?",
                    firstString: "",
                    fontW: FontWeight.w600,
                    routeName: '/resetPassword',
                  ),
                ],
              ),
              const SizedBox(height: 35),
              //
              MyButton(
                buttonText: "Sign In",
                onTap: () => auth.login(mailController.text, passwordController.text),
              ),

              //
              const SizedBox(height: 25),
              //
              const MyRichText(
                firstString: "Dont you have an account? ",
                secondString: "Sign Up",
                routeName: '/registerPage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
