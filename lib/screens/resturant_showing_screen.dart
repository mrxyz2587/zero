import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/image_vieweing.dart';

class RestuarantShowingScreen extends StatefulWidget {
  const RestuarantShowingScreen({Key? key}) : super(key: key);

  @override
  State<RestuarantShowingScreen> createState() =>
      _RestuarantShowingScreenState();
}

class _RestuarantShowingScreenState extends State<RestuarantShowingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Text(
            'Nearby Restaurants',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto'),
          ),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 22,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder(
            stream: _firestore.collection('restuarants').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 5.5,
                ));
              }
              if (!snapshot.hasData) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewing(
                                      docId: snap['restaurantId'],
                                    )));
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(snap['restaurantimage'],
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Center(
                                child: Text(
                                  snap['restaurantname'].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}
