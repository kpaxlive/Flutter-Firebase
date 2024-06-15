import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String fieldText;
  final bool hide;
  final TextEditingController fieldControl;
  const MyTextField({super.key, required this.fieldText, required this.hide, required this.fieldControl});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.fieldControl,
        obscureText: widget.hide,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          fillColor: Colors.grey.shade100,
          filled: true,
          hintText: widget.fieldText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white, width: 10, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gapPadding: BorderSide.strokeAlignCenter,
          ),
        ));
  }
}
