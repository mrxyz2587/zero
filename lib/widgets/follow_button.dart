import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
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
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(
                widget.iconData,
                color: widget.iconColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
