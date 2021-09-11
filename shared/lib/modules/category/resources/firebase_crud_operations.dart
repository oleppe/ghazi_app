import 'package:api_sdk/firebase_method/api_handles/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/category/model/category.dart';

class FirebaseCRUDoperations extends ChangeNotifier {
  FirebaseApi _api = locator<FirebaseApi>();

  List<Category> bookStore;

  Future<List<Category>> fetchBookStores() async {
    var result = await _api.getDataCollection('categories');
    bookStore = result.docs
        .map((doc) => Category.fromMap(doc.data(), doc.id))
        .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    print(bookStore);

    return bookStore;
  }

  Stream<dynamic> fetchBookStoresAsStream() {
    return _api.streamDataCollection('categories');
  }

  Future<Category> getBookStoreById(String id) async {
    var doc = await _api.getDocumentById('categories', id);
    return Category.fromMap(doc.data(), doc.id);
  }

  Future removeBookStore(String id) async {
    await _api.removeDocument('categories', id);
    notifyListeners();
    return;
  }

  Future updateBookStore(Category data, String id) async {
    await _api.updateDocument('categories', data.toJson(), id);
    notifyListeners();
    return;
  }

  Future addBookStore(Category data) async {
    // ignore: unused_local_variable
    var result = await _api.addDocument('categories', data.toJson());
    notifyListeners();
    return;
  }
}
