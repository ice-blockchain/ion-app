//
//  PhotoEditorModule.swift
//  Runner
//
//  Created by Banuba on 9.02.24.
//

import BanubaPhotoEditorSDK

class PhotoEditorModule: BanubaPhotoEditorDelegate {
    var photoEditorSDK: BanubaPhotoEditor?
    
    private var flutterResult: FlutterResult?
    
    init(token: String, flutterResult: @escaping FlutterResult) {
        var configuration = PhotoEditorConfig()
        configuration.editorScreenConfiguration = .init(saveResultToPhotoLibrary: false)
        photoEditorSDK = BanubaPhotoEditor(
            token: token,
            configuration: configuration
        )
        if photoEditorSDK == nil {
            flutterResult(FlutterError(code: AppDelegate.errEditorNotInitialized, message: "", details: nil))
            return
        }

        photoEditorSDK?.delegate = self

        flutterResult(nil)
    }
    
    func presentPhotoEditor(
        fromViewController controller: FlutterViewController,
        imagePath: String,
        flutterResult: @escaping FlutterResult
    ) {
        self.flutterResult = flutterResult
        
        guard let image = UIImage(contentsOfFile: imagePath) else {
                print("❌ Failed to load image from path: \(imagePath)")
                flutterResult(FlutterError(code: "INVALID_IMAGE_PATH", message: "Image could not be loaded from the provided path.", details: nil))
                return
            }
        
        let launchConfig = PhotoEditorLaunchConfig(
            hostController: controller,
            entryPoint: .editorWithImage(image)
        )
        
        photoEditorSDK?.delegate = self
        
        photoEditorSDK?.getLicenseState(completion: { [weak self] isValid in
          guard let self else { return }
          if isValid {
            print("✅ License is active, all good")
              photoEditorSDK?.presentPhotoEditor(
                  withLaunchConfiguration: launchConfig,
                  completion: nil
              )
          } else {
            print("❌ License is either revoked or expired")
          }
        })
    }
    
    // MARK: - PhotoEditorSDKDelegate
    func photoEditorDidCancel(_ photoEditor: BanubaPhotoEditor) {
        photoEditor.dismissPhotoEditor(animated: true) { [unowned self] in
            self.flutterResult?(nil)
            self.flutterResult = nil
            self.photoEditorSDK = nil
        }
    }

    func photoEditorDidFinishWithImage(_ photoEditor: BanubaPhotoEditor, image: UIImage) {
        let exportedPhotoFileUrl = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).png")
        do {
            try image.pngData()?.write(to: exportedPhotoFileUrl)
        } catch {
            debugPrint("Saving PhotoEditorSDK image failed! image path \(exportedPhotoFileUrl)")
        }
        let data = [
            AppDelegate.argExportedPhotoFile: exportedPhotoFileUrl.path,
        ]
        photoEditor.dismissPhotoEditor(animated: true) { [unowned self] in
            self.flutterResult?(data)
            self.flutterResult = nil
            self.photoEditorSDK = nil
        }
    }
}
