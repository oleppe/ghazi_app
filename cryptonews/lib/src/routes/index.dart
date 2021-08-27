// routes for the app
import 'package:cryptonews/src/screens/AboutScreen.dart';
import 'package:cryptonews/src/screens/home/index.dart';
import 'package:cryptonews/src/screens/news/news_page_ex.dart';
import 'package:cryptonews/src/screens/onboarding/authentication_screen.dart';
import 'package:cryptonews/src/splash_screen.dart';
import 'package:flutter/material.dart';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => SplashScreen());
    case '/home':
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case '/news':
      {
        String id = settings.arguments as String;

        return MaterialPageRoute(builder: (_) => NewsPageEx(id: id));
        //return MaterialPageRoute(builder: (_) => AboutScreen());
      }
    case '/about':
      return MaterialPageRoute(builder: (_) => AboutScreen());
    case '/auth':
      return MaterialPageRoute(builder: (_) => AuthenticationScreen());
    default:
      return MaterialPageRoute(builder: (_) => SplashScreen());
  }
}
