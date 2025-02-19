package io.ion.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
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

    private var videoEditorSDK: BanubaVideoEditor? = null
    private var photoEditorSDK: BanubaPhotoEditor? = null
    private var videoEditorModule: VideoEditorModule? = null

    // Bundle for enabling Editor V2
    private val extras = bundleOf(
        "EXTRA_USE_EDITOR_V2" to true
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "banubaSdkChannel"
        ).setMethodCallHandler { call, result ->
            exportResult = result

            when (call.method) {

                METHOD_INIT_VIDEO_EDITOR -> {
                    val licenseToken = call.arguments as String
                    videoEditorSDK = BanubaVideoEditor.initialize(licenseToken)

                    if (videoEditorSDK == null) {
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        if (videoEditorModule == null) {
                            videoEditorModule = VideoEditorModule().apply {
                                initialize(application)
                            }
                        }
                        result.success(null)
                    }
                }

                METHOD_START_VIDEO_EDITOR -> {
                    val args = call.arguments as? Map<*, *>
                    checkSdkLicenseVideoEditor(
                        callback = { isValid ->
                            if (isValid) {
                                val videoFilePath = args?.get("videoURL") as? String
                                if (videoFilePath.isNullOrEmpty()) {
                                    startVideoEditorModeCamera()
                                } else {
                                    val uri = Uri.fromFile(File(videoFilePath))
                                    startVideoEditorModeEditor(uri)
                                }
                            } else {
                                result.error(ERR_CODE_SDK_LICENSE_REVOKED, "", null)
                            }
                        },
                        onError = { result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null) }
                    )
                }

                METHOD_START_VIDEO_EDITOR_TRIMMER -> {
                    val videoFilePath = call.arguments as? String
                    val trimmerVideoUri = videoFilePath?.let { Uri.fromFile(File(it)) }
                    if (trimmerVideoUri == null) {
                        exportResult?.error("ERR_START_TRIMMER_MISSING_VIDEO", "", null)
                    } else {
                        checkSdkLicenseVideoEditor(
                            callback = { isValid ->
                                if (isValid) {
                                    startVideoEditorModeTrimmer(trimmerVideoUri)
                                } else {
                                    result.error(ERR_CODE_SDK_LICENSE_REVOKED, "", null)
                                }
                            },
                            onError = { result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null) }
                        )
                    }
                }

                METHOD_RELEASE_VIDEO_EDITOR -> {
                    if (videoEditorModule != null) {
                        val utilityManager = try {
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
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        result.success(null)
                    }
                }

                METHOD_START_PHOTO_EDITOR -> {
                    if (photoEditorSDK == null) {
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        val imageUrl = call.argument<String>("imagePath")
                        if (imageUrl.isNullOrEmpty()) {
                            result.error("INVALID_ARGUMENT", "Image URL is required", null)
                        } else {
                            val imageUri = Uri.fromFile(File(imageUrl))
                            val config = PhotoEditorConfig.Builder(this).build()
                            startActivityForResult(
                                PhotoCreationActivity.startFromEditor(this, config, imageUri),
                                PHOTO_EDITOR_REQUEST_CODE
                            )
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        super.onActivityResult(requestCode, resultCode, intent)

        if (requestCode == VIDEO_EDITOR_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                val exportResultData = intent?.getParcelableExtra(EXTRA_EXPORTED_SUCCESS) as? ExportResult.Success
                if (exportResultData == null) {
                    this.exportResult?.error("ERR_MISSING_EXPORT_RESULT", "", null)
                } else {
                    val data = prepareVideoExportData(exportResultData)
                    this.exportResult?.success(data)
                }
            } else if (resultCode == RESULT_CANCELED) {
                val data = mapOf<String, Any?>(
                    ARG_EXPORTED_VIDEO_FILE to null
                )
                this.exportResult?.success(data)
                videoEditorSDK = null
            }
        } else if (requestCode == PHOTO_EDITOR_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                val data = preparePhotoExportData(intent)
                exportResult?.success(data)
            } else if (resultCode == RESULT_CANCELED) {
                val data = mapOf<String, Any?>(
                    ARG_EXPORTED_PHOTO_FILE to null
                )
                exportResult?.success(data)
            }
        }
    }

    private fun preparePhotoExportData(result: Intent?): Map<String, Any?> {
        val photoUri = result?.getParcelableExtra(PhotoCreationActivity.EXTRA_EXPORTED) as? Uri
        return mapOf(
            ARG_EXPORTED_PHOTO_FILE to photoUri?.toString()
        )
    }

    private fun prepareVideoExportData(result: ExportResult.Success): Map<String, Any?> {
        val firstVideoFilePath = result.videoList[0].sourceUri.toString()
        val videoCoverImagePath = result.preview.toString()
        return mapOf(
            ARG_EXPORTED_VIDEO_FILE to firstVideoFilePath,
            ARG_EXPORTED_VIDEO_COVER to videoCoverImagePath
        )
    }

    private fun startVideoEditorModeCamera() {
        startActivityForResult(
            VideoCreationActivity.startFromCamera(
                context = this,
                additionalExportData = null,
                audioTrackData = null,
                pictureInPictureConfig = PipConfig(
                    video = Uri.EMPTY,
                    openPipSettings = false
                ),
                extras = extras
            ), VIDEO_EDITOR_REQUEST_CODE
        )
    }

    private fun startVideoEditorModeEditor(uri: Uri) {
        startActivityForResult(
            VideoCreationActivity.startFromEditor(
                context = this,
                additionalExportData = null,
                audioTrackData = null,
                predefinedVideos = arrayOf(uri),
                extras = extras
            ), VIDEO_EDITOR_REQUEST_CODE
        )
    }

    private fun startVideoEditorModeTrimmer(trimmerVideo: Uri) {
        startActivityForResult(
            VideoCreationActivity.startFromTrimmer(
                context = this,
                additionalExportData = null,
                audioTrackData = null,
                predefinedVideos = arrayOf(trimmerVideo),
                extras = extras
            ), VIDEO_EDITOR_REQUEST_CODE
        )
    }

    private fun checkSdkLicenseVideoEditor(
        callback: LicenseStateCallback,
        onError: () -> Unit
    ) {
        val sdk = videoEditorSDK
        if (sdk == null) {
            onError()
        } else {
            sdk.getLicenseState(callback)
        }
    }
}
