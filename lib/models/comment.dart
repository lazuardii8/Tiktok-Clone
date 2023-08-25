import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Comment {
  String username;
  String comment;
  final datePublished;
  List likes;
  String profilePhoto;
  String uid;
  String id;
  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "comment": comment,
        "datePublished": datePublished,
        "likes": likes,
        "profilePhoto": profilePhoto,
        "uid": uid,
        "id": id,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Comment(
      username: snapShot["username"],
      comment: snapShot["comment"],
      datePublished: snapShot["datePublished"],
      likes: snapShot["likes"],
      profilePhoto: snapShot["profilePhoto"],
      uid: snapShot["uid"],
      id: snapShot["id"],
    );
  }
}
