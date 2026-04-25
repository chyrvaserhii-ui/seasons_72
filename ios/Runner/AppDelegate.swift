import Flutter
import UIKit

/// App Group identifier shared with the SeasonsWidget extension.
/// Must match `WidgetService.appGroupId` in Dart and the entitlements
/// on both the Runner and SeasonsWidget targets.
private let kAppGroupId = "group.chyrva.seasons72"

/// MethodChannel name used by Dart to copy engraving PNGs into the
/// shared App Group container so the widget can render them.
private let kEngravingChannelName = "seasons72/widget/engraving"

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Retained to prevent deallocation — FlutterMethodChannel does not
  /// strong-reference its handler.
  private var engravingChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Register a method channel so Dart can push image bytes into the
    // shared App Group container. See `widget_service.dart`.
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "EngravingChannel")
    if let messenger = registrar?.messenger() {
      let channel = FlutterMethodChannel(
        name: kEngravingChannelName,
        binaryMessenger: messenger
      )
      channel.setMethodCallHandler { call, result in
        Self.handleEngravingCall(call, result: result)
      }
      self.engravingChannel = channel
    }
  }

  // MARK: - Engraving channel handler

  private static func handleEngravingCall(
    _ call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "copy":
      // Copy bytes → file in App Group container
      guard let args = call.arguments as? [String: Any],
            let key = args["key"] as? String,
            let data = args["bytes"] as? FlutterStandardTypedData else {
        result(FlutterError(code: "bad-args", message: "Expected key + bytes", details: nil))
        return
      }
      guard let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: kAppGroupId
      ) else {
        result(FlutterError(code: "no-group", message: "App Group container unavailable", details: nil))
        return
      }
      let fileURL = container.appendingPathComponent("\(key).png")
      do {
        try data.data.write(to: fileURL, options: .atomic)
        result(nil)
      } catch {
        result(FlutterError(code: "io", message: error.localizedDescription, details: nil))
      }

    case "clear":
      // Remove all engraving files (diagnostic / reset path)
      if let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: kAppGroupId
      ) {
        let fm = FileManager.default
        if let items = try? fm.contentsOfDirectory(atPath: container.path) {
          for name in items where name.hasPrefix("engraving_") {
            try? fm.removeItem(atPath: container.appendingPathComponent(name).path)
          }
        }
      }
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
