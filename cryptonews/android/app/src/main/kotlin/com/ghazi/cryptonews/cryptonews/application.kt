package com.ghazi.cryptonews

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;


class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
    super.onCreate()
     FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);

  }

  override fun registerWith(registry: PluginRegistry?) {
        registry?.registrarFor("io.flutter.plugins.firebase.messaging.FirebaseMessagingPlugin");
  }
}