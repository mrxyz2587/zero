import 'package:flutter/material.dart';
import '../../widgets/widgetTreeforLoginScreen.dart';

class DetailsScreenTwo extends StatefulWidget {
  final PageController pageController;
  const DetailsScreenTwo({Key? key,required this.pageController}) : super(key: key);

  @override
  State<DetailsScreenTwo> createState() => _DetailsScreenTwoState();
}

class _DetailsScreenTwoState extends State<DetailsScreenTwo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            IconButton(
              onPressed: () {
                  widget.pageController.previousPage( duration:const Duration(milliseconds: 500), curve: Curves.easeIn);
              },
              icon: const Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              width: double.infinity,
              height: 100,
              child: const Text(
                "Knowing your details will help us recommend you suitable clubs to joins & your nearby bundles",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                child: const CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  maxRadius: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: const Text(
                "Gender",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: const dropDownField(),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: const Text(
                "Date of Birth",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: TextFormField(
                 
                  decoration: InputDecoration(
                    suffixIcon:const Icon(Icons.calendar_today),
                    focusedBorder: BorderForFields().borderfortextField(),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black87),
                        borderRadius:
                            BorderForFields().borderRadiusForfullName()),
                  ),
                )),
            Container(
                margin: const EdgeInsets.all(8.0),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)))),
        onPressed: () {
            widget.pageController.animateToPage(3, duration:const Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Continue",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 15,
            ),
            Icon(Icons.arrow_right_alt)
          ],
        )))
          ],
        ),
      ),
    );
  }
}
