import 'package:flutter/material.dart';

import '../../widgets/widgetTreeforLoginScreen.dart';

class NewLoginScreen extends StatefulWidget {
  final PageController pageController;

  
  const NewLoginScreen({Key? key,required this.pageController}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                "Setup Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              height: 50,
              child: const Text(
                "Please save fill your details.You can always change it later from your profile",
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                child: const CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  maxRadius: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Upload",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.upload,
                        color: Colors.black,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: const Text(
                "Full name ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: BorderForFields().borderfortextField(),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black54),
                      borderRadius:
                          BorderForFields().borderRadiusForfullName()),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: const Text(
                "University name",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: const dropDownField()),
            Container(
              margin: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 50,
              child:  ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)))),
        onPressed: () {
          widget.pageController.animateToPage(1, duration:const Duration(milliseconds: 500), curve: Curves.easeIn);
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
        )),
            )
          ],
        ),
      ),
    );
  }
}