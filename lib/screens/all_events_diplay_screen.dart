import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zero_fin/screens/event_description_screen.dart';

class AllEventsDisplayScreen extends StatefulWidget {
  String category;
  String title;

  AllEventsDisplayScreen(
      {Key? key, required this.category, required this.title})
      : super(key: key);
  @override
  State<AllEventsDisplayScreen> createState() => _AllEventsDisplayScreenState();
}

class _AllEventsDisplayScreenState extends State<AllEventsDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.chevronLeft, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.solidBell,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('events')
              .where('category', isEqualTo: widget.category)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.grey.shade300,
                strokeWidth: 1.5,
              ));
            }

            return GridView.builder(
              controller: ScrollController(keepScrollOffset: true),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (snapshot.data! as dynamic).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.44),
              itemBuilder: (context, index) {
                DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EventDescriptionScreen(id: snap['id'])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  snap['eventposterimg'],
                                  height: 250,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (snap['mode'] == 'online')
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: Container(
                                    height: 24,
                                    width: 60,
                                    child: Center(
                                      child: Text('ONLINE',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        0xFF040606,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFdaf6fd),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 36,
                            width: 179,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(snap['eventDate'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 1,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.5),
                        Text(
                          snap['evetitle'],
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontFamily: 'Roboto'),
                        ),
                        SizedBox(height: 7),
                        Text(
                          snap['evedescc'],
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Rs ${snap['price']}',
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
