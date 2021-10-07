import 'dart:io';

import 'package:cryptonews/src/config/color_constants.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';
import 'package:shared/modules/app/bloc/app_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/authentication/bloc/authentication/authentication_state.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/contacts/model/Contact.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/contacts/firebase_crud_contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.nearlyWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AllImages().logo),
              ),
            ),
            onTap: () async {
              // String url = "https://platypuslabs.llc";
              // if (await canLaunch(url)) {
              //   await launch(url);
              // }
            }),
        ListTile(
            leading: Icon(
              Icons.apps,
              size: 35,
            ),
            title: Text("من نحن؟", style: TextStyle(fontSize: 16.0)),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            }),
        ListTile(
            leading: Icon(
              Icons.mail,
              size: 35,
            ),
            title: Text("تواصل معنا", style: TextStyle(fontSize: 16.0)),
            onTap: () async {
              // String url = Uri.encodeFull(
              //     "mailto:ap.sy.uk@gmail.com?subject=GetPass&body=Contact Reason: ");
              // if (await canLaunch(url)) {
              //   await launch(url);
              // }
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Contact contact = Contact();
                    final contactProvider =
                        RepositoryProvider.of<FirebaseCRUDcontact>(context);
                    return AlertDialog(
                      scrollable: true,
                      title: Text('تواصل معنا'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "إذا كان لديك أي استفسار أو اقتراح فلا تتردد بمراسلتنا",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              TextFormField(
                                onChanged: (name) {
                                  contact.name = name;
                                },
                                decoration: InputDecoration(
                                  labelText: 'الأسم',
                                  icon: Icon(Icons.account_box),
                                ),
                              ),
                              TextFormField(
                                onChanged: (email) {
                                  contact.email = email;
                                },
                                decoration: InputDecoration(
                                  labelText: 'البريد',
                                  icon: Icon(Icons.email),
                                ),
                              ),
                              TextFormField(
                                onChanged: (message) {
                                  contact.message = message;
                                },
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: 'الرسالة',
                                  icon: Icon(Icons.message),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        // ignore: deprecated_member_use
                        RaisedButton(
                            child: Text("أرسل"),
                            onPressed: () {
                              contactProvider.addContact(contact);
                              Navigator.pop(context);
                            })
                      ],
                    );
                  });
            }),
        ListTile(
            leading: Icon(
              Icons.star,
              size: 35,
            ),
            title: Text("قيم التطبيق", style: TextStyle(fontSize: 16.0)),
            onTap: () async {
              String url = Platform.isIOS
                  ? "https://itunes.apple.com/us/app/ghazi-cryptonews/id1397122793"
                  : "https://play.google.com/store/apps/details?id=com.ghazi.cryptonews";
              if (await canLaunch(url)) {
                await launch(url);
              }
            }),
        ListTile(
          leading: Icon(
            Icons.star,
            size: 35,
          ),
          title: Text("قيم التطبيق", style: TextStyle(fontSize: 16.0)),
          subtitle: Switch(
            value: BlocProvider.of<AppBloc>(context).state.isDark,
            onChanged: (value) {
              if (value == true)
                BlocProvider.of<AppBloc>(context)..add(SwitchToDarkEvent());
              else
                BlocProvider.of<AppBloc>(context)..add(SwitchToLightEvent());
            },
          ),
        )
      ]),
    );
  }
}
