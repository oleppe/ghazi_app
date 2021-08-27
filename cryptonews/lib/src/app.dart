import 'package:cryptonews/src/config/theme_data.dart';
import 'package:cryptonews/src/routes/index.dart';
import 'package:cryptonews/src/utils/app_state_notifier.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/local_database.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/category/resources/firebase_crud_operations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/news/resources/firebase_news_operations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/contacts/firebase_crud_contact.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  initState() {
    super.initState();
    this.initDynamicLinks();
    // FirebaseMessaging().configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     //_showItemDialog(message);
    //   },
    //   onBackgroundMessage: myBackgroundMessageHandler,
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     //_navigateToItemDetail(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     //_navigateToItemDetail(message);
    //   },
    // );
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;
      print("deeplink found");
      if (deepLink != null) {
        print(deepLink);
        //Get.to(() => LogInPage(title: 'firebase_dynamic_link  navigation'));
        navigatorKey.currentState!
            .pushNamed('/news', arguments: deepLink.queryParameters['id']);
      }
    }, onError: (OnLinkErrorException e) async {
      print("deeplink error");
      print(e.message);
    });
  }

  // Future<dynamic> myBackgroundMessageHandler(
  //     Map<String, dynamic> message) async {
  //   if (message.containsKey('data')) {
  //     // Handle data message
  //     final dynamic data = message['data'];
  //   }

  //   if (message.containsKey('notification')) {
  //     // Handle notification message
  //     final dynamic notification = message['notification'];
  //   }

  //   // Or do other work.
  // }

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => locator<FirebaseCRUDoperations>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<FirebaseNewsOperations>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<FirebaseCRUDcontact>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<HomeModel>(),
          ),
        ],
        child: MaterialApp(
          title: 'News!',
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [
            const Locale('ar', 'AR'),
          ],
          locale: const Locale('ar', 'AR'),
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          onGenerateRoute: routes,
          navigatorKey: navigatorKey,
        ),
      );
    });
  }
}
