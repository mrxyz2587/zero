import 'package:flutter/material.dart';
class BorderForFields {
  BorderRadius borderRadiusForfullName() {
    return const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15));
  }
  BorderRadius borderRadiusForuniversity() {
    return const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20));
  }
  OutlineInputBorder borderfortextField() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)),
        borderSide: BorderSide(width: 3, color: Colors.black));
  }
}
class dropDownField extends StatelessWidget {
  const dropDownField({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      iconSize: 25,
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: null,
      items: const [],
      decoration: InputDecoration(
        focusedBorder: BorderForFields().borderfortextField(),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.black54),
            borderRadius: BorderForFields().borderRadiusForfullName()),
      ),
    );
  }
}
