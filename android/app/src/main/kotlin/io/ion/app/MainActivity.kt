package io.ion.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import com.banuba.sdk.pe.PhotoCreationActivity
import com.banuba.sdk.pe.BanubaPhotoEditor
import com.banuba.sdk.pe.data.PhotoEditorConfig
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity() {

    companion object {
        // For Photo Editor
        private const val PHOTO_EDITOR_REQUEST_CODE = 8888
        private const val METHOD_INIT_PHOTO_EDITOR = "initPhotoEditor"
        private const val METHOD_START_PHOTO_EDITOR = "startPhotoEditor"

        private const val ARG_EXPORTED_PHOTO_FILE = "argExportedPhotoFilePath"

        // Errors code
        private const val ERR_CODE_SDK_NOT_INITIALIZED = "ERR_SDK_NOT_INITIALIZED"
        private const val ERR_CODE_SDK_LICENSE_REVOKED = "ERR_SDK_LICENSE_REVOKED"
    }

    private var exportResult: MethodChannel.Result? = null

    private var photoEditorSDK: BanubaPhotoEditor? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val appFlutterEngine = requireNotNull(flutterEngine)
        GeneratedPluginRegistrant.registerWith(appFlutterEngine)

        MethodChannel(
            appFlutterEngine.dartExecutor.binaryMessenger,
            "banubaSdkChannel"
        ).setMethodCallHandler { call, result ->
            // Initialize export result callback to deliver the results back to Flutter
            exportResult = result

            when (call.method) {
                METHOD_INIT_PHOTO_EDITOR -> {
                    val licenseToken = call.arguments as String
                    photoEditorSDK = BanubaPhotoEditor.initialize(licenseToken)

                    if (photoEditorSDK == null) {
                        // The SDK token is incorrect - empty or truncated
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    }
                    result.success(null)
                }

                METHOD_START_PHOTO_EDITOR -> {
                    if (photoEditorSDK == null) {
                        // The SDK token is incorrect - empty or truncated
                        result.error(ERR_CODE_SDK_NOT_INITIALIZED, "", null)
                    } else {
                        // ✅ The license is active
                        val imageUrl = call.argument<String>("imagePath") // Get the image URL from Flutter
                        if (imageUrl.isNullOrEmpty()) {
                            result.error("INVALID_ARGUMENT", "Image URL is required", null)
                            return@setMethodCallHandler
                        }
                        val imageUri = Uri.fromFile(File(imageUrl))
                        val config = PhotoEditorConfig.Builder(this).build();
                        startActivityForResult(
                            PhotoCreationActivity.startFromEditor(this, config, imageUri ),
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
        if (requestCode == PHOTO_EDITOR_REQUEST_CODE && result == RESULT_OK) {
            val data = preparePhotoExportData(intent)
            exportResult?.success(data)
        }
    }

    // Customize photo export data results to meet your requirements.
    // You can use Map or JSON to pass custom data for your app.
    private fun preparePhotoExportData(result: Intent?): Map<String, Any?> {
        val photoUri = result?.getParcelableExtra(PhotoCreationActivity.EXTRA_EXPORTED) as? Uri
        val data = mapOf(
            ARG_EXPORTED_PHOTO_FILE to photoUri?.toString()
        )
        return data
    }
}
