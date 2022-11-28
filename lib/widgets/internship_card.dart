import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/utils/colors.dart';

class InternshipCard extends StatelessWidget {
  final snap;
  final Function()? onpressed;
  const InternshipCard({Key? key, required this.snap, this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      child: GestureDetector(
        onTap: () async {
          final url = snap["applylink"].toString();
          if (await canLaunch(url)) {
            await launch(
              url,
              forceWebView: true,
              enableJavaScript: true,
              enableDomStorage: true,
            );
          }
        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        snap['internshipename'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        snap["internshipcategory"].toString(),
                        // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_outlined, size: 12),
                          SizedBox(width: 2.h),
                          Text(
                            snap["location"].toString(),
                            // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        snap["internshipduration"].toString() +
                            ' | ' +
                            snap["stipened"].toString(),
                        // 'Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () async {
                      final url = snap["applylink"].toString();
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceWebView: true,
                          enableJavaScript: true,
                          enableDomStorage: true,
                        );
                      }
                    },
                    child: Text('Apply',
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: btnCOlorblue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
