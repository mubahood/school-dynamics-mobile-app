import UIKit
import Flutter
import OneSignalFramework

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(.LL_VERBOSE)

    // OneSignal initialization
    OneSignal.initialize("c11278da-0a50-41a7-a5c9-55cec96d8540", withLaunchOptions: launchOptions)

    // requestPermission will show the native iOS notification permission prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission({ accepted in
        print("User accepted notifications: \(accepted)")
    }, fallbackToSettings: true)

    // Login your customer with externalId
    // OneSignal.login("EXTERNAL_ID")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
