package io.ion.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import com.banuba.sdk.core.data.TrackData
import com.banuba.sdk.core.domain.ProvideTrackContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.UUID

/**
 * Sample Android Activity that demonstrates how to implement the simplest custom audio browser integration.
 * This implementation is required as a contract of VE SDK for managing audio track.
 * Use cases:
 *
 * 1. There is custom screen implemented on Flutter that shows list of audio tracks. The user can
 * select, unselect audio or close the screen. All these actions should be delivered to Video Editor SDK.
 *
 * 2. The user selected audio track and navigates to custom audio browser screen again.
 * Last used audio track is passed from Video Editor SDK to custom audio browser so that
 * you could highlight current audio to the user on your screen. See "lastAudioTrack" variable.
 */
class AudioBrowserActivity : FlutterActivity() {

    companion object {
        private const val TAG = "AudioBrowserActivity"

        private const val FLUTTER_ENTRY_POINT = "audioBrowser"

        private const val CHANNEL_AUDIO_BROWSER = "audioBrowserChannel"
        private const val METHOD_APPLY_AUDIO_TRACK = "applyAudioTrack"
        private const val METHOD_DISCARD_AUDIO_TRACK = "discardAudioTrack"
        private const val METHOD_CLOSE = "close"
    }

    private var lastAudioTrack: TrackData? = null
    private var audioBrowserChanelResult: MethodChannel.Result? = null

    override fun getDartEntrypointFunctionName(): String = FLUTTER_ENTRY_POINT

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "AudioBrowserActivity. onCreate");

        handleLastUsedAudio()

        val appFlutterEngine = requireNotNull(flutterEngine)

        MethodChannel(
            appFlutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_AUDIO_BROWSER
        ).setMethodCallHandler { call, result ->
            audioBrowserChanelResult = result
            when (call.method) {
                METHOD_APPLY_AUDIO_TRACK -> {
                    val rawJson = call.arguments as String

                    /*
                    rawJson format
                    {
	                    "url": "file:///storage/emulated/0/Android/data/com.banuba.flutter.flutter_ve_sdk/files/sample_audio.mp3",
	                    "id": "b238d460-6455-11ed-99ea-0741c437b7af",
	                    "artist": "The best artist",
	                    "title": "My favorite song"
                    }
                    */
                    val trackJson = JSONObject(rawJson)
                    val trackData = TrackData(
                        localUri = Uri.parse(trackJson.getString("url")),
                        id = UUID.fromString(trackJson.getString("id")),
                        title = trackJson.getString("title"),
                        artist = trackJson.getString("artist")
                    )
                    handleAudioTrack(trackData)
                }

                METHOD_DISCARD_AUDIO_TRACK -> handleAudioTrack(null)

                METHOD_CLOSE -> handleAudioTrack(lastAudioTrack)
            }
        }
    }

    private fun handleAudioTrack(audioTrack: TrackData?) {
        if (audioTrack == null) {
            // Video Editor SDK will cancel previous used audio.
            setResult(RESULT_CANCELED, null)
        } else {
            // Video Editor SDK will play this audio.
            val resultIntent = Intent()
            resultIntent.putExtra(ProvideTrackContract.EXTRA_RESULT_TRACK_DATA, audioTrack)
            setResult(RESULT_OK, resultIntent)
        }

        finish()
        audioBrowserChanelResult?.success(null)
    }

    private fun handleLastUsedAudio() {
        lastAudioTrack = intent.getParcelableExtra<TrackData>("EXTRA_LAST_PROVIDED_TRACK")

        Log.d(TAG, "Handle last used audio = $lastAudioTrack")
        if (lastAudioTrack != null) {
            val lastAudioPath = requireNotNull(lastAudioTrack).localUri.toString()
            // Pass lastAudioPath to Flutter side to highlight the choice to the user.
        }
    }
}