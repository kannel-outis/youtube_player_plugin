package kannel.outtis.youtube_player



data class EventError(
    val message:String?,
    val code:String?,
    val details:Any?
)

data class StreamLinks(
    val audioLink:String?,
    val videoLink:String?,
    val quality:String

)

