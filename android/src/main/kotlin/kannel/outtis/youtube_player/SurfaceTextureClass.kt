package kannel.outtis.youtube_player

import android.graphics.SurfaceTexture
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.view.TextureRegistry

class SurfaceTextureManagerClass( private val binding: FlutterPlugin.FlutterPluginBinding) {
    private var textureRegistry:TextureRegistry? = null

     private var surfaceEntry: TextureRegistry.SurfaceTextureEntry? = null

    private var surfaceTexture: SurfaceTexture? = null

    fun getSurfaceEntry():TextureRegistry.SurfaceTextureEntry{
        return surfaceEntry!!
    }

    fun getsurfaceTexture():SurfaceTexture{
        return surfaceTexture!!
    }

    fun initState(width:Double,  height: Double):Long{
        textureRegistry = binding.textureRegistry
        surfaceEntry = textureRegistry!!.createSurfaceTexture()
        surfaceTexture = surfaceEntry!!.surfaceTexture()
        surfaceTexture!!.setDefaultBufferSize(width.toInt(), height.toInt())

        return surfaceEntry!!.id()

    }

    fun dispose():Unit{
        if(surfaceEntry != null && textureRegistry != null){
            surfaceEntry!!.release()
            surfaceEntry = null
            textureRegistry = null

        }
    }

}