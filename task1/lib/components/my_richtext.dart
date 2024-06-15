import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/services/navigation_service.dart';

class MyRichText extends StatefulWidget {
  final String firstString;
  final String secondString;
  final String routeName;
  final double? fontSize;
  final FontWeight? fontW;
   const MyRichText(
      {super.key, required this.firstString, required this.secondString, required this.routeName, this.fontSize, this.fontW});

  @override
  State<MyRichText> createState() => _MyRichTextState();
}

class _MyRichTextState extends State<MyRichText> {
  final GetIt getIt = GetIt.instance;

  late final NavigationService _navigationService;

  @override
  void initState() {
    _navigationService = getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.firstString,
            style: TextStyle(
                color: Colors.grey.shade200, fontWeight: FontWeight.w500)),
        GestureDetector(
          onTap: () => 
          widget.routeName == '/resetPassword' 
          ? _navigationService.pushNamed(widget.routeName)
          : _navigationService.pushReplacementNamed(widget.routeName),
          child: Text(widget.secondString,
              style: TextStyle(
                  color: Colors.blue.shade600,
                  fontWeight: widget.fontW ?? FontWeight.w700,
                  fontSize: widget.fontSize?? 16)),
        ),
      ],
    );
  }
}
