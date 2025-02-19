// SPDX-License-Identifier: ice License 1.0

import UIKit
import Flutter
import AVKit
import BanubaVideoEditorSDK
import BanubaPhotoEditorSDK
import BanubaAudioBrowserSDK

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var photoEditor: PhotoEditorModule?

    static let methodInitPhotoEditor = "initPhotoEditor"
    static let methodStartPhotoEditor = "startPhotoEditor"
    static let argExportedPhotoFile = "argExportedPhotoFilePath"

    static let methodInitVideoEditor = "initVideoEditor"
    static let methodStartVideoEditorTrimmer = "startVideoEditorTrimmer"
    static let methodStartVideoEditor = "startVideoEditor"
    static let argExportedVideoFile = "argExportedVideoFilePath"
    static let argExportedVideoCoverPreviewPath = "argExportedVideoCoverPreviewPath"

    static let errEditorNotInitialized = "ERR_SDK_NOT_INITIALIZED"

    private let configEnableCustomAudioBrowser = false
    lazy var audioBrowserFlutterEngine = FlutterEngine(name: "audioBrowserEngine")

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
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
                    guard let token = methodCall.arguments as? String else { return }
                    
                    self.photoEditor = PhotoEditorModule(token: token, flutterResult: result)

                case AppDelegate.methodStartPhotoEditor:
                    guard let args = methodCall.arguments as? [String: Any],
                          let imagePath = args["imagePath"] as? String
                    else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing imagePath", details: nil))
                        return
                    }
                    
                    if let photoEditor = self.photoEditor {
                        photoEditor.presentPhotoEditor(
                            fromViewController: controller,
                            imagePath: imagePath,
                            flutterResult: result
                        )
                    } else {
                        result(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
                    }

                case AppDelegate.methodInitVideoEditor:
                    let token = methodCall.arguments as? String
                    videoEditor.initVideoEditor(token: token, flutterResult: result)

                case AppDelegate.methodStartVideoEditorTrimmer:
                    if let videoPath = methodCall.arguments as? String {
                        videoEditor.openVideoEditorTrimmer(
                            fromViewController: controller,
                            videoURL: URL(fileURLWithPath: videoPath),
                            flutterResult: result
                        )
                    } else {
                        result(FlutterError(code: "ERR_START_TRIMMER_MISSING_VIDEO", message: "", details: nil))
                    }

                case AppDelegate.methodStartVideoEditor:
                    guard let args = methodCall.arguments as? [String: Any],
                          let videoPath = args["videoURL"] as? String
                    else {
                        videoEditor.openCamera(
                            fromViewController: controller,
                            flutterResult: result
                        )
                        return
                    }
                    let url = URL(fileURLWithPath: videoPath)
                    videoEditor.openEditor(
                        fromViewController: controller,
                        videoURL: url,
                        flutterResult: result
                    )

                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        audioBrowserFlutterEngine.run(withEntrypoint: "audioBrowser")
        GeneratedPluginRegistrant.register(with: audioBrowserFlutterEngine)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func provideCustomViewFactory() -> FlutterCustomViewFactory? {
        if configEnableCustomAudioBrowser {
            return FlutterCustomViewFactory()
        } else {
            let mubertApiLicense = ""
            let mubertApiKey = ""
            AudioBrowserConfig.shared.musicSource = .banubaMusic
            BanubaAudioBrowser.setMubertKeys(license: mubertApiLicense, token: mubertApiKey)
            return nil
        }
    }
}
