import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Center(child: TextButton(
    onPressed: () => throw Exception(),
    child: const Text("Throw Test Exception"),
),),
    );
  }
}