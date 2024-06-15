import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final void Function() onTap;
  const MyButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 75,
          width: 275,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 57, 88, 99),
            border: Border.all(width: 3, color: Colors.white),
            borderRadius: BorderRadius.circular(45),
          ),
          child: Center(
            child: Text(buttonText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w400)),
          ),
        ));
  }
}
