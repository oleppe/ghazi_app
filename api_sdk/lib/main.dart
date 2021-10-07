import 'package:api_sdk/api_constants.dart';
import 'package:api_sdk/rest/rest_api_handler_data.dart';

class ApiSdk {
  static loginWithEmailAndPassword(dynamic body) async {
    final response = await RestApiHandlerData.postData(
        '${apiConstants["auth"]}/login', body);
    return response;
  }

  static signUpWithEmailAndPassword(dynamic body) async {
    final response = await RestApiHandlerData.postData(
        '${apiConstants["auth"]}/register', body);
    return response;
  }

  static getUserData(int id) async {
    final response =
        await RestApiHandlerData.getData('${apiConstants["auth"]}/users/$id');
    return response;
  }

  static getMarketData(String link) async {
    try {
      final response =
          await RestApiHandlerData.getData('${apiConstants["market"]}$link');
      return response["data"];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static getExchangeRate() async {
    try {
      final response = await RestApiHandlerData.getData(
          'https://api.coincap.io/v2/rates?limit=73');
      return response["data"];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static generateShortLink(String url) async {
    try {
      final response = await RestApiHandlerData.getData(
          'http://ghazinews.com/yourls-api.php?username=admin&password=5352064000&action=shorturl&format=json&url=$url');
      return response["shorturl"];
    } catch (e) {
      print(e);
      return null;
    }
  }
}
