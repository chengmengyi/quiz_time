package com.quiztime.time_base

import android.util.Log
import androidx.annotation.NonNull
import androidx.work.Worker
import androidx.work.WorkerParameters
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import org.json.JSONObject
import java.io.IOException
import java.util.*

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat


class TimeQuizWork(context: Context, workerParams: WorkerParameters,):Worker(context, workerParams){
    override fun doWork(): Result {
//        NotificationManager.createTaskNotification(id,title, desc, btn)
//        uploadTba(inputData.getString("tbaUrl")?:"",inputData.getString("tbaHeader")?:"",inputData.getString("tbaParams")?:"")

        createNotification()
        return Result.success()
    }

    @SuppressLint("MissingPermission")
    private fun createNotification(){
        val id = inputData.getInt("notificationId",0)
        val notificationContent = inputData.getStringArray("notificationContent")?: arrayOf("Get paid for every answer you provide—cash out anytime!","Sign up in minutes and start earning right away!","Huge Rewards are waiting for you! come and claim it!")
        val notificationBtn = inputData.getString("notificationBtn")?:"Withdraw"
        val isB=inputData.getBoolean("notificationB",false)
//        val intent = mApplicationContext.packageManager.getLaunchIntentForPackage(mApplicationContext.packageName)?.apply {
//            action=TimeQuizData.workManagerNotificationAction
//            putExtra("notificationId",id)
//        }


        val intent=Intent(mApplicationContext,NotificationActivity::class.java).apply {
            action=TimeQuizData.workManagerNotificationAction
            putExtra("notificationId",id)
        }

        val pendingIntent = if (VERSION.SDK_INT >= VERSION_CODES.S) {
            PendingIntent.getActivity(mApplicationContext, id, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        }else{
            PendingIntent.getActivity(mApplicationContext, id, intent, PendingIntent.FLAG_ONE_SHOT)
        }

        val notificationLayout = RemoteViews(mApplicationContext.packageName, R.layout.time_quiz_notification_layout)
        notificationLayout.setTextViewText(R.id.notificationContent,notificationContent.random())
        notificationLayout.setTextViewText(R.id.notificationBtn,notificationBtn)
        notificationLayout.setImageViewResource(R.id.notificationB,if(isB) R.drawable.noti_money_icon else R.drawable.noti_coins_icon)

        val notification = NotificationCompat.Builder(mApplicationContext, createNotificationChannel(
            "time_quiz_$id",
            "time_quiz_$id",
            NotificationManager.IMPORTANCE_MAX
        )?:"time_quiz_$id")
            .setSmallIcon(R.drawable.logoooo)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(notificationLayout)
            .setCustomHeadsUpContentView(notificationLayout)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
        val notificationManager = NotificationManagerCompat.from(mApplicationContext)
        notificationManager.notify(id, notification.build())
    }

    private fun createNotificationChannel(channelID: String, channelNAME: String, level: Int)=if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val manager = mApplicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager?
        val channel = NotificationChannel(channelID, channelNAME, level)
        manager!!.createNotificationChannel(channel)
        channelID
    } else {
        null
    }
}