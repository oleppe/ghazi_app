import 'package:api_sdk/firebase_method/api_handles/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/category/model/category.dart';
import 'package:shared/modules/news/model/news.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNewsOperations {
  FirebaseApi _api = locator<FirebaseApi>();

  CollectionReference ref = FirebaseFirestore.instance.collection('products');
  Future<List<News>> fetchNews(String categoryId) async {
    var result = await _api.getMainNewsCollection('products');

    return result.docs.map((doc) => News.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<News>> fetchBitcoinNews(
      String categoryId, News lastDoc, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) lastDoc = null;
    if (isFuture == true && lastDoc != null) return [];
    var result = await _api.getProductCollection(ref, lastDoc, categoryId);
    if (result.docs.length == 0) lastDoc = null;
    return result.docs.map((doc) => News.fromMap(doc.data(), doc.id)).toList();
  }

  Stream<dynamic> fetchBookStoresAsStream() {
    return _api.streamDataCollection('products');
  }

  Future<News> getNewsById(String id) async {
    var doc = await _api.getDocumentById('products', id);
    return doc.data() != null ? News.fromMap(doc.data(), doc.id) : null;
  }

  Future removeBookStore(String id) async {
    await _api.removeDocument('products', id);
    return;
  }

  Future updateBookStore(Category data, String id) async {
    await _api.updateDocument('products', data.toJson(), id);
    return;
  }

  Future addBookStore(Category data) async {
    // ignore: unused_local_variable
    var result = await _api.addDocument('products', data.toJson());
    return;
  }
}
