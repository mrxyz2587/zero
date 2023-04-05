import 'package:flutter/material.dart';

import 'skillsStaticData.dart';

class PickTheInterests extends StatefulWidget {
  final PageController pageController;
  const PickTheInterests({Key? key, required this.pageController}) : super(key: key);
  @override
  State<PickTheInterests> createState() => _InterestsState();
}
class _InterestsState extends State<PickTheInterests> {
  List<String> _selectedInterests = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                    size: 20,
                    color: Colors.black,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      "Choose Your Interests",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: const Text(
                      "max 5",
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.03, top: size.height * 0.012),
                child: SizedBox(
                    width: size.width,
                    child: Column(
                      children: [
                        MultiSelectInterests(
                          onSlectionChanged: (interestList) {
                            setState(() {
                              _selectedInterests = interestList;
                            });
                          },
                          interestList: SkillsStaticData().yourInterests,
                        )
                      ],
                    )),
              ),
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
                    widget.pageController.animateToPage(4,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: const Text(
                    "finish",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class MultiSelectInterests extends StatefulWidget {
  final List<String> interestList;
  final Function(List<String>) onSlectionChanged;
  final Function(List<String>)? onMaxSelected;
  const MultiSelectInterests(
      {Key? key,
      required this.interestList,
      required this.onSlectionChanged,
      this.onMaxSelected})
      : super(key: key);
  @override
  State<MultiSelectInterests> createState() => _MultiSelectInterestsState();
}
class _MultiSelectInterestsState extends State<MultiSelectInterests> {
  List<String> selectedintersts = [];
  List<Widget> _buildChoicesList() {
    List<Widget> _widgetList = [];
    for (var item in widget.interestList) {
      _widgetList.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Colors.amber,
          onSelected: (selected) {
            setState(() {
              if (selectedintersts.length == 5 &&
                  !selectedintersts.contains(item)) {
                widget.onMaxSelected?.call(selectedintersts);
              } else {
                selectedintersts.contains(item)
                    ? selectedintersts.remove(item)
                    : selectedintersts.add(item);
                widget.onSlectionChanged(selectedintersts);
              }
            });
          },
          label: Text(item),
          selected: selectedintersts.contains(item),
        ),
      ));
    }
    return _widgetList;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoicesList(),
    );
  }
}