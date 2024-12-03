import UIKit
import Flutter
import AVKit
import BanubaAudioBrowserSDK
import BanubaPhotoEditorSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // Photo Editor Methods
    static let methodInitPhotoEditor = "initPhotoEditor"
    static let methodStartPhotoEditor = "startPhotoEditor"
    static let argExportedPhotoFile = "argExportedPhotoFilePath"
    
    static let errEditorNotInitialized = "ERR_SDK_NOT_INITIALIZED"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        var photoEditor: PhotoEditorModule?
        
        if let controller = window?.rootViewController as? FlutterViewController,
           let binaryMessenger = controller as? FlutterBinaryMessenger {
            
            let channel = FlutterMethodChannel(
                name: "banubaSdkChannel",
                binaryMessenger: binaryMessenger
            )

            channel.setMethodCallHandler { methodCall, result in
                let call = methodCall.method
                switch call {
                case AppDelegate.methodInitPhotoEditor:
                    guard let token = methodCall.arguments as? String else {
                        print("Missing token")
                        return
                    }
                    photoEditor = PhotoEditorModule(
                        token: token,
                        flutterResult: result
                    )

                case AppDelegate.methodStartPhotoEditor:
                    guard let arguments = methodCall.arguments as? [String: Any],
                          let imagePath = arguments["imagePath"] as? String else {
                        print("Missing or invalid arguments")
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing imagePath", details: nil))
                        return
                    }

                    if let photoEditor = photoEditor {
                        photoEditor.presentPhotoEditor(
                            fromViewController: controller,
                            imagePath: imagePath,
                            flutterResult: result
                        )
                    } else {
                        print("The Photo Editor is not initialized")
                        result(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
                    }
                default:
                    print("Flutter method is not implemented on platform.")
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
