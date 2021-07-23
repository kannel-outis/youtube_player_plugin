package kannel.outtis.youtube_player

import android.graphics.SurfaceTexture
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.view.TextureRegistry

class SurfaceTextureManagerClass( private val binding: FlutterPlugin.FlutterPluginBinding) {

     private var surfaceEntry: TextureRegistry.SurfaceTextureEntry? = null

    private var surfaceTexture: SurfaceTexture? = null

    fun getSurfaceEntry():TextureRegistry.SurfaceTextureEntry{
        return surfaceEntry!!
    }

    fun getSurfaceTexture():SurfaceTexture{
        return surfaceTexture!!
    }

    fun initSurface():Long{
        surfaceEntry = binding.textureRegistry.createSurfaceTexture()
        surfaceTexture = surfaceEntry!!.surfaceTexture()

        return surfaceEntry!!.id()

    }

    fun dispose():Unit{
        if(surfaceEntry != null){
            surfaceEntry!!.release()
            surfaceEntry = null
            surfaceTexture!!.release()
            surfaceTexture = null

        }
    }

}