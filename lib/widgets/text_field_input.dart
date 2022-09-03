import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final IconData? iconData;
  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: TextField(
        controller: textEditingController,
        maxLines: 1,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.black45,
        ),
        keyboardType: textInputType,
        showCursor: false,
        obscureText: isPass,
        decoration: InputDecoration(
          enabled: true,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Color(0xFFA3A3A3), fontSize: 15, fontFamily: 'Roboto'),
          fillColor: const Color(0xFFF2F2F2),
          filled: true,
          suffixIcon: Icon(
            iconData,
            size: 10,
            color: Color(0xFFA3A3A3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: const Color(0xFFD9D8D8), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xFFDFDFDF),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
