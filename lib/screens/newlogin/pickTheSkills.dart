import 'package:flutter/material.dart';

import 'skillsStaticData.dart';

class PickYourSkills extends StatefulWidget {
  final PageController pageController;
  const PickYourSkills({Key? key, required this.pageController})
      : super(key: key);
  @override
  State<PickYourSkills> createState() => _PickYourSkillsState();
}
class _PickYourSkillsState extends State<PickYourSkills> {
  List<String> selectedChoicesList = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                widget.pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              icon: const Icon(
                Icons.keyboard_backspace_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: const Text(
                    "Pick your top Skills",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: const Text(
                    "max 10",
                    style: TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                "Tap to select your top skills",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.black45,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black45),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black45),
                      borderRadius: BorderRadius.circular(20)),
                  label: const Text(
                    "Search skills like figma,wordpress",
                    style: TextStyle(color: Colors.black45),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black45,
                    size: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.03, top: size.height * 0.012),
              child: SizedBox(
                  width: size.width,
                  child: Column(
                    children: [
                      MultiSelectChip(
                        onSlectionChanged: (selectedList) {
                          setState(() {
                            selectedChoicesList = selectedList;
                          });
                        },
                        reportList: SkillsStaticData().skillsData,
                      ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Save",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.arrow_right_alt)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSlectionChanged;
  final Function(List<String>)? onMaxSelected;
  const MultiSelectChip(
      {Key? key,
      required this.reportList,
      required this.onSlectionChanged,
      this.onMaxSelected})
      : super(key: key);
  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  // String slectedChoice = "";
  List<String> selectedChoices = [];
  List<Widget> _buildChoicesList() {
    List<Widget> developement = [];
    for (var item in widget.reportList) {
      var isSkill = (item == "Front End Developement" ||
          item == "Developement" ||
          item == "Fashion Design" ||
          item == "Marketing" ||
          item == "Video Editing");
      developement.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: isSkill
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  )
                ],
              )
            : ChoiceChip(
                label: Text(item),
                selected: selectedChoices.contains(item),
                onSelected: (slected) {
                  setState(() {
                    if (selectedChoices.length == (10) &&
                        !selectedChoices.contains(item)) {
                      widget.onMaxSelected?.call(selectedChoices);
                    } else {
                      selectedChoices.contains(item)
                          ? selectedChoices.remove(item)
                          : selectedChoices.add(item);
                      widget.onSlectionChanged(selectedChoices);
                    }
                  });
                },
              ),
      ));
    }
    return developement;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoicesList(),
    );
  }
}