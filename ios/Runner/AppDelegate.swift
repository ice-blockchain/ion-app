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
    
    // Video Editor Methods
    static let methodInitVideoEditor = "initVideoEditor"
    static let methodStartVideoEditorTrimmer = "startVideoEditorTrimmer"
    static let argExportedVideoFile = "argExportedVideoFilePath"
    static let argExportedVideoCoverPreviewPath = "argExportedVideoCoverPreviewPath"
    
    static let errEditorNotInitialized = "ERR_SDK_NOT_INITIALIZED"
    
    private let configEnableCustomAudioBrowser = false
    
    lazy var audioBrowserFlutterEngine = FlutterEngine(name: "audioBrowserEngine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        var photoEditor: PhotoEditorModule?
        let videoEditor = VideoEditorModule()
        
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
                case AppDelegate.methodInitVideoEditor:
                                    let token = methodCall.arguments as? String
                                    videoEditor.initVideoEditor(
                                        token: token,
                                        flutterResult: result
                                    )
                case AppDelegate.methodStartVideoEditorTrimmer:
                                    let trimmerVideoFilePath = methodCall.arguments as? String
                                    
                                    if let videoFilePath = trimmerVideoFilePath {
                                        videoEditor.openVideoEditorTrimmer(
                                            fromViewController: controller,
                                            videoURL: URL(fileURLWithPath: videoFilePath),
                                            flutterResult: result
                                        )
                                    } else {
                                        print("Cannot start video editor in trimmer mode: missing or invalid video!")
                                        result(FlutterError(code: "ERR_START_TRIMMER_MISSING_VIDEO", message: "", details: nil))
                                    }
                default:
                    print("Flutter method is not implemented on platform.")
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        
        audioBrowserFlutterEngine.run(withEntrypoint: "audioBrowser")
        GeneratedPluginRegistrant.register(with: audioBrowserFlutterEngine)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Custom View Factory is used to provide you custom UI/UX experience in Video Editor SDK
        // i.e. custom audio browser
        func provideCustomViewFactory() -> FlutterCustomViewFactory? {
            let factory: FlutterCustomViewFactory?
            
            if configEnableCustomAudioBrowser {
                factory = FlutterCustomViewFactory()
            } else {
                // Set your Mubert Api key here
                let mubertApiLicense = ""
                let mubertApiKey = ""
                AudioBrowserConfig.shared.musicSource = .allSources
                BanubaAudioBrowser.setMubertKeys(
                    license: mubertApiLicense,
                    token: mubertApiKey
                )
                factory = nil
            }
            
            return factory
        }
}
