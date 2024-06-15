
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/components/my_button.dart';
import 'package:task_2/components/my_textfield.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/navigation_service.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GetIt getIt = GetIt.instance;
  late final NavigationService _navigationService;
  late final AuthService _auth;
  final TextEditingController mailController = TextEditingController();

  @override
  void initState() {
    _navigationService = getIt.get<NavigationService>();
    _auth = getIt.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade100,
            size: 29,
          ),
          onPressed: () => _navigationService.goBack(),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              //
              Icon(Icons.adjust_sharp, size: 200, color: Colors.grey.shade100),
              //
              const SizedBox(
                height: 20,
              ),
              //
              Text(
                "RESET PASSWORD",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade100),
              ),
              //
              const SizedBox(height: 50),
              //
              MyTextField(
                fieldText: "Enter your email",
                hide: false,
                fieldControl: mailController,
              ),
              //
              const SizedBox(height: 25),
              //
              MyButton(
                buttonText: "Send",
                onTap: () => _auth.sendPasswordResetEmail(mailController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
