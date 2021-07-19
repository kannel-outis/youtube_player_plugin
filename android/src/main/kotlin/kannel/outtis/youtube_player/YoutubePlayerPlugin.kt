package kannel.outtis.youtube_player

import android.net.Uri
import android.view.Surface

import androidx.annotation.NonNull
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.source.MediaSource
import com.google.android.exoplayer2.source.MergingMediaSource
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DataSource
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource
import com.google.android.exoplayer2.upstream.DefaultHttpDataSourceFactory


import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** YoutubePlayerPlugin */
class YoutubePlayerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var surfaceManager:SurfaceTextureManagerClass
  var exoplayer:SimpleExoPlayer? = null
  var context:android.content.Context? = null
  var textureId:Long? = null



  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "youtube_player")
    surfaceManager = SurfaceTextureManagerClass(flutterPluginBinding);
    context =  flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    callHandlers(call, result)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun callHandlers(call: MethodCall , result: Result):Unit{
      when (call.method) {
          "getPlatformVersion" -> {
              result.success("Android ${android.os.Build.VERSION.RELEASE}")
          }
          "init" -> {
              val width = call.argument<Double>("width")
              val height = call.argument<Double>("height")
              textureId = surfaceManager.initState(width!!, height!!)
              result.success(textureId)
          }
          "dispose" -> {
              surfaceManager.dispose()
              textureId = null
          }
          "initPlayer" -> {

              initPlayer(call)

          }
          else -> {
              result.notImplemented()

          }
      }

  }

    private fun initPlayer(call: MethodCall): Unit{
        val videoUrl:String? = call.argument<String>("video")
        val audioUrl:String? = call.argument<String>("audio")
        exoplayer =  SimpleExoPlayer.Builder(context!!).build()
        val dataSourceFactory:DataSource.Factory = DefaultHttpDataSourceFactory("Exoplayer",
            null,
            DefaultHttpDataSource.DEFAULT_CONNECT_TIMEOUT_MILLIS,
            DefaultHttpDataSource.DEFAULT_READ_TIMEOUT_MILLIS,
            true
        )
        val vUri = Uri.parse(videoUrl)
        val aUri  = Uri.parse(audioUrl)
        val vSource:ProgressiveMediaSource = ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(
            MediaItem.fromUri(vUri))
        val aSource:ProgressiveMediaSource = ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(
            MediaItem.fromUri(aUri))
        val mediaSource:MediaSource = MergingMediaSource(vSource, aSource)
        exoplayer!!.prepare(mediaSource)
        val surface:Surface = Surface(surfaceManager.getsurfaceTexture())
        exoplayer!!.setVideoSurface(surface)
        exoplayer!!.playWhenReady = true
    }
}
