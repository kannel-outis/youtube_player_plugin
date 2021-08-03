package kannel.outtis.youtube_player

import android.content.ContentValues.TAG
import android.util.Log
import android.util.SparseArray
import at.huber.youtubeExtractor.YtFile
import at.huber.youtubeExtractor.VideoMeta
import at.huber.youtubeExtractor.YouTubeExtractor


object YtExtractorClassSingleTonObject{
    val instance = YtExtractorClass()
}

class YtExtractorClass{
    private var oldLink:String? = null
    private var resultLinks:SparseArray<YtFile>? = null
    private var links:StreamLinks? = null
    fun extractFun(youtubeLink:String, context:android.content.Context, quality:String): StreamLinks{
        var links:StreamLinks? = null
        if(oldLink != youtubeLink){
            Log.i(TAG, "Not Same link")
            oldLink = youtubeLink
            val ex = Ex(context, quality = quality){
                resultLinks = it
                links = getLinksFromExtractor(resultLinks!!, quality)
            }
                .extract(youtubeLink)
//            return links!!
                return links!!
        }else{
            Log.i(TAG, "Same link")

            if(resultLinks != null){
                links = getLinksFromExtractor(resultLinks!!, quality)
            }else{
                val ex = Ex(context, quality = quality){
                    resultLinks = it
                    links = getLinksFromExtractor(resultLinks!!, quality)
                }
                    .extract(youtubeLink)
            }
                return links!!
        }




    }


