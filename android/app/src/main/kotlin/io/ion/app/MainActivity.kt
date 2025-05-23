package io.ion.app
    
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.content.FileProvider
import androidx.core.os.bundleOf
import com.banuba.sdk.cameraui.data.PipConfig
import com.banuba.sdk.core.license.BanubaVideoEditor
import com.banuba.sdk.core.license.LicenseStateCallback
import com.banuba.sdk.core.EditorUtilityManager
import com.banuba.sdk.export.data.ExportResult
import com.banuba.sdk.export.utils.EXTRA_EXPORTED_SUCCESS
import com.banuba.sdk.pe.PhotoCreationActivity
import com.banuba.sdk.pe.data.PhotoEditorConfig
import com.banuba.sdk.pe.BanubaPhotoEditor
import com.banuba.sdk.ve.flow.VideoCreationActivity
import com.banuba.sdk.ve.ext.VideoEditorUtils.getKoin
import io.ion.app.AudioFocusHandler
import org.koin.core.context.stopKoin
import org.koin.core.error.InstanceCreationException
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {
    companion object {
        // For Photo Editor
        private const val PHOTO_EDITOR_REQUEST_CODE = 8888
        private const val METHOD_INIT_PHOTO_EDITOR = "initPhotoEditor"
        private const val METHOD_START_PHOTO_EDITOR = "startPhotoEditor"
        private const val ARG_EXPORTED_PHOTO_FILE = "argExportedPhotoFilePath"

        // For Video Editor
        const val CONFIG_ENABLE_CUSTOM_AUDIO_BROWSER = false
        private const val VIDEO_EDITOR_REQUEST_CODE = 7788
        private const val METHOD_INIT_VIDEO_EDITOR = "initVideoEditor"
        private const val METHOD_START_VIDEO_EDITOR = "startVideoEditor"
        private const val METHOD_START_VIDEO_EDITOR_PIP = "startVideoEditorPIP"
        private const val METHOD_START_VIDEO_EDITOR_TRIMMER = "startVideoEditorTrimmer"
        private const val METHOD_RELEASE_VIDEO_EDITOR = "releaseVideoEditor"
        private const val METHOD_DEMO_PLAY_EXPORTED_VIDEO = "playExportedVideo"
        private const val ARG_EXPORTED_VIDEO_FILE = "argExportedVideoFilePath"
        private const val ARG_EXPORTED_VIDEO_COVER = "argExportedVideoCoverPreviewPath"

        // Errors code
        private const val ERR_CODE_SDK_NOT_INITIALIZED = "ERR_SDK_NOT_INITIALIZED"
        private const val ERR_CODE_SDK_LICENSE_REVOKED = "ERR_SDK_LICENSE_REVOKED"


    }

    private var exportResult: MethodChannel.Result? = null
    
    // Track current editing file for cleanup (Android: Manual cleanup required)
    private var currentEditingFile: File? = null

    private var videoEditorSDK: BanubaVideoEditor? = null
    private var photoEditorSDK: BanubaPhotoEditor? = null
    private var videoEditorModule: VideoEditorModule? = null
    
    private lateinit var audioFocusHandler: AudioFocusHandler

    // Bundle for enabling Editor V2
    private val extras = bundleOf(
        "EXTRA_USE_EDITOR_V2" to true
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        super.configureFlutterEngine(flutterEngine)
        
        audioFocusHandler = AudioFocusHandler(applicationContext, flutterEngine)

        // Set up your MethodChannel here after registration
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "banubaSdkChannel"
        ).setMethodCallHandler { call, result ->
            // Initialize export result callback to deliver the results back to Flutter
            exportResult = result

            when (call.method) {
                 METHOD_INIT_VIDEO_EDITOR -> {
                    val licenseToken = call.arguments as String
                    videoEditorSDK = BanubaVideoEditor.initialize(licenseToken)

                    if (videoEditorSDK == null) {
                        // The SDK token is incorrect - empty or truncated
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        if (videoEditorModule == null) {
                            // Initialize video editor sdk dependencies
                            videoEditorModule = VideoEditorModule().apply {
                                initialize(application)
                            }
                        }
                        result.success(null)
                    }
                }

                METHOD_START_VIDEO_EDITOR_TRIMMER -> {
                    Log.d("EDIT_VIDEO", "🎬 Received video editor trimmer request")
                    val videoFilePath = call.arguments as? String
                    Log.d("EDIT_VIDEO", "📁 Video file path: $videoFilePath")
                    
                    val trimmerVideoUri = videoFilePath?.let { Uri.fromFile(File(it)) }
                    if (trimmerVideoUri == null) {
                        Log.e("EDIT_VIDEO", "❌ Missing video file path")
                        exportResult?.error("ERR_START_TRIMMER_MISSING_VIDEO", "", null)
                    } else {
                        Log.d("EDIT_VIDEO", "🔐 Checking SDK license...")
                        checkSdkLicenseVideoEditor(
                            callback = { isValid ->
                                if (isValid) {
                                    Log.d("EDIT_VIDEO", "✅ License is active, starting video editor")
                                    startVideoEditorModeTrimmer(trimmerVideoUri)
                                } else {
                                    Log.e("EDIT_VIDEO", "❌ SDK license is revoked or expired")
                                    result.error(ERR_CODE_SDK_LICENSE_REVOKED, "", null)
                                }
                            },
                            onError = { 
                                Log.e("EDIT_VIDEO", "❌ SDK not initialized")
                                result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null) 
                            }
                        )
                    }
                }

                METHOD_RELEASE_VIDEO_EDITOR -> {
                    if (videoEditorModule != null) {
                        val utilityManager = try {
                            // EditorUtilityManager is NULL when the token is expired or revoked.
                            // This dependency is not explicitly created in DI.
                            getKoin().getOrNull<EditorUtilityManager>()
                        } catch (e: InstanceCreationException) {
                            result.error("EditorUtilityManager was not initialized!", "", null)
                            null
                        }
                        utilityManager?.release()
                        stopKoin()
                        videoEditorModule = null
                    }
                    videoEditorSDK = null
                    result.success(null)
                }
                METHOD_INIT_PHOTO_EDITOR -> {
                    val licenseToken = call.arguments as String
                    photoEditorSDK = BanubaPhotoEditor.initialize(licenseToken)

                    if (photoEditorSDK == null) {
                        // The SDK token is incorrect - empty or truncated
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        result.success(null)
                    }
                }

                METHOD_START_PHOTO_EDITOR -> {
                    if (photoEditorSDK == null) {
                        // The SDK token is incorrect - empty or truncated
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        // ✅ The license is active
                        val imageUrl =
                            call.argument<String>("imagePath") // Get the image URL from Flutter
                        if (imageUrl.isNullOrEmpty()) {
                            result.error("INVALID_ARGUMENT", "Image URL is required", null)
                            return@setMethodCallHandler
                        }
                        val imageUri = Uri.fromFile(File(imageUrl))
                        val config = PhotoEditorConfig.Builder(this).build();
                        startActivityForResult(
                            PhotoCreationActivity.startFromEditor(this, config, imageUri),
                            PHOTO_EDITOR_REQUEST_CODE
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    // Observe export video results
    override fun onActivityResult(requestCode: Int, result: Int, intent: Intent?) {
        super.onActivityResult(requestCode, result, intent)
        if (requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            if (result == RESULT_OK) {
                Log.d("EDIT_VIDEO", "✅ Video editing completed successfully")
                val exportResult =
                    intent?.getParcelableExtra(EXTRA_EXPORTED_SUCCESS) as? ExportResult.Success
                if (exportResult == null) {
                    Log.e("EDIT_VIDEO", "❌ Missing export result")
                    this.exportResult?.error(
                        "ERR_MISSING_EXPORT_RESULT",
                        "",
                        null
                    )
                } else {
                    val data = prepareVideoExportData(exportResult)
                    Log.d("EDIT_VIDEO", "📤 Returning edited video data: ${data[ARG_EXPORTED_VIDEO_FILE]}")
                    this.exportResult?.success(data)
                }
                
                // Clean up temporary editing file
                cleanupCurrentEditingFile()
            } else if (result == RESULT_CANCELED) {
                Log.d("EDIT_VIDEO", "🚫 User cancelled video editing")
                
                // Clean up temporary editing file
                cleanupCurrentEditingFile()
                
                // User cancelled video editing - return null to indicate cancellation
                this.exportResult?.success(null)
            }
        } else if (requestCode == PHOTO_EDITOR_REQUEST_CODE) {
            if (result == RESULT_OK) {
                Log.d("EDIT_PHOTO", "✅ Photo editing completed successfully")
                val data = preparePhotoExportData(intent)
                exportResult?.success(data)
            } else if (result == RESULT_CANCELED) {
                Log.d("EDIT_PHOTO", "🚫 User cancelled photo editing")
                // User cancelled photo editing - return null to indicate cancellation
                exportResult?.success(null)
            }
        }
    }

    // Customize photo export data results to meet your requirements.
    // You can use Map or JSON to pass custom data for your app.
    private fun preparePhotoExportData(result: Intent?): Map<String, Any?> {
        val photoUri = result?.getParcelableExtra(PhotoCreationActivity.EXTRA_EXPORTED) as? Uri
        return mapOf(
            ARG_EXPORTED_PHOTO_FILE to photoUri?.toString()
        )
    }

    // Customize export data results to meet your requirements.
    // You can use Map or JSON to pass custom data for your app.
    private fun prepareVideoExportData(result: ExportResult.Success): Map<String, Any?> {
        // First exported video file path is used to play video in this sample to demonstrate
        // the result of video export.
        // You can provide your custom logic.
        val firstVideoFilePath = result.videoList[0].sourceUri.toString()
        val videoCoverImagePath = result.preview.toString()
        val data = mapOf(
            ARG_EXPORTED_VIDEO_FILE to firstVideoFilePath,
            ARG_EXPORTED_VIDEO_COVER to videoCoverImagePath
        )
        return data
    }

    private fun startVideoEditorModeTrimmer(trimmerVideo: Uri) {
        Log.d("EDIT_VIDEO", "🎬 Opening video editor trimmer with URI: $trimmerVideo")
        
        // Create a safe copy of the video for editing
        val safeEditingUri = copyVideoToSafeLocation(trimmerVideo)
        val finalUri = safeEditingUri ?: trimmerVideo
        
        if (safeEditingUri != null) {
            Log.d("EDIT_VIDEO", "✅ Created editing copy at: $safeEditingUri")
        } else {
            Log.w("EDIT_VIDEO", "⚠️ Failed to create editing copy, using original: $trimmerVideo")
        }
        
        startActivityForResult(
            VideoCreationActivity.startFromTrimmer(
                context = this,
                // setup data that will be acceptable during export flow
                additionalExportData = null,
                // set TrackData object if you open VideoCreationActivity with preselected music track
                audioTrackData = null,
                // set Trimmer video configuration with safe copy
                predefinedVideos = arrayOf(finalUri),
                extras = extras
            ), VIDEO_EDITOR_REQUEST_CODE
        )
    }

    private fun copyVideoToSafeLocation(originalUri: Uri): Uri? {
        try {
            val originalPath = originalUri.path
            if (originalPath == null) {
                Log.e("EDIT_VIDEO", "❌ Original URI path is null")
                return null
            }
            
            val originalFile = File(originalPath)
            if (!originalFile.exists()) {
                Log.e("EDIT_VIDEO", "❌ Original file does not exist: $originalPath")
                return null
            }
            
            // Use internal files directory for safe storage
            val editingFileName = "editing_${System.currentTimeMillis()}.mp4"
            val editingFile = File(filesDir, editingFileName)
            
            Log.d("EDIT_VIDEO", "📁 Copying from: $originalPath")
            Log.d("EDIT_VIDEO", "📁 Copying to: ${editingFile.absolutePath}")
            
            // Remove existing file if it exists
            if (editingFile.exists()) {
                editingFile.delete()
            }
            
            // Copy original to safe location
            originalFile.copyTo(editingFile, overwrite = true)
            
            // Track this file for cleanup
            currentEditingFile = editingFile
            Log.d("EDIT_VIDEO", "✅ Successfully copied video for editing")
            return Uri.fromFile(editingFile)
        } catch (e: Exception) {
            Log.e("EDIT_VIDEO", "❌ Failed to create editing copy: ${e.message}", e)
            return null
        }
    }

    private fun cleanupCurrentEditingFile() {
        Log.d("EDIT_VIDEO", "🧹 cleanupCurrentEditingFile() called")
        
        val file = currentEditingFile ?: run {
            Log.w("EDIT_VIDEO", "⚠️ No current editing file to cleanup")
            return
        }
        
        Log.d("EDIT_VIDEO", "🧹 Checking file: ${file.absolutePath}")
        
        try {
            if (file.exists()) {
                val deleted = file.delete()
                if (deleted) {
                    Log.d("EDIT_VIDEO", "🗑️ Manually cleaned up editing file: ${file.name}")
                } else {
                    Log.w("EDIT_VIDEO", "⚠️ Failed to delete editing file: ${file.name}")
                }
            } else {
                Log.d("EDIT_VIDEO", "✅ File already cleaned up by Banuba SDK: ${file.name}")
            }
        } catch (e: Exception) {
            Log.e("EDIT_VIDEO", "⚠️ Failed to cleanup editing file: ${e.message}", e)
        }
        
        currentEditingFile = null
        Log.d("EDIT_VIDEO", "🧹 Reset currentEditingFile to null")
    }

    private fun checkSdkLicenseVideoEditor(
        callback: LicenseStateCallback,
        onError: () -> Unit
    ) {
        val sdk = videoEditorSDK
        if (sdk == null) {
            onError()
        } else {
            // Checking the license might take around 1 sec in the worst case.
            // Please optimize use if this method in your application for the best user experience
            sdk.getLicenseState(callback)
        }
    }
}
