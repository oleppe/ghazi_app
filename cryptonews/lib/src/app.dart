// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/config/theme_data.dart';
import 'package:cryptonews/src/routes/index.dart';
import 'package:cryptonews/src/utils/app_state_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared/local_database.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/category/resources/firebase_crud_operations.dart';
import 'package:shared/modules/news/resources/firebase_news_operations.dart';
import 'package:shared/modules/contacts/firebase_crud_contact.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //if (Firebase.apps.length == 0) await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class _AppState extends State<App> {
  @override
  initState() {
    this.initFirebase();

    super.initState();
  }

  void setupInteractedMessage() async {
    //if (Firebase.apps.length == 0) await Firebase.initializeApp();
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if ((message.data['id'] as String).isNotEmpty) {
      navigatorKey.currentState!.pushNamed(
        '/news',
        arguments: (message.data['id'] as String).trim(),
      );
    }
  }

  void firebaseMessageing() async {
    //if (Firebase.apps.length == 0) await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
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

  void initFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    this.initDynamicLinks();
    this.firebaseMessageing();
    this.setupInteractedMessage();
  }

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
