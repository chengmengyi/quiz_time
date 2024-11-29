package com.quiztime.time_base
import android.content.Intent
import io.flutter.plugin.common.MethodChannel

object NotificationCall {
    var notificationId:Int?=null
    private var channel : MethodChannel?=null

    fun setChannel(channel : MethodChannel){
        this.channel=channel
    }

    fun clickNotificationCall(intent: Intent?,launch:Boolean){
        if(TimeQuizData.workManagerNotificationAction==intent?.action||TimeQuizData.foregroundNotificationAction==intent?.action){
            val map = HashMap<String, Int>()
            notificationId = intent?.extras?.getInt("notificationId") ?: 0
            map["notificationId"] = notificationId?:0
            if(!launch){
                channel?.invokeMethod("clickNotification", map)
                notificationId=null
            }
        }
    }
}