package com.banuba.flutter.flutter_ve_sdk

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.result.ActivityResultLauncher
import androidx.fragment.app.Fragment
import com.banuba.sdk.core.data.TrackData
import com.banuba.sdk.core.domain.ProvideTrackContract
import com.banuba.sdk.core.ui.ContentFeatureProvider
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterMain
import java.lang.ref.WeakReference

// Video Editor SDK contract for using custom Audio Browser implementation.
// Please read more details in AudioBrowserActivity.kt
class AudioBrowserContentProvider : ContentFeatureProvider<TrackData, Fragment> {

    private var activityResultLauncher: ActivityResultLauncher<Intent>? = null

    private val activityResultCallback: (TrackData?) -> Unit = {
        activityResultCallbackInternal(it)
    }
    private var activityResultCallbackInternal: (TrackData?) -> Unit = {}

    override fun init(hostFragment: WeakReference<Fragment>) {
        activityResultLauncher = hostFragment.get()?.registerForActivityResult(
            ProvideTrackContract(),
            activityResultCallback
        )
    }

    override fun requestContent(
        context: Context,
        extras: Bundle
    ): ContentFeatureProvider.Result<TrackData> {
        val dataIntent =
            Intent(context, AudioBrowserActivity::class.java).apply { putExtras(extras) }
        return ContentFeatureProvider.Result.RequestUi(dataIntent)
    }

    override fun handleResult(
        hostFragment: WeakReference<Fragment>,
        intent: Intent,
        block: (TrackData?) -> Unit
    ) {
        activityResultCallbackInternal = block
        activityResultLauncher?.launch(intent)
    }
}