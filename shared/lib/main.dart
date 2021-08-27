export 'package:shared/modules/authentication/auth.dart';
export 'package:shared/modules/authentication/bloc/bloc_controller.dart';
import 'package:api_sdk/firebase_method/api_handles/firebase_api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/local_database.dart';
import 'package:shared/modules/news/resources/firebase_news_operations.dart';
import 'modules/category/resources/firebase_crud_operations.dart';
import 'modules/contacts/firebase_crud_contact.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseApi());
  locator.registerLazySingleton(() => FirebaseCRUDoperations());
  locator.registerLazySingleton(() => FirebaseCRUDcontact());
  locator.registerLazySingleton(() => FirebaseNewsOperations());
  locator.registerLazySingleton(() => HomeModel());
}
