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
  List<News> altNews;
  List<News> defiNews;
  List<News> blockNews;
  List<News> nftNews;
  List<News> ethNews;
  List<News> otherNews;
  List<News> twitterNews;
  DocumentSnapshot twitterDoc;
  DocumentSnapshot lastDoc;
  DocumentSnapshot bitcoinDoc;
  DocumentSnapshot altDoc;
  DocumentSnapshot defiDoc;
  DocumentSnapshot blockchainDoc;
  DocumentSnapshot nftDoc;
  DocumentSnapshot ethDoc;
  DocumentSnapshot otherdoc;
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

  Future<List<News>> fetchBitcoinNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) bitcoinDoc = null;
    if (isFuture == true && bitcoinDoc != null) return [];
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

  Future<List<News>> fetchAltNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) altDoc = null;
    if (isFuture == true && altDoc != null) return [];
    var result = await _api.getProductCollection(ref, altDoc, categoryId);
    if (result.documents.length == 0)
      altDoc = null;
    else
      altDoc = result.documents.last;
    altNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return altNews;
  }

  Future<List<News>> fetchDefiNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) defiDoc = null;
    if (isFuture == true && defiDoc != null) return [];
    var result = await _api.getProductCollection(ref, defiDoc, categoryId);
    if (result.documents.length == 0)
      defiDoc = null;
    else
      defiDoc = result.documents.last;
    defiNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return defiNews;
  }

  Future<List<News>> fetchBlockchainNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) blockchainDoc = null;
    if (isFuture == true && blockchainDoc != null) return [];
    var result =
        await _api.getProductCollection(ref, blockchainDoc, categoryId);
    if (result.documents.length == 0)
      blockchainDoc = null;
    else
      blockchainDoc = result.documents.last;
    blockNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return blockNews;
  }

  Future<List<News>> fetchNftNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) nftDoc = null;
    if (isFuture == true && nftDoc != null) return [];
    var result = await _api.getProductCollection(ref, nftDoc, categoryId);
    if (result.documents.length == 0)
      nftDoc = null;
    else
      nftDoc = result.documents.last;
    nftNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return nftNews;
  }

  Future<List<News>> fetchEthNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) ethDoc = null;
    if (isFuture == true && ethDoc != null) return [];
    var result = await _api.getProductCollection(ref, ethDoc, categoryId);
    if (result.documents.length == 0)
      ethDoc = null;
    else
      ethDoc = result.documents.last;
    ethNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return ethNews;
  }

  Future<List<News>> fetchOtherNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) otherdoc = null;
    if (isFuture == true && otherdoc != null) return [];
    var result = await _api.getProductCollection(ref, otherdoc, categoryId);
    if (result.documents.length == 0)
      otherdoc = null;
    else
      otherdoc = result.documents.last;
    otherNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return otherNews;
  }

  Future<List<News>> fetchTwitterNews(String categoryId, bool isFuture,
      {bool refresh = false}) async {
    if (refresh == true) twitterDoc = null;
    if (isFuture == true && twitterDoc != null) return [];

    var result = await _api.getProductCollection(ref, twitterDoc, categoryId);
    if (result.documents.length == 0)
      twitterDoc = null;
    else
      twitterDoc = result.documents.last;
    twitterNews = result.documents
        .map((doc) => News.fromMap(doc.data, doc.documentID))
        .toList();
    return twitterNews;
  }

  Stream<dynamic> fetchBookStoresAsStream() {
    return _api.streamDataCollection('products');
  }

  Future<News> getNewsById(String id) async {
    var doc = await _api.getDocumentById('products', id);
    return News.fromMap(doc.data, doc.documentID);
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
