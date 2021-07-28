import 'package:cloud_firestore/cloud_firestore.dart';

class MissionData {
  final String mid;
  final String picUrl;
  final String desc;
  final String raised;
  final String supporters;
  final String title;
  final Timestamp timeStamp;

  MissionData(
      {this.mid,
      this.picUrl,
      this.desc,
      this.raised,
      this.supporters,
      this.title,
      this.timeStamp});

  factory MissionData.fromSnapShot(DocumentSnapshot snapshot) {
    return MissionData(
      mid: snapshot.data["id"],
      picUrl: snapshot.data["picUrl"],
      desc: snapshot.data["desc"],
      raised: snapshot.data["raised"],
      supporters: snapshot.data["supporters"],
      title: snapshot.data["title"],
      timeStamp: snapshot.data["timeStamp"],
    );
  }
}
