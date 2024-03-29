package kannel.outtis.youtube_player



import android.net.Uri
import android.view.Surface
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class YoutubePlayerPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var surfaceManager: SurfaceTextureManagerClass
  var context:android.content.Context? = null
  var textureId:Long? = null
    private lateinit var eventChannel: EventChannel
    private lateinit var messenger:io.flutter.plugin.common.BinaryMessenger




    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        messenger = flutterPluginBinding.binaryMessenger
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
      ExoPlayerIm.controlMethodCall(call, result)
      when (call.method) {
          "getPlatformVersion" -> {
              result.success("Android ${android.os.Build.VERSION.RELEASE}")
          }
          "init"->{

          }
          "initSurface" -> {
              ExoPlayerIm.dispose()
              textureId = surfaceManager.initSurface()
              result.success(textureId)
          }
          "dispose" -> {
              surfaceManager.dispose()
              textureId = null
              ExoPlayerIm.dispose()
              Log.d("dispose", "dispose called and all cleared")
          }
          "initPlayer" -> {
              val videoUrl:String? = call.argument<String>("video")
              val audioUrl:String? = call.argument<String>("audio")
              val youtubeLink:String? = call.argument<String>("youtubeLink")
              val quality:String? = call.argument<String>("quality")
              if(youtubeLink != null){
                  YtExtractorClassSingleTonObject.instance.extractFun(youtubeLink, context!!, quality!!){
                          val links:MutableMap<String, Any?> = HashMap<String, Any?>()
                          links["audio"] = it.audioLink
                          links["video"] = it.videoLink
                          eventChannel = EventChannel(messenger, "youtube-player + $textureId")

                          val readyToPlay =  ExoPlayerIm.setUpPlayer(streamLinks = it, context = context!!, surfaceManager = surfaceManager, eventChannel = eventChannel)
                          links["readyToPlay"] = readyToPlay
                          result.success(links)

                  }
              }else{
                  eventChannel = EventChannel(messenger, "youtube-player + $textureId")
                  val streamLinks = StreamLinks(audioLink= audioUrl,  videoLink = videoUrl, quality = quality!!);
                  val readyToPlay =  ExoPlayerIm.setUpPlayer(streamLinks = streamLinks, context = context!!, surfaceManager = surfaceManager, eventChannel = eventChannel)
                  result.success(mutableMapOf<String, Any>(
                      "readyToPlay" to readyToPlay
                  ));
              }


          }
          "videoQualityChange"-> {
              val quality:String? = call.argument<String>("quality")
              val videoUrl:String? = call.argument<String>("video")
              val audioUrl:String? = call.argument<String>("audio")
              val youtubeLink:String? = call.argument<String>("youtubeLink")
              if(youtubeLink != null){
                  YtExtractorClassSingleTonObject.instance.extractFun(youtubeLink, context!!, quality!!){
                      ExoPlayerIm.onVideoQualityChange(it)
                  }
              }else{
                  val streamLinks = StreamLinks(audioUrl, videoUrl, quality!!)
                  ExoPlayerIm.onVideoQualityChange(streamLinks)
              }


          }

//          else -> {
//              result.notImplemented()
//
//          }
      }

  }


}
