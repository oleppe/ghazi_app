import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/modules/news/model/news.dart';

class FirebaseApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseApi() {}

  Future<QuerySnapshot> getDataCollection(String path) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.get();
  }

  Future<QuerySnapshot> getMainNewsCollection(String path) {
    return _db
        .collection(path)
        .where('category', isEqualTo: "yFIjAzWnl38hcy3BxnGV")
        .orderBy('created_at', descending: true)
        .limit(10)
        .get();
  }

  Future<QuerySnapshot> getProductCollection(
      CollectionReference ref, News last, String categoryId) {
    if (last == null)
      try {
        return ref
            .where('category', isEqualTo: categoryId)
            .orderBy('created_at', descending: true)
            .limit(3)
            .get();
      } catch (e) {
        print(e.toString());
        return null;
      }

    return ref
        .where('category', isEqualTo: categoryId)
        .orderBy('created_at', descending: true)
        .startAfter([last.timestamp])
        .limit(3)
        .get();
  }

  Stream<QuerySnapshot> streamDataCollection(String path) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String path, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String path, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(String path, Map data) {
    CollectionReference ref;
    ref = _db.collection(path);
    return ref.add(data);
  }

  Future<void> updateDocument(String path, Map data, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.doc(id).update(data);
  }
}
