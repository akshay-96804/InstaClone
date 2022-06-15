import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hintText,
        border:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        focusedBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        enabledBorder:
            OutlineInputBorder(borderSide: Divider.createBorderSide(context)),
        filled: true,
        contentPadding: EdgeInsets.all(8.0),
      ),
    );
  }
}
