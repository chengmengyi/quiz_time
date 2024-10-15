package com.quiztime.time_base

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.work.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject
import java.util.ArrayList
import java.util.concurrent.TimeUnit


lateinit var mApplicationContext: Context

/** TimeBasePlugin */
class TimeBasePlugin: FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener, ActivityAware,PluginRegistry.RequestPermissionsResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var mActivity: Activity?=null
  private lateinit var result: MethodChannel.Result

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "time_base")
    channel.setMethodCallHandler(this)
    mApplicationContext=flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    this.result=result
    when(call.method){
      "checkTimeQuizHasNotificationPer"-> checkTimeQuizHasNotificationPer()
      "requestTimeQuizNotificationPer" -> requestTimeQuizNotificationPer()
      "getLaunchNotificationId"->getLaunchNotificationId()
      "startTimeQuizWork"->startQuizTimeWork(call)
      "startTimeQuizService"->startTimeQuizService(call)
    }
  }

  private fun startQuizTimeWork(call: MethodCall) {
    call.arguments?.let {
      runCatching {
        WorkManager.getInstance(mApplicationContext).cancelAllWork()

        val map = it as? Map<*, *>
        val test = map?.get("test") as? Boolean

        val builder = getWorkBuilder(map)
        val constraints = Constraints.Builder()
          .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
          .setRequiresBatteryNotLow(true).build()

        if(test==true){
          val workRequest=OneTimeWorkRequest
            .Builder(TimeQuizWork::class.java)
            .setConstraints(constraints)
            .setInitialDelay(20000,TimeUnit.MILLISECONDS)
            .setInputData(builder)
            .build()
          WorkManager.getInstance(mApplicationContext).enqueue(workRequest)
        }else{
          val periodicWorkRequest = PeriodicWorkRequest
            .Builder(TimeQuizWork::class.java, 5, TimeUnit.HOURS)
            .setConstraints(constraints)
            .setInputData(builder)
            .build()
          WorkManager.getInstance(mApplicationContext).enqueue(periodicWorkRequest)
        }
      }
    }
  }

  private fun getWorkBuilder(map:Map<*, *>?): Data {
    val list = (map?.get("notificationContent") as? ArrayList<String>)?: arrayListOf()
    val array = list.toTypedArray().toList().toTypedArray()
    return Data.Builder()
      .putInt("notificationId",(map?.get("notificationId") as? Int)?:0)
      .putBoolean("notificationB",(map?.get("notificationB") as? Boolean)?:false)
      .putStringArray("notificationContent",array)
      .putString("notificationBtn",(map?.get("notificationBtn") as? String)?:"")
//    .putString("tbaUrl",(map?.get("tbaUrl") as? String)?:"")
//    .putString("tbaHeader",getStrByMap((map?.get("tbaHeader") as? Map<String, Any>)?: hashMapOf()))
//    .putString("tbaParams",getStrByMap((map?.get("tbaParams") as? Map<String, Any>)?: hashMapOf()))
      .build()
  }


  private fun requestTimeQuizNotificationPer(){
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
      result.success(true)
    }else{
      mActivity?.let {
        ActivityCompat.requestPermissions(
          it,
          arrayOf(Manifest.permission.POST_NOTIFICATIONS),
          TimeQuizData.requestNotificationPermissionCallResult
        )
      }
    }
  }

  private fun checkTimeQuizHasNotificationPer(){
    mActivity?.let {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
        result.success(true)
      }else{
        if (ContextCompat.checkSelfPermission(it, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
          result.success(true)
        } else {
          result.success(false)
        }
      }
    }
  }

  private fun getLaunchNotificationId(){
    if(null!=mActivity){
      val intent = mActivity?.intent
      val fromHistory=intent != null && intent.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY== Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
      if(null!=intent&&(TimeQuizData.workManagerNotificationAction==intent.action||TimeQuizData.foregroundNotificationAction==intent.action)&&!fromHistory){
        result.success(intent.extras?.getInt("notificationId")?:0)
      }else{
        result.success(null)
      }
    }else{
      result.success(null)
    }
  }

  private fun startTimeQuizService(call: MethodCall){
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
      val map = call.arguments as? Map<*, *>
      val nIntent = Intent(mApplicationContext, TimeQuizService::class.java)
      nIntent.putExtra("serviceNotificationId",(map?.get("serviceNotificationId") as? Int)?:0)
      nIntent.putExtra("serviceNotificationTitle",(map?.get("serviceNotificationTitle") as? String)?:"")
      nIntent.putExtra("serviceNotificationMoney",(map?.get("serviceNotificationMoney") as? String)?:"")
      nIntent.putExtra("notificationB",(map?.get("notificationB") as? Boolean)?:false)
      ContextCompat.startForegroundService(mApplicationContext, nIntent)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onNewIntent(p0: Intent): Boolean {
    if(TimeQuizData.workManagerNotificationAction==p0.action||TimeQuizData.foregroundNotificationAction==p0.action){
      val map = HashMap<String, Int>()
      map["notificationId"] = p0.extras?.getInt("notificationId")?:0
      channel.invokeMethod("clickNotification", map)
      return true
    }
    return false
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    binding.addRequestPermissionsResultListener(this)
    mActivity=binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    binding.addRequestPermissionsResultListener(this)
    mActivity=binding.activity
  }

  override fun onDetachedFromActivity() {
    mActivity=null
  }

  override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
    if(grantResults.isEmpty()){
      result.success(false)
      return false
    }
    var permissionStatus = false
    if(requestCode==TimeQuizData.requestNotificationPermissionCallResult){
      val permissionIndex = permissions.indexOf(Manifest.permission.POST_NOTIFICATIONS)
      if (permissionIndex >= 0 && grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED) {
        permissionStatus = true
      } else {
        if (mActivity?.shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS) == false) {
          permissionStatus = false
        }
      }
      result.success(permissionStatus)
    }else{
      return false
    }
    return true
  }

  private fun getStrByMap(map:Map<String, Any>):String{
    runCatching {
      return JSONObject(map).toString()
    }
    return ""
  }
}
