// SPDX-License-Identifier: ice License 1.0

import Foundation
import BanubaVideoEditorSDK
import BanubaAudioBrowserSDK
import BanubaVideoEditorCore
import Flutter

protocol VideoEditor {
    func initVideoEditor(token: String?, flutterResult: @escaping FlutterResult)
    func openVideoEditorTrimmer(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
    func openCamera(fromViewController controller: FlutterViewController, flutterResult: @escaping FlutterResult)
    func openEditor(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
}

class VideoEditorModule: VideoEditor {
    private var videoEditorSDK: BanubaVideoEditor?
    private var flutterResult: FlutterResult?
    private let restoreLastVideoEditingSession = false

    func initVideoEditor(token: String?, flutterResult: @escaping FlutterResult) {
        guard videoEditorSDK == nil else {
            flutterResult(nil)
            return
        }
        var config = VideoEditorConfig()
        config.featureConfiguration.supportsTrimRecordedVideo = true
        videoEditorSDK = BanubaVideoEditor(
            token: token ?? "",
            arguments: [.useEditorV2 : true],
            configuration: config,
            externalViewControllerFactory: getAppDelegate().provideCustomViewFactory()
        )
        if videoEditorSDK == nil {
            flutterResult(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
            return
        }
        videoEditorSDK?.delegate = self
        flutterResult(nil)
    }

    func openVideoEditorTrimmer(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult

        let trimmerLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .trimmer,
            hostController: controller,
            videoItems: [videoURL],
            musicTrack: nil,
            animated: true
        )

        checkLicenseAndStartVideoEditor(with: trimmerLaunchConfig, flutterResult: flutterResult)
    }

    func openCamera(
        fromViewController controller: FlutterViewController,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        let cameraConfig = VideoEditorLaunchConfig(
            entryPoint: .camera,
            hostController: controller,
            animated: true
        )
        checkLicenseAndStartVideoEditor(with: cameraConfig, flutterResult: flutterResult)
    }

    func openEditor(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        let editorConfig = VideoEditorLaunchConfig(
            entryPoint: .editor,
            hostController: controller,
            videoItems: [videoURL],
            animated: true
        )
        checkLicenseAndStartVideoEditor(with: editorConfig, flutterResult: flutterResult)
    }

    private func checkLicenseAndStartVideoEditor(
        with config: VideoEditorLaunchConfig,
        flutterResult: @escaping FlutterResult
    ) {
        guard let sdk = videoEditorSDK else {
            flutterResult(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
            return
        }
        sdk.getLicenseState { [weak self] isValid in
            guard let self = self else { return }
            if isValid {
                DispatchQueue.main.async {
                    sdk.presentVideoEditor(withLaunchConfiguration: config, completion: nil)
                }
            } else {
                if self.restoreLastVideoEditingSession == false {
                    sdk.clearSessionData()
                }
                self.videoEditorSDK = nil
                flutterResult(FlutterError(code: "ERR_SDK_LICENSE_REVOKED", message: "", details: nil))
            }
        }
    }

    private func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension VideoEditorModule: BanubaVideoEditorDelegate {
    func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true) {
            if self.restoreLastVideoEditingSession == false {
                self.videoEditorSDK?.clearSessionData()
            }
            let data = [
                AppDelegate.argExportedVideoFile: nil
            ]
            self.flutterResult?(data)
            self.videoEditorSDK = nil
        }
    }

    func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
        exportVideo()
    }

    func exportVideo() {
        let progressView = createProgressViewController()
        progressView.cancelHandler = { [weak self] in
            self?.videoEditorSDK?.stopExport()
        }
        getTopViewController()?.present(progressView, animated: true)
        let manager = FileManager.default
        let firstFileURL = manager.temporaryDirectory.appendingPathComponent("banuba_demo_ve.mov")
        if manager.fileExists(atPath: firstFileURL.path) {
            try? manager.removeItem(at: firstFileURL)
        }
        let exportConfigs = [
            ExportVideoConfiguration(
                fileURL: firstFileURL,
                quality: .auto,
                useHEVCCodecIfPossible: false,
                watermarkConfiguration: nil
            )
        ]
        let exportConfiguration = ExportConfiguration(
            videoConfigurations: exportConfigs,
            isCoverEnabled: false,
            gifSettings: nil
        )
        videoEditorSDK?.export(
            using: exportConfiguration,
            exportProgress: { [weak progressView] progress in
                progressView?.updateProgressView(with: Float(progress))
            },
            completion: { [weak self] error, cover in
                DispatchQueue.main.async {
                    progressView.dismiss(animated: true) {
                        if let e = error, (e as NSError) == exportCancelledError {
                            return
                        }
                        self?.completeExport(videoUrl: firstFileURL, error: error, coverImage: cover?.coverImage)
                    }
                }
            }
        )
    }

    private func completeExport(videoUrl: URL, error: Error?, coverImage: UIImage?) {
        videoEditorSDK?.dismissVideoEditor(animated: true) {
            if error == nil {
                let data = [
                    AppDelegate.argExportedVideoFile: videoUrl.path,
                ]
                self.flutterResult?(data)
            } else {
                self.flutterResult?(FlutterError(code: "ERR_MISSING_EXPORT_RESULT", message: "", details: nil))
            }
            if self.restoreLastVideoEditingSession == false {
                self.videoEditorSDK?.clearSessionData()
            }
            self.videoEditorSDK = nil
        }
    }

    private func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        var topController = keyWindow?.rootViewController
        while let newTop = topController?.presentedViewController {
            topController = newTop
        }
        return topController
    }

    private func createProgressViewController() -> ProgressViewController {
        let progressVC = ProgressViewController.makeViewController()
        progressVC.message = "Exporting"
        return progressVC
    }
}
