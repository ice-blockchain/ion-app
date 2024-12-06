import Flutter
import UIKit

public class IonScreenshotDetectorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel(
            name: "io.ion.app/screenshots",
            binaryMessenger: registrar.messenger()
        )
        let instance = IonScreenshotDetectorPlugin()
        channel.setStreamHandler(instance)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScreenshotCaptured),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        eventSink = nil
        return nil
    }
    
    @objc private func onScreenshotCaptured() {
        eventSink?("")
    }
}
