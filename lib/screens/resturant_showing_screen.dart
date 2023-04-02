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
  String selectedLocation = 'Select Location';
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 23,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 160),
                                height: 4,
                                width: 10,
                                constraints: BoxConstraints(maxWidth: 50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Available Locations',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              SizedBox(height: 20),
                              ListTile(
                                splashColor: Color(0xD2A9D1FF),
                                onTap: () {
                                  setState(() {
                                    selectedLocation =
                                        "Quantum University, Roorkee";
                                  });
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  'Quantum University, Roorkee',
                                  style: TextStyle(
                                      color: Color(0xFFA3A3A3),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                    child: Center(
                      child: Text(
                        selectedLocation,
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                            fontSize: 18),
                      ),
                    ),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border:
                            Border.all(color: Color(0xFF262626), width: 1))),
              ),
            ),
            StreamBuilder(
              stream: _firestore
                  .collection('restuarants')
                  .where('restuarantlocation', isEqualTo: selectedLocation)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 0.5),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data! as dynamic).docs[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8, right: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageViewing(
                                              docId: snap['restaurantId'],
                                            )));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  snap['restaurantimage'],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
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
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ));
  }
}
