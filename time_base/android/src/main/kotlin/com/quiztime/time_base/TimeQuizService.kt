package com.quiztime.time_base

import android.app.*
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.widget.RemoteViews
import androidx.annotation.RequiresApi

class TimeQuizService : Service(){
    private val serviceId=33
    private val channelId = "wordlang_ForegroundService_channelId"
    private val channelName = "wordlang_ForegroundService_channelName"
    private val channelDesc = "wordlang_ForegroundService_channelDesc"

    override fun onBind(p0: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        initForegroundService(intent)
        return START_STICKY
    }

    private fun initForegroundService(intent: Intent?) {
        createNotificationChannel()
        val notification = initServiceNotification(intent)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                serviceId,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST
            )
        } else {
            startForeground(serviceId, notification)
        }
    }

    private fun initServiceNotification(intent: Intent?): Notification {
        val serviceNotificationId = intent?.getIntExtra("serviceNotificationId", 0)?:0
        val isB = intent?.getBooleanExtra("notificationB",false)?:false
        val serviceNotificationTitle = intent?.getStringExtra("serviceNotificationTitle")?:""
        val serviceNotificationMoney = intent?.getStringExtra("serviceNotificationMoney")?:""


        val intent = mApplicationContext.packageManager.getLaunchIntentForPackage(mApplicationContext.packageName)?.apply {
            action=TimeQuizData.workManagerNotificationAction
            putExtra("notificationId",serviceNotificationId)
        }
        val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.getActivity(mApplicationContext, 10001, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        }else{
            PendingIntent.getActivity(mApplicationContext, 10001, intent, PendingIntent.FLAG_ONE_SHOT)
        }


        val notificationLayout = RemoteViews(mApplicationContext.packageName, R.layout.time_quiz_service_notification_layout)
        notificationLayout.setTextViewText(R.id.serviceNotificationTitle,serviceNotificationTitle)
        notificationLayout.setTextViewText(R.id.serviceNotificationMoney,serviceNotificationMoney)
        notificationLayout.setImageViewResource(R.id.notificationB,if(isB) R.drawable.icon_m else R.drawable.icon_c)

        val builder = createBuilder(pendingIntent,notificationLayout)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            builder.setForegroundServiceBehavior(Notification.FOREGROUND_SERVICE_IMMEDIATE)
        }
        return builder.build()
    }

    private fun createBuilder(pendingIntent: PendingIntent,notificationLayout: RemoteViews): Notification.Builder {
        val builder = Notification.Builder(this, channelId)
        builder.setOngoing(true)
        builder.setShowWhen(false)
        builder.setSmallIcon(R.drawable.logoooo)
        builder.setContentIntent(pendingIntent)
        builder.setCustomContentView(notificationLayout)
        builder.setCustomHeadsUpContentView(notificationLayout)
        builder.setCustomBigContentView(notificationLayout)
//        builder.setCustomContentView(notificationLayout)
//        builder.setCustomHeadsUpContentView(notificationLayout)
//        builder.style = Notfication.BigTextStyle()
        builder.setVisibility(Notification.VISIBILITY_PUBLIC)
        return builder
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel() {
        val nm = getSystemService(NotificationManager::class.java)
        if (nm.getNotificationChannel(channelId) == null) {
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW).apply {
                if (channelDesc != null) {
                    description = channelDesc
                }
                enableVibration(false)
            }
            nm.createNotificationChannel(channel)
        }
    }
}