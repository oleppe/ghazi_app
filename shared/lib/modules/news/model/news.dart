import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  News({
    this.id = '',
    this.name = '',
    this.subText = '',
    this.description = '',
    this.imagePath = '',
    this.views = 0,
    this.like = 0,
    this.createdAt = null,
  });
  String id;
  String name;
  String subText;
  String description;
  String imagePath;
  int views;
  int like;
  DateTime createdAt;
  News.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        subText = snapshot['subText'] ?? '',
        description = snapshot['description'] ?? '',
        imagePath =
            snapshot['imagePath'] == 0 ? '' : snapshot['imagePath'] ?? '',
        views = snapshot['views'] ?? 15,
        like = snapshot['like'] ?? 3,
        createdAt = new DateTime.fromMicrosecondsSinceEpoch(
            (snapshot['created_at'] as Timestamp).microsecondsSinceEpoch);

  toJson() {
    return {
      "name": name,
    };
  }
//DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
