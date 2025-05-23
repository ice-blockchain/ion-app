import Foundation
import BanubaVideoEditorSDK
import BanubaAudioBrowserSDK
import BanubaVideoEditorCore
import Flutter

protocol VideoEditor {
    func initVideoEditor(token: String?, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorDefault(fromViewController controller: FlutterViewController, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorPIP(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
    
    func openVideoEditorTrimmer(fromViewController controller: FlutterViewController, videoURL: URL, flutterResult: @escaping FlutterResult)
}

class VideoEditorModule: VideoEditor {
    
    private var videoEditorSDK: BanubaVideoEditor?
    private var flutterResult: FlutterResult?
    
    // Track current editing file URL (iOS: Banuba SDK auto-cleans, just for tracking)
    private var currentEditingFileURL: URL?
    
    // Use “true” if you want users could restore the last video editing session.
    private let restoreLastVideoEditingSession: Bool = false
    
    func initVideoEditor(
        token: String?,
        flutterResult: @escaping FlutterResult
    ) {
        guard videoEditorSDK == nil else {
            flutterResult(nil)
            return
        }
        
        var config = VideoEditorConfig()

        config.featureConfiguration.supportsTrimRecordedVideo = true
        config.featureConfiguration.draftsConfig = .disabled

        // Make customization here
        
        videoEditorSDK = BanubaVideoEditor(
            token: token ?? "",
            // set argument .useEditorV2 to true to enable Editor V2
            arguments: [.useEditorV2 : true],
            configuration: config,
            externalViewControllerFactory: self.getAppDelegate().provideCustomViewFactory()
        )
        
        if videoEditorSDK == nil {
            flutterResult(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
            return
        }
        
        videoEditorSDK?.delegate = self
        flutterResult(nil)
    }
    
    func openVideoEditorDefault(
        fromViewController controller: FlutterViewController,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        let config = VideoEditorLaunchConfig(
            entryPoint: .camera,
            hostController: controller,
            animated: true
        )
        checkLicenseAndStartVideoEditor(with: config, flutterResult: flutterResult)
    }
    
    func openVideoEditorPIP(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        let pipLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .pip,
            hostController: controller,
            pipVideoItem: videoURL,
            musicTrack: nil,
            animated: true
        )
        
        checkLicenseAndStartVideoEditor(with: pipLaunchConfig, flutterResult: flutterResult)
    }
    
    func openVideoEditorTrimmer(
        fromViewController controller: FlutterViewController,
        videoURL: URL,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult

        print("[EDIT_VIDEO] 🎬 Opening video editor trimmer with URL: \(videoURL.path)")
        
        // Create a copy of the video in Documents directory for safe editing
        let editingURL = createEditingCopy(of: videoURL)
        guard let safeEditingURL = editingURL else {
            flutterResult(FlutterError(code: "ERR_COPY_FAILED", message: "Failed to create editing copy", details: nil))
            return
        }
        
        print("[EDIT_VIDEO] ✅ Created editing copy at: \(safeEditingURL.path)")

        // Editor V2 is not available from Trimmer screen. Editor screen will be opened
        let trimmerLaunchConfig = VideoEditorLaunchConfig(
            entryPoint: .trimmer,
            hostController: controller,
            videoItems: [safeEditingURL], // Use safe copy instead of original
            musicTrack: nil,
            animated: true
        )
        
        checkLicenseAndStartVideoEditor(with: trimmerLaunchConfig, flutterResult: flutterResult)
    }
    
    private func createEditingCopy(of originalURL: URL) -> URL? {
        let fileManager = FileManager.default
        
        // Use Documents directory instead of temp directory for persistence
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("[EDIT_VIDEO] ❌ Could not access Documents directory")
            return nil
        }
        
        let editingFileName = "editing_\(UUID().uuidString).mov"
        let editingURL = documentsURL.appendingPathComponent(editingFileName)
        
        do {
            // Remove existing file if it exists
            if fileManager.fileExists(atPath: editingURL.path) {
                try fileManager.removeItem(at: editingURL)
            }
            
            // Copy original to safe location
            try fileManager.copyItem(at: originalURL, to: editingURL)
            
            // Track this file for cleanup
            currentEditingFileURL = editingURL
            print("[EDIT_VIDEO] ✅ Successfully copied video for editing")
            
            // Immediately verify file exists after creation
            let fileExists = fileManager.fileExists(atPath: editingURL.path)
            print("[EDIT_VIDEO] 🔍 File exists immediately after creation: \(fileExists)")
            if fileExists {
                let attributes = try? fileManager.attributesOfItem(atPath: editingURL.path)
                let fileSize = attributes?[.size] as? Int64 ?? 0
                print("[EDIT_VIDEO] 📏 File size: \(fileSize) bytes")
            }
            
            return editingURL
        } catch {
            print("[EDIT_VIDEO] ❌ Failed to create editing copy: \(error)")
            return nil
        }
    }
    
    
    func checkLicenseAndStartVideoEditor(with config: VideoEditorLaunchConfig, flutterResult: @escaping FlutterResult) {
        if videoEditorSDK == nil {
            flutterResult(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
            return
        }
        
        // CRITICAL: Set delegate before each use to ensure callbacks work
        videoEditorSDK?.delegate = self
        print("[EDIT_VIDEO] ✅ Delegate set to self")
        
        // Clear any previous session data before starting new editing session
        // This ensures clean state but preserves files from previous cancelled sessions
        if self.restoreLastVideoEditingSession == false {
            self.videoEditorSDK?.clearSessionData()
        }
        
        // Checking the license might take around 1 sec in the worst case.
        // Please optimize use if this method in your application for the best user experience
        videoEditorSDK?.getLicenseState(completion: { [weak self] isValid in
            guard let self else { return }
            if isValid {
                print("[EDIT_VIDEO] ✅ The license is active")
                DispatchQueue.main.async {
                    self.videoEditorSDK?.presentVideoEditor(
                        withLaunchConfiguration: config,
                        completion: nil
                    )
                }
            } else {
                if self.restoreLastVideoEditingSession == false {
                    self.videoEditorSDK?.clearSessionData()
                }
                self.videoEditorSDK = nil
                print("[EDIT_VIDEO] ❌ Use of SDK is restricted: the license is revoked or expired")
                flutterResult(FlutterError(code: "ERR_SDK_LICENSE_REVOKED", message: "", details: nil))
            }
        })
    }
    
    private func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}


// MARK: - Export flow
extension VideoEditorModule {
    func exportVideo() {
        let progressView = createProgressViewController()

        progressView.cancelHandler = { [weak self] in
            self?.videoEditorSDK?.stopExport()
        }
        
        getTopViewController()?.present(progressView, animated: true)
        
        let manager = FileManager.default
        // Generate unique file name with timestamp
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let fileName = "edited_video_\(timestamp).mov"
        let firstFileURL = manager.temporaryDirectory.appendingPathComponent(fileName)
        if manager.fileExists(atPath: firstFileURL.path) {
            try? manager.removeItem(at: firstFileURL)
        }
        
        // Video configuration
        let exportVideoConfigurations: [ExportVideoConfiguration] = [
            ExportVideoConfiguration(
                fileURL: firstFileURL,
                quality: .auto,
                useHEVCCodecIfPossible: false,
                watermarkConfiguration: nil
            )
        ]
        
        // Set up export
        let exportConfiguration = ExportConfiguration(
            videoConfigurations: exportVideoConfigurations,
            isCoverEnabled: false,
            gifSettings: nil
        )
        
        videoEditorSDK?.export(
            using: exportConfiguration,
            exportProgress: { [weak progressView] progress in progressView?.updateProgressView(with: Float(progress)) }
        ) { [weak self] (error, coverImage) in
            // Export Callback
            DispatchQueue.main.async {
                progressView.dismiss(animated: true) {
                    // if export cancelled just hide progress view
                    if let error, error as NSError == exportCancelledError {
                        return
                    }
                    self?.completeExport(videoUrl: firstFileURL, error: error, coverImage: coverImage?.coverImage)
                }
            }
        }
    }
    
    private func completeExport(videoUrl: URL, error: Error?, coverImage: UIImage?) {
        print("[EDIT_VIDEO] 📤 completeExport called")
        videoEditorSDK?.dismissVideoEditor(animated: true) {
            let success = error == nil
            if success {
                let exportedVideoFilePath = videoUrl.path
                print("Video exported successfully = \(exportedVideoFilePath))")
                
                let coverImageData = coverImage?.pngData()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ss.SSS"
                
                let coverImageURL = FileManager.default.temporaryDirectory.appendingPathComponent("export_preview-\(dateFormatter.string(from: Date())).png")
                try? coverImageData?.write(to: coverImageURL)
                
                let data = [
                    AppDelegate.argExportedVideoFile: exportedVideoFilePath,
                    AppDelegate.argExportedVideoCoverPreviewPath: coverImageURL.path
                ]
                self.flutterResult?(data)
            } else {
                print("Error while exporting video = \(String(describing: error))")
                self.flutterResult?(FlutterError(code: "ERR_MISSING_EXPORT_RESULT", message: "", details: nil))
            }
            
            // Note: Banuba SDK automatically cleans up temporary files on iOS
            // No manual cleanup needed - just reset our tracking variable
            print("[EDIT_VIDEO] 📤 Banuba SDK automatically cleaned up editing file")
            self.currentEditingFileURL = nil
            
            // Remove strong reference to video editor sdk instance
            if self.restoreLastVideoEditingSession == false {
                self.videoEditorSDK?.clearSessionData()
            }
            self.videoEditorSDK = nil
        }
    }
    
    func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
        
        var topController = keyWindow?.rootViewController
        
        while let newTopController = topController?.presentedViewController {
            topController = newTopController
        }
        
        return topController
    }

    func createProgressViewController() -> ProgressViewController {
      let progressViewController = ProgressViewController.makeViewController()
      progressViewController.message = "Exporting"
      return progressViewController
    }
}

// MARK: - BanubaVideoEditorSDKDelegate
extension VideoEditorModule: BanubaVideoEditorDelegate {
    func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
        print("[EDIT_VIDEO] 🚫 videoEditorDidCancel called")
        // Don't clear session data immediately on cancel to preserve temporary files
        // Session data will be cleared on next editor launch if needed
        
        videoEditor.dismissVideoEditor(animated: true) {
            // Note: Banuba SDK automatically cleans up temporary files on iOS  
            // No manual cleanup needed - just reset our tracking variable
            print("[EDIT_VIDEO] 🚫 Banuba SDK automatically cleaned up editing file after cancel")
            self.currentEditingFileURL = nil
            
            // Remove strong reference to video editor sdk instance
            self.videoEditorSDK = nil
            
            // Return nil to indicate cancellation
            self.flutterResult?(nil)
        }
    }
    
    func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
        print("[EDIT_VIDEO] ✅ videoEditorDone called - starting export")
        exportVideo()
    }
}
