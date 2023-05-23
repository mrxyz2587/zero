import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int PageIndex;
  const PageIndicator({
    required this.PageIndex,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
          3,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                    curve: Curves.easeInCirc,
                    duration: const Duration(milliseconds: 500),
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: index < PageIndex ? Colors.black : Colors.grey,
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.zero, right: Radius.zero))),
              )),
    );
  }
}
