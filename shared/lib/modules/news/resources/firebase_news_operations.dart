import 'package:api_sdk/firebase_method/api_handles/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/category/model/category.dart';
import 'package:shared/modules/news/model/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNewsOperations extends ChangeNotifier {
  FirebaseApi _api = locator<FirebaseApi>();

  List<News> news;
  List<News> bitNews;
  DocumentSnapshot lastDoc;
  DocumentSnapshot bitcoinDoc;
  CollectionReference ref = Firestore.instance
      .collection('products')
      .where('category', isEqualTo: 'JmBGL48PzABcjDnm7g2m')
      .reference();
  Future<List<News>> fetchNews(String categoryId) async {
    var result = await _api.getMainNewsCollection('products');

    return result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
  }

  Future<List<News>> fetchBitcoinNews(String categoryId) async {
    var result = await _api.getProductCollection(ref, bitcoinDoc, categoryId);
    if (result.documents.length == 0)
      bitcoinDoc = null;
    else
      bitcoinDoc = result.documents.last;
    bitNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return bitNews;
  }

  Stream<dynamic> fetchBookStoresAsStream() {
    return _api.streamDataCollection('products');
  }

  Future<Category> getBookStoreById(String id) async {
    var doc = await _api.getDocumentById('products', id);
    return Category.fromMap(doc.data, doc.documentID);
  }

  Future removeBookStore(String id) async {
    await _api.removeDocument('products', id);
    notifyListeners();
    return;
  }

  Future updateBookStore(Category data, String id) async {
    await _api.updateDocument('products', data.toJson(), id);
    notifyListeners();
    return;
  }

  Future addBookStore(Category data) async {
    // ignore: unused_local_variable
    var result = await _api.addDocument('products', data.toJson());
    notifyListeners();
    return;
  }
}
