import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/utils/colors.dart';
import '/utils/global_variable.dart';
import '/widgets/post_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<String> imageUrls = [
    'https://www.insidesport.in/wp-content/uploads/2021/04/016_WM37_04102021CG_01753-290270b6e5fecca96e9e57bf0cb1fe50.jpg',
    'https://imgs.search.brave.com/IZojU7PfRbPCArOavEepNV_YqGW8u7kA3pk3GVxPSWc/rs:fit:1200:1200:1/g:ce/aHR0cHM6Ly93d3cu/dGhlbm9sb2d5LmNv/bS93cC1jb250ZW50/L3VwbG9hZHMvMjAx/Ni8wMS82MDg4MzIu/anBn'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.messenger_outline,
                    color: primaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: ListView(
        children: [
          ClipRRect(
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 0.8,
                disableCenter: true,
                height: MediaQuery.of(context).size.height * 0.25,
                autoPlay: true,
                scrollDirection: Axis.horizontal,
              ),
              items: imageUrls.map((i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(i, fit: BoxFit.fill)),
                );
              }).toList(),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(keepScrollOffset: true),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
