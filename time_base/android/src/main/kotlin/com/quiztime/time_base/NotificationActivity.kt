package com.quiztime.time_base

import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.content.SharedPreferences
import android.os.Handler

class NotificationActivity : Activity() {
    var open=false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_notification)
//        window?.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN)
        window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        window?.setStatusBarColor(Color.TRANSPARENT)
//        val taskInfo = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//        val list = taskInfo.appTasks
//        NotificationCall.clickNotificationCall(intent,list.size==1)
//        if(list.size==1){
//            val intent = packageManager.getLaunchIntentForPackage(mApplicationContext.packageName)
//            startActivity(intent)
//        }


//        Handler().postDelayed({
//            val pages=getSharedPreferences("quiztime",Context.MODE_PRIVATE).getInt("page",0)
//            NotificationCall.clickNotificationCall(intent,list.pages<=1)
//            if(pages<=1){
//                val intent = packageManager.getLaunchIntentForPackage(mApplicationContext.packageName)
//                startActivity(intent)
//            }
//            finish()
//        },500)

    }


    override fun onStart(){
        super.onStart()
        if(!open){
            val pages=getSharedPreferences("quiztime",Context.MODE_PRIVATE).getInt("page",0)
            NotificationCall.clickNotificationCall(intent,pages<=1)
            if(pages<=1){
                val intent = packageManager.getLaunchIntentForPackage(mApplicationContext.packageName)
                startActivity(intent)
            }
            finish()
        }
        open=true
    }
}