import 'package:api_sdk/firebase_method/api_handles/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/contacts/model/Contact.dart';

class FirebaseCRUDcontact {
  FirebaseApi _api = locator<FirebaseApi>();

  Future addContact(Contact data) async {
    // ignore: unused_local_variable
    var result = await _api.addDocument('contact', data.toJson());
    return;
  }
}
