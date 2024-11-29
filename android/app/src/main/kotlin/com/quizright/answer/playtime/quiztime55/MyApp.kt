package com.quizright.answer.playtime.quiztime55

import io.flutter.app.FlutterApplication
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.util.Log


class MyApp:FlutterApplication() {
    private var pages = 0
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(object : ActivityLifecycleCallbacks{
            override fun onActivityCreated(p0: Activity, p1: Bundle?) {

            }

            override fun onActivityStarted(p0: Activity) {
                pages++
                getSharedPreferences("quiztime",Context.MODE_PRIVATE).edit().apply {
                    putInt("page", pages)
                    apply()
                }
            }

            override fun onActivityResumed(p0: Activity) {

            }

            override fun onActivityPaused(p0: Activity) {

            }

            override fun onActivityStopped(p0: Activity) {
                pages--
                getSharedPreferences("quiztime",Context.MODE_PRIVATE).edit().apply {
                    putInt("page", pages)
                    apply()
                }
            }

            override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {

            }

            override fun onActivityDestroyed(p0: Activity) {

            }

        })
    }
}