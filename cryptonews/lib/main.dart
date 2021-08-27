// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/src/app.dart';
import 'package:cryptonews/src/utils/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/main.dart';

void main() {
  setupLocator();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: App(),
    ),
  );
}
