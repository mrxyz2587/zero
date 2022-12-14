import 'package:flutter/material.dart';

class SelectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onPressing;
  SelectionContainer(
      {required this.title, required this.icon, this.onPressing});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressing,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFDFDFDF), width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontSize: 15,
                      fontFamily: 'Roboto'),
                ),
                Icon(
                  icon,
                  size: 30,
                  color: Color(0xFFA3A3A3),
                ),
              ],
            ),
          )),
    );
  }
}
