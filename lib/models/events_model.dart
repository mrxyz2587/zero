import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsModel {
  final String evetitle;
  final String evedescc;
  final String imageUrl;
  final String eventOrCOurseLink;
  DateTime eventPosted;
  final String joiningUrl;
  final String eventCategory;
  final String eventId;
  final String eventCompany;

  EventsModel({
    required this.imageUrl,
    required this.evedescc,
    required this.eventOrCOurseLink,
    required this.eventPosted,
    required this.evetitle,
    required this.joiningUrl,
    required this.eventCategory,
    required this.eventCompany,
    required this.eventId,
  });

  static EventsModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return EventsModel(
        imageUrl: snapshot["imageurl"],
        evedescc: snapshot["eventDescription"],
        eventOrCOurseLink: snapshot["eventOrCourseLink"],
        eventPosted: snapshot["eventPosttingDate"],
        evetitle: snapshot["eventTitle"],
        joiningUrl: snapshot["joiningUrl"],
        eventCategory: snapshot["eventCategory"],
        eventCompany: snapshot["eventCompany"],
        eventId: snapshot["eventId"]);
  }

  Map<String, dynamic> toJson() => {
        "imageurl": imageUrl,
        "eventDescription": evedescc,
        "eventOrCourseLink": evedescc,
        "eventPosttingDate": evedescc,
        "eventTitle": evedescc,
        "joiningUrl": evedescc,
        "eventCategory": evedescc,
        "eventCompany": evedescc,
        "eventId": evedescc,
      };
}