   private fun getLinksFromExtractor(ytFiles:SparseArray<YtFile>, quality:String):StreamLinks{
        var videoLink:String? = null
        var audioLink:String? = null

        when (quality) {
            "144p"-> {
                if (ytFiles.indexOfKey(278) > 0 ) {
                    Log.i(TAG, "Quality: 144p WEBM")
                    videoLink = ytFiles.get(278)!!.url
                } else {
                    Log.i(TAG, "Quality: 144p MP4")
                    videoLink = ytFiles.get(160)!!.url
                }
            }
            "240p"-> {
                if (ytFiles.indexOfKey(242) > 0) {
                    Log.i(TAG, "Quality: 240p WEBM")
                    videoLink = ytFiles.get(242)!!.url
                } else if (ytFiles.indexOfKey(133) > 0) {
                    Log.i(TAG, "Quality: 240p MP4")
                    videoLink = ytFiles.get(133)!!.url
                } else if (ytFiles.indexOfKey(278) > 0) {
                    Log.i(TAG, "Quality: 144p WEBM [Adapted]")
                    videoLink = ytFiles.get(278)!!.url
                } else {
                    Log.i(TAG, "Quality: 144p MP4 [Adapted]")
                    videoLink = ytFiles.get(160)!!.url
                }
            }
            "360p"-> {
                if (ytFiles.indexOfKey(243) > 0) {
                    Log.i(TAG, "Quality: 360p WEBM")
                    videoLink = ytFiles.get(243)!!.url
                } else if (ytFiles.indexOfKey(134) > 0) {
                    Log.i(TAG, "Quality: 360p MP4")
                    videoLink = ytFiles.get(134)!!.url
                } else if (ytFiles.indexOfKey(242) > 0) {
                    Log.i(TAG, "Quality: 240p WEBM [Adapted]")
                    videoLink = ytFiles.get(242)!!.url
                } else if (ytFiles.indexOfKey(133) > 0) {
                    Log.i(TAG, "Quality: 240p MP4 [Adapted]")
                    videoLink = ytFiles.get(133)!!.url
                } else if (ytFiles.indexOfKey(278) > 0) {
                    Log.i(TAG, "Quality: 144p WEBM [Adapted]")
                    videoLink = ytFiles.get(278)!!.url
                } else {
                    Log.i(TAG, "Quality: 144p MP4 [Adapted]")
                    videoLink = ytFiles.get(160)!!.url
                }
            }
            "480p"-> {
                if (ytFiles.indexOfKey(244) > 0) {
                    Log.i(TAG, "Quality: 480p WEBM")
                    videoLink = ytFiles.get(244)!!.url
                } else if (ytFiles.indexOfKey(135) > 0) {
                    Log.i(TAG, "Quality: 480p MP4")
                    videoLink = ytFiles.get(135)!!.url
                } else if (ytFiles.indexOfKey(243) > 0) {
                    Log.i(TAG, "Quality: 360p WEBM [Adapted]")
                    videoLink = ytFiles.get(243)!!.url
                } else if (ytFiles.indexOfKey(134) > 0) {
                    Log.i(TAG, "Quality: 360p MP4 [Adapted]")
                    videoLink = ytFiles.get(134)!!.url
                } else if (ytFiles.indexOfKey(242) > 0) {
                    Log.i(TAG, "Quality: 240p WEBM [Adapted]")
                    videoLink = ytFiles.get(242)!!.url
                } else if (ytFiles.indexOfKey(133) > 0) {
                    Log.i(TAG, "Quality: 240p MP4 [Adapted]")
                    videoLink = ytFiles.get(133)!!.url
                } else if (ytFiles.indexOfKey(278) > 0) {
                    Log.i(TAG, "Quality: 144p WEBM [Adapted]")
                    videoLink = ytFiles.get(278)!!.url
                } else {
                    Log.i(TAG, "Quality: 144p MP4 [Adapted]")
                    videoLink = ytFiles.get(160)!!.url
                }
            }
            "720p"-> {
                if (ytFiles.indexOfKey(247) > 0) {
                    Log.i(TAG, "Quality: 720p WEBM")
                    videoLink = ytFiles.get(247)!!.url
                } else if (ytFiles.indexOfKey(136) > 0) {
                    Log.i(TAG, "Quality: 720p MP4")
                    videoLink = ytFiles.get(136)!!.url
                } else if (ytFiles.indexOfKey(244) > 0) {
                    Log.i(TAG, "Quality: 480p WEBM [Adapted]")
                    videoLink = ytFiles.get(244)!!.url
                } else if (ytFiles.indexOfKey(135) > 0) {
                    Log.i(TAG, "Quality: 480p MP4 [Adapted]")
                    videoLink = ytFiles.get(135)!!.url
                } else if (ytFiles.indexOfKey(243) > 0) {
                    Log.i(TAG, "Quality: 360p WEBM [Adapted]")
                    videoLink = ytFiles.get(243)!!.url
                } else if (ytFiles.indexOfKey(134) > 0) {
                    Log.i(TAG, "Quality: 360p MP4 [Adapted]")
                    videoLink = ytFiles.get(134)!!.url
                } else if (ytFiles.indexOfKey(242) > 0) {
                    Log.i(TAG, "Quality: 240p WEBM [Adapted]")
                    videoLink = ytFiles.get(242)!!.url
                } else if (ytFiles.indexOfKey(133) > 0) {
                    Log.i(TAG, "Quality: 240p MP4 [Adapted]")
                    videoLink = ytFiles.get(133)!!.url
                } else if (ytFiles.indexOfKey(278) > 0) {
                    Log.i(TAG, "Quality: 144p WEBM [Adapted]")
                    videoLink = ytFiles.get(278)!!.url
                } else if (ytFiles.indexOfKey(160) > 0) {
                    Log.i(TAG, "Quality: 144p MP4 [Adapted]")
                    videoLink = ytFiles.get(160)!!.url
                } else {
                    Log.i(TAG, "Quality: 360p MP4 [Adapted]")
                    videoLink = ytFiles.get(18)!!.url
                }
            }
            "1080p"-> {
                if (ytFiles.indexOfKey(248) > 0) {
                    Log.i(TAG, "Quality: 1080p WEBM")
                    videoLink = ytFiles.get(248)!!.url
                } else if (ytFiles.indexOfKey(137) > 0) {
                    Log.i(TAG, "Quality: 1080p MP4")
                    videoLink = ytFiles.get(137)!!.url
                } else if (ytFiles.indexOfKey(247) > 0) {
                    Log.i(TAG, "Quality: 720p WEBM [Adapted")
                    videoLink = ytFiles.get(247)!!.url
                } else if (ytFiles.indexOfKey(136) > 0) {
                    Log.i(TAG, "Quality: 720p MP4 [Adapted]")
                    videoLink = ytFiles.get(136)!!.url
                } else if (ytFiles.indexOfKey(244) > 0) {
                    Log.i(TAG, "Quality: 480p WEBM [Adapted]")
                    videoLink = ytFiles.get(244)!!.url
                } else if (ytFiles.indexOfKey(135) > 0) {
                    Log.i(TAG, "Quality: 480p MP4 [Adapted]")
                    videoLink = ytFiles.get(135)!!.url
                } else if (ytFiles.indexOfKey(243) > 0) {
                    Log.i(TAG, "Quality: 360p WEBM [Adapted]")
                    videoLink = ytFiles.get(243)!!.url
                } else if (ytFiles.indexOfKey(134) > 0) {
                    Log.i(TAG, "Quality: 360p MP4 [Adapted]")
                    videoLink = ytFiles.get(134)!!.url
                } else if (ytFiles.indexOfKey(242) > 0) {
                    Log.i(TAG, "Quality: 240p WEBM [Adapted]")
                    videoLink = ytFiles.get(242)!!.url
                } else if (ytFiles.indexOfKey(133) > 0) {
                    Log.i(TAG, "Quality: 240p MP4 [Adapted]")
                    videoLink = ytFiles.get(133)!!.url
                } else if (ytFiles.indexOfKey(278) > 0) {
                    Log.i(TAG, "Quality: 144p WEBM [Adapted]")
                    videoLink = ytFiles.get(278)!!.url
                } else {
                    Log.i(TAG, "Quality: 144p MP4 [Adapted]")
                    videoLink = ytFiles.get(160)!!.url
                }
            }else->{
            videoLink = ytFiles.get(247)!!.url

        }
        }
        audioLink = ytFiles.get(140)!!.url
        return StreamLinks(audioLink = audioLink, videoLink = videoLink)
    }




}



    private class Ex (context:android.content.Context,val quality:String, val funct: (SparseArray<YtFile>)-> Unit): YouTubeExtractor(context){



        var extractionComplete:Boolean = false;
        var streamLinks:StreamLinks? = null
        var ytFiless:SparseArray<YtFile>? = null
        override fun onExtractionComplete(ytFiles: SparseArray<YtFile>?, videoMeta: VideoMeta?) {
            if (ytFiles != null) {
                ytFiless = ytFiles
//                Log.d(TAG, ytFiles.size().toString() + ":::::::::::::::::::::::::::::::::::::");
                funct(ytFiles)

            }
        }


}

