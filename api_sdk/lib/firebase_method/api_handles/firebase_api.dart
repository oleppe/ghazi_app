import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  final Firestore _db = Firestore.instance;

  FirebaseApi() {}

  Future<QuerySnapshot> getDataCollection(String path) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.getDocuments();
  }

  Future<QuerySnapshot> getMainNewsCollection(String path) {
    return _db
        .collection(path)
        .where('category', isEqualTo: "yFIjAzWnl38hcy3BxnGV")
        .orderBy('created_at', descending: true)
        .limit(10)
        .getDocuments();
  }

  Future<QuerySnapshot> getProductCollection(
      CollectionReference ref, DocumentSnapshot last, String categoryId) {
    if (last == null)
      try {
        return ref
            .where('category', isEqualTo: categoryId)
            .orderBy('created_at', descending: true)
            .limit(3)
            .getDocuments();
      } catch (e) {
        print(e.toString());
        return null;
      }

    return ref
        .where('category', isEqualTo: categoryId)
        .orderBy('created_at', descending: true)
        .startAfterDocument(last)
        .limit(3)
        .getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection(String path) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String path, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.document(id).get();
  }

  Future<void> removeDocument(String path, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(String path, Map data) {
    CollectionReference ref;
    ref = _db.collection(path);
    return ref.add(data);
  }

  Future<void> updateDocument(String path, Map data, String id) {
    CollectionReference ref;

    ref = _db.collection(path);
    return ref.document(id).updateData(data);
  }
}
