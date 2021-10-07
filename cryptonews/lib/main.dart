// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:cryptonews/simple_bloc_delegate.dart';
import 'package:cryptonews/src/app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/modules/app/bloc/model/app_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared/main.dart';
import 'package:shared/modules/app/bloc/app_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //Bloc.observer = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
  runApp(App());
}
