package kannel.outtis.youtube_player;

import android.net.Uri
import android.util.Log
import android.view.Surface
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.source.MediaSource
import com.google.android.exoplayer2.source.MergingMediaSource
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DataSource
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource
import com.google.android.exoplayer2.upstream.DefaultHttpDataSourceFactory
import com.google.android.exoplayer2.video.VideoSize
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class ExoPlayerIm {

    companion object{
       private var exoplayer:SimpleExoPlayer? = null
        private val eventSink:EventSink = EventSink()
        private var readyToPlay:Boolean = false

        fun getExoPlayerInstance():SimpleExoPlayer{
            return exoplayer!!
        }

         fun setUpPlayer(videoUrl:String, audioUrl:String, context:android.content.Context, surfaceManager:SurfaceTextureManagerClass, eventChannel: EventChannel): Boolean{

            exoplayer =  SimpleExoPlayer.Builder(context).build()
            val dataSourceFactory: DataSource.Factory = DefaultHttpDataSource.Factory()
            val vUri = Uri.parse(videoUrl)
            val aUri  = Uri.parse(audioUrl)
            val vSource: ProgressiveMediaSource = ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(
                MediaItem.fromUri(vUri))
            val aSource: ProgressiveMediaSource = ProgressiveMediaSource.Factory(dataSourceFactory).createMediaSource(
                MediaItem.fromUri(aUri))
            val mediaSource: MediaSource = MergingMediaSource(vSource, aSource)
            exoplayer!!.prepare(mediaSource)
             readyToPlay = true
             exoplayer!!.addListener(
                 ListenerF()
             )
             eventChannel.setStreamHandler(
               object :  EventChannel.StreamHandler{
                   override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                       if(events != null )eventSink.setEventSinkAndReset(events)

                   }

                   override fun onCancel(arguments: Any?) {
                       eventSink.setEventSinkAndReset(null)
                   }

               }
             )
            val surface: Surface = Surface(surfaceManager.getSurfaceTexture())
            exoplayer!!.setVideoSurface(surface)
//            exoplayer!!.playWhenReady = readyToPlay

             return readyToPlay;
        }

        fun dispose():Unit{
            if(exoplayer == null)return
            exoplayer!!.stop()
            exoplayer!!.release()
            exoplayer = null
        }


        fun controlMethodCall(call: MethodCall, result:Result): Unit{
            val status:MutableMap<String, String> = HashMap<String, String>()
            when(call.method){
                "play"->{
                    if(exoplayer != null){
                        exoplayer!!.play()
                        status["status"] = "playing"
                        result.success(status)
                    }

                }
                "pause"->{
                    if(exoplayer != null){
                        exoplayer!!.pause()
                        status["status"] = "paused"
                        result.success(status)
                    }

                }
                "stop"->{
                    if(exoplayer != null){
                        exoplayer!!.stop()
                        status["status"] = "stopped"
                        result.success(status)
                    }
                }
                "seekTo"->{
                    if(exoplayer != null){
                        val  duration:Long = call.argument<Long>("duration")!!
                        exoplayer!!.seekTo(duration)
                    }
                }
                "position"->{
                    result.success(exoplayer!!.contentPosition)
                }
                "bufferedPosition"->{
                    result.success(exoplayer!!.bufferedPosition)
                }

            }
        }




        private class ListenerF() : Player.Listener{





            override fun onPlaybackStateChanged(state: Int) {
                val event: MutableMap<String, Any> = HashMap()
                when(state){
                    Player.STATE_READY -> {
//                            readyToPlay = true
                        event["statusEvent"] = mapOf("playerStatus" to "state_ready")
                        event["playerReady"] = readyToPlay
                        event["duration"] = exoplayer!!.duration

                    }
                    Player.STATE_ENDED -> {
                       readyToPlay = false
                        event["statusEvent"] = mapOf("playerStatus" to "state_ended")
                        event["playerReady"] = readyToPlay

                    }
                    Player.STATE_BUFFERING -> {
                        event["statusEvent"] = mapOf("playerStatus" to "state_buffering")
                        event["playerReady"] = false
                        event["percentageBuffered"] = exoplayer!!.bufferedPercentage
                        Log.d("bufferingData", exoplayer!!.bufferedPercentage.toString())
                    }

                    Player.STATE_IDLE -> {
                        event["statusEvent"] = mapOf("playerStatus" to "state_idle")
                    }
                }



                eventSink.success(event)



            }

            override fun onVideoSizeChanged(videoSize: VideoSize): Unit{
                val event: MutableMap<String, Any> = HashMap()
                event["width"] = videoSize.width
                event["height"] = videoSize.height
                event["pixelWidthHeightRatio"]=videoSize.pixelWidthHeightRatio
                eventSink.success(event)
            }



        }




    }
}


