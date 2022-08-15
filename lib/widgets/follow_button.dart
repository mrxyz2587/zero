import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color iconColor;
  final IconData iconData;
  const FollowButton(
      {Key? key,
      required this.iconColor,
      required this.iconData,
      this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: InkWell(
        onTap: function,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
