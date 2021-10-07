// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/config/theme_data.dart';
import 'package:cryptonews/src/routes/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/modules/app/bloc/app_bloc.dart';
import 'package:shared/modules/app/bloc/model/app_state_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_database/local_database.dart';
import 'package:provider/provider.dart';
import 'package:shared/local_database.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/category/resources/firebase_crud_operations.dart';
import 'package:shared/modules/news/resources/firebase_news_operations.dart';
import 'package:shared/modules/contacts/firebase_crud_contact.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    if (message.data.length > 0) if ((message.data['id'] as String)
        .isNotEmpty) {
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

    messaging.subscribeToTopic('newsNotification');
    messaging.subscribeToTopic('analysisNotification');

    var token = messaging.getToken().then((value) {
      saveToken(value!);
    });
    messaging.onTokenRefresh.listen((newToken) {
      saveToken(newToken);
    });
    print('User granted permission: ${settings.authorizationStatus}');
//f4nvYFsYS9uHEqiBErIUIo:APA91bHcdCJttRyXxasKCFZrIMZgFvK_7GUoeKeL4pQ2bzItHuPApdJ-Ovuj6X5u7NDJGoOfdOP92uTsE8vNT-GqeEZ5H7B3b3KZWXs4AM8on8GNH55WSfJws0rSQ2bpU_kUgCRjEq0_
//fzYQ3OfkRY6Eb9QBn97v4l:APA91bEnw_PdMia0cBZWyVR9rKvw3BsZHbqgh5RE8qfRbGpR1BIMQ5d3G8jHu1tdp5gy3PZAuJtXhf-oE7EwQIXS3Wyt7baa8jld85m5B7IePuoZolIQQcCwRtfjQLXiAnFPeqZvqA00
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void saveToken(String token) {
    //var user = Provider.of<FirebaseNewsOperations>(context, listen: false);
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

  Future<void> initFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    this.initDynamicLinks();
    this.firebaseMessageing();
    this.setupInteractedMessage();
    // Database _userData = new Database(
    //     (await pathProvider.getApplicationDocumentsDirectory()).path);
    // first = await _userData['firstTime'];
  }

  late bool first;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseCRUDoperations>(
          create: (_) => locator<FirebaseCRUDoperations>(),
        ),
        RepositoryProvider<FirebaseNewsOperations>(
          create: (_) => locator<FirebaseNewsOperations>(),
        ),
        RepositoryProvider<FirebaseCRUDcontact>(
          create: (_) => locator<FirebaseCRUDcontact>(),
        ),
        RepositoryProvider<HomeModel>(
          create: (_) => locator<HomeModel>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) {
              return AppBloc();
            },
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc();
            },
          ),
        ],
        child: BlocConsumer<AppBloc, AppState>(listener: (context, state) {
          // do stuff here based on BlocA's state
        }, builder: (context, state) {
          return MaterialApp(
            title: 'News!',
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: [
              const Locale('ar', 'AR'),
            ],
            locale: const Locale('ar', 'AR'),
            debugShowCheckedModeBanner: false,
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            onGenerateRoute: routes,
            navigatorKey: navigatorKey,
            initialRoute: state.isFirstLaunch ? "/" : "/home",
          );
        }),
      ),
    );
  }
}
