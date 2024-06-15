// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/services/navigation_service.dart';

class AuthService {
final GetIt _getIt = GetIt.instance;
  late final NavigationService _navigationService;

  FirebaseAuth auth = FirebaseAuth.instance;

  AuthService() {
    _navigationService = _getIt.get<NavigationService>();
    auth.authStateChanges().listen(authStateChangesStreamListener);
  }

  User? _user;

  User? get user {
    return _user;
  }

  Future<void> login(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;

        ScaffoldMessenger.of(
                _navigationService.navigatorKey!.currentState!.context)
            .showSnackBar(
                const SnackBar(content: Text("User verified succesfuly!")));
        _navigationService.pushReplacementNamed(
            '/homePage');
      }
    } catch (e) {
      ScaffoldMessenger.of(
              _navigationService.navigatorKey!.currentState!.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logOut() async {
      try {
        await auth.signOut();
        _navigationService.pushReplacementNamed('/loginPage');
      } catch (e) {
        ScaffoldMessenger.of(_navigationService.navigatorKey!.currentState!.context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    Future<void> register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      ScaffoldMessenger.of(_navigationService.navigatorKey!.currentState!.context)
          .showSnackBar(const SnackBar(content: Text("user created!")));
      _navigationService.pushReplacementNamed('/verificationPage');

    } catch (e) {
      ScaffoldMessenger.of(_navigationService.navigatorKey!.currentState!.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> sendPasswordResetEmail(String mail) async {
      try {
        if (mail.isNotEmpty) {
          await auth.sendPasswordResetEmail(email: mail);
          ScaffoldMessenger.of(_navigationService.navigatorKey!.currentState!.context)
              .showSnackBar(const SnackBar(
                content: Text("Password reset email succesfuly sent!"),
              ))
              .closed
              .then((value) {
            _navigationService.pushReplacementNamed('/loginPage');
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(_navigationService.navigatorKey!.currentState!.context).showSnackBar(SnackBar(
            content: Text(
                "Password reset email couldn't be able to sent!\n ${e.toString()}")));
      }
    }


    void authStateChangesStreamListener(User? user)
    {
      if(user != null)
      {
        _user = user;
      }
      else
      {
        user = null;
      }
    }
}
