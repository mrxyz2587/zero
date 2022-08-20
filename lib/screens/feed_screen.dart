import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zero_fin/screens/profile_screen.dart';
import 'package:zero_fin/screens/search_screen.dart';
import '../providers/user_provider.dart';
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
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uid: userProvider.getUser.uid,
                              )));
                },
                child: CircleAvatar(
                  maxRadius: 5,
                  backgroundImage: NetworkImage(
                    userProvider.getUser.photoUrl,
                  ),
                ),
              ),
              title: Text(
                'zero',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.paperPlane,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
      body: ListView(
        children: [
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('banners').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ClipRRect(
                child: CarouselSlider.builder(
                  itemCount: snapshot.data!.docs.length,

                  options: CarouselOptions(
                    viewportFraction: 0.8,
                    disableCenter: true,
                    height: MediaQuery.of(context).size.height * 0.25,
                    autoPlay: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      GestureDetector(
                    onTap: () async {
                      final url = snapshot.data!.docs[itemIndex]
                          .data()["url"]
                          .toString();

                      showModalBottomSheet(
                        enableDrag: true,
                        isDismissible: true,
                        backgroundColor: Colors.black.withOpacity(0.2),
                        context: context,
                        builder: (BuildContext c) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5))),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        'THis will take you to another website'),
                                    RaisedButton(
                                      onPressed: () async {
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        }
                                      },
                                      color: Colors.black,
                                      child: Text('Raised Button'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              snapshot.data!.docs[itemIndex]
                                  .data()["imageUrl"]
                                  .toString(),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  // imageUrls.map((i) {
                  //   return Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 1, vertical: 10),
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         color: Colors.grey.shade200),
                  //     child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(10),
                  //         child: Image.network(  snapshot.data!.docs[index]
                  //             .data()["imageUrl"]
                  //             .toString(),
                  //             , fit: BoxFit.fill)),
                  //   );
                  // }).toList(),
                ),
              );

              // ListView.builder(
              //   addAutomaticKeepAlives: true,
              //   shrinkWrap: true,
              //   controller: ScrollController(keepScrollOffset: true),
              //   scrollDirection: Axis.vertical,
              //   itemCount: snapshot.data!.docs.length,
              //   itemBuilder: (ctx, index) => Container(
              //     margin:
              //     EdgeInsets.symmetric(horizontal: 1, vertical: 10),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: Colors.grey.shade200),
              //     child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: Image.network(
              //             snapshot.data!.docs[index]
              //                 .data()["imageUrl"]
              //                 .toString(),
              //             fit: BoxFit.fill)),
              //   ),
              // );
            },
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').get(),
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
