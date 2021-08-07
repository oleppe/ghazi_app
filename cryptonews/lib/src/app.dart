import 'package:cryptonews/src/config/theme_data.dart';
import 'package:cryptonews/src/routes/index.dart';
import 'package:cryptonews/src/utils/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/modules/category/resources/firebase_crud_operations.dart';
import 'package:shared/modules/news/resources/firebase_news_operations.dart';

class App extends StatelessWidget {
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
        ),
      );
    });
  }
}
