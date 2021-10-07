import 'dart:collection';

import 'package:api_sdk/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:local_database/local_database.dart';

class HomeModel extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [
        firstTime,
        exchangeRate,
        settings,
        savedCoins,
        sortedKeys,
        symbol,
        conversionMap
      ];

  Map<String, dynamic> _settings = {};
  num _exchangeRate = 0;
  bool _firstTime = true;
  List<String> _savedCoins = [];

  bool get firstTime => _firstTime;
  num get exchangeRate => _exchangeRate;
  Map<String, dynamic> get settings => _settings;
  List<String> get savedCoins => _savedCoins;
  List<String> _sortedKeys = [];
  List<String> get sortedKeys => _sortedKeys;
  set sortedKeys(List<String> val) {
    _sortedKeys = val;
  }

  String _symbol = 'USD';
  String get symbol => _symbol;
  Map<String, dynamic> _conversionMap = {};

  Map<String, dynamic> get conversionMap => _conversionMap;
  // addItem(Inventory inventory) async {
  //   var box = await Hive.openBox<Inventory>(_inventoryBox);

  //   box.add(inventory);

  //   print('added');

  //   notifyListeners();
  // }
  removeSortedKeys(value) async {
    _sortedKeys.remove(value);
  }

  getSavedCoin() async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);
    _savedCoins = (await _userData["saved"])?.cast<String>() ?? [];
  }

  setSortedKeys() async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);
    _savedCoins = (await _userData["saved"])?.cast<String>() ?? [];
  }

  getSettings() async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);

    _settings = await _userData["settings"];

    if (_settings == null || _settings.length == 0) {
      _settings = {"disableGraphs": false, "currency": "USD"};
      _userData["settings"] = _settings;
    }
    _firstTime = await _userData["firstTime"];
    if (_firstTime == null) _firstTime = true;
    _savedCoins = (await _userData["saved"])?.cast<String>() ?? [];
    var exchangeData = (await ApiSdk.getExchangeRate());
    if (exchangeData == null) {
      _exchangeRate = 1.0;
      return;
    }
    _conversionMap = HashMap();
    for (dynamic data in exchangeData) {
      String symbol = data["symbol"];
      if (supportedCurrencies.contains(symbol)) {
        _conversionMap[symbol] = {
          "symbol": data["currencySymbol"] ?? "",
          "rate": 1 / num.parse(data["rateUsd"])
        };
      }
    }
    if (_settings != null) {
      var conversionData = _conversionMap[_settings["currency"] ?? "USD"];
      _exchangeRate = conversionData["rate"];
    }
  }

  setFirstTime() async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);
    _userData["firstTime"] = false;
  }

  updateSettings(dynamic inventory) async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);

    _settings["disableGraphs"] = inventory;
    _userData["settings/disableGraphs"] = _settings["disableGraphs"];
    var conversionData = _conversionMap[_settings["currency"]];
    _exchangeRate = conversionData["rate"];
    _symbol = conversionData["symbol"];
  }

  updateSavedCoin(data) async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);
    _userData["saved"] = data;
    _savedCoins = data;
  }

  updateCurrency(dynamic inventory) async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);

    _settings["currency"] = inventory;
    _userData["settings/currency"] = _settings["currency"];

    var conversionData = _conversionMap[_settings["currency"]];
    _exchangeRate = conversionData["rate"];
    _symbol = conversionData["symbol"];
  }

  addSavedCoin(dynamic coin) async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);

    _savedCoins.add(coin);
    _userData["saved"] = _savedCoins;
  }

  deleteSavedCoin(dynamic coin) async {
    Database _userData = new Database(
        (await pathProvider.getApplicationDocumentsDirectory()).path);

    _savedCoins.remove(coin);
    _userData["saved"] = _savedCoins;
  }

  LinkedHashSet<String> get supportedCurrencies => LinkedHashSet.from([
        "USD",
        "AUD",
        "BGN",
        "BRL",
        "CAD",
        "CHF",
        "CNY",
        "CZK",
        "DKK",
        "EUR",
        "GBP",
        "HKD",
        "HRK",
        "HUF",
        "IDR",
        "ILS",
        "INR",
        "ISK",
        "JPY",
        "KRW",
        "MXN",
        "MYR",
        "NOK",
        "NZD",
        "PHP",
        "PLN",
        "RON",
        "RUB",
        "SEK",
        "SGD",
        "THB",
        "TRY",
        "ZAR"
      ]);
}
