import 'package:flutter/material.dart';

import 'DetailsScreen.dart';
import 'DetailsScreenTwo.dart';
import 'login_screenNew.dart';
import 'pageIndicator.dart';
import 'pickTheSkills.dart';
import 'picktheInterest.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late PageController _pageController;
  var pageIndex=0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

    child: Scaffold(
      body:  Column(
              children: [
                PageIndicator(PageIndex: pageIndex),
                Expanded(
                  child: PageView(
                    onPageChanged: (value){
                      setState(() {
                        pageIndex=value;
                      });
                    },
                      physics:const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children:  [
                        NewLoginScreen(pageController: _pageController),
                        DetailsScreen(pageController: _pageController),
                        DetailsScreenTwo(pageController: _pageController,),
                        PickYourSkills(pageController: _pageController,),
                        PickTheInterests(pageController: _pageController,)
                      ],
                    
                      ),
                ),
              ],
            ),
    ));

        
      
    
  }
}
