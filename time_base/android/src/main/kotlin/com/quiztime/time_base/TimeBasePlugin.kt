package com.quiztime.time_base

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
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

import android.annotation.SuppressLint
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat



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
    mApplicationContext=flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "time_base")
    NotificationCall.setChannel(channel)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    this.result=result
    when(call.method){
      "checkTimeQuizHasNotificationPer"-> checkTimeQuizHasNotificationPer()
      "requestTimeQuizNotificationPer" -> requestTimeQuizNotificationPer()
      "getLaunchNotificationId"->getLaunchNotificationId()
      "startTimeQuizWork"->startQuizTimeWork(call)
      "startTimeQuizService"->startTimeQuizService(call)
//      "toNotificationSetting"->toNotificationSetting()
      "showUrlByBrowser"->showUrlByBrowser(call)
      "showOnceNotification"->showOnceNotification(call)
    }
  }

  private fun startQuizTimeWork(call: MethodCall) {
    call.arguments?.let {
      runCatching {
        WorkManager.getInstance(mApplicationContext).cancelAllWork()

        val map = it as? Map<*, *>
        val timer = (map?.get("repeatIntervalMinutes") as? Int) ?: 0

        val builder = getWorkBuilder(map)
        val constraints = Constraints.Builder()
          .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
          .setRequiresBatteryNotLow(true).build()

        val periodicWorkRequest = PeriodicWorkRequest
          .Builder(TimeQuizWork::class.java, if(timer<15) 15 else timer.toLong(), TimeUnit.MINUTES)
          .setConstraints(constraints)
          .setInputData(builder)
          .build()
        WorkManager.getInstance(mApplicationContext).enqueueUniquePeriodicWork("startQuizTimeWork",ExistingPeriodicWorkPolicy.KEEP,periodicWorkRequest)
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
          100
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
    result.success(NotificationCall.notificationId)
    NotificationCall.notificationId=null
//    if(null!=mActivity){
//      val intent = mActivity?.intent
//      if(null!=intent&&(TimeQuizData.workManagerNotificationAction==intent.action||TimeQuizData.foregroundNotificationAction==intent.action)){
//        result.success(intent.extras?.getInt("notificationId")?:0)
//      }else{
//        result.success(null)
//      }
//    }else{
//      result.success(null)
//    }
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

//  private fun toNotificationSetting(){
//    val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
//    mApplicationContext.startActivity(intent)
//  }

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
    if(requestCode==100){
      var permission=Manifest.permission.POST_NOTIFICATIONS
      val permissionIndex = permissions.indexOf(permission)
      if (permissionIndex >= 0 && grantResults[permissionIndex] == PackageManager.PERMISSION_GRANTED) {
        permissionStatus = true
      } else {
        if (mActivity?.shouldShowRequestPermissionRationale(permission) == false) {
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

  private fun showUrlByBrowser(call: MethodCall){
    call.arguments?.let {
      runCatching {
        val map = it as? Map<*, *>
        val url=(map?.get("url") as? String)?:""
        var intent = if (url.startsWith("intent")) {
          Intent.parseUri(url, Intent.URI_INTENT_SCHEME)
        } else {
          Intent("android.intent.action.VIEW", Uri.parse(url))
        }
        if (intent != null) {
          if ("huawei".equals(Build.MANUFACTURER, ignoreCase = true)) {
            intent.setPackage(getHwBrowser())
          }
          intent.addCategory(Intent.CATEGORY_BROWSABLE)
          intent.component = null
          intent.flags = FLAG_ACTIVITY_NEW_TASK
        }
        mApplicationContext.startActivity(intent)
      }
    }
  }

  private fun showOnceNotification(call: MethodCall){
    call.arguments?.let {
      runCatching {
        val map = it as? Map<*, *>
        val list = (map?.get("notificationContent") as? ArrayList<String>)?: arrayListOf()
        val notificationId=(map?.get("notificationId") as? Int)?:0
        val notificationB=(map?.get("notificationB") as? Boolean)?:false
        val notificationBtn=(map?.get("notificationBtn") as? String)?:""
        createNotification(notificationId,notificationB,notificationBtn,list)
      }
    }
  }

  fun getHwBrowser(): String? {
    var packageName: String? = null
    var systemApp: String? = null
    var userApp: String? = null
    val userAppList: MutableList<String?> = ArrayList()
    val browserIntent = Intent("android.intent.action.VIEW", Uri.parse("https://"))
    val resolveInfo =
      mApplicationContext.packageManager.resolveActivity(browserIntent, PackageManager.MATCH_DEFAULT_ONLY)
    if (resolveInfo != null && resolveInfo.activityInfo != null) {
      packageName = resolveInfo.activityInfo.packageName
    }
    if (packageName == null || packageName == "android") {
      val lists = mApplicationContext.packageManager.queryIntentActivities(browserIntent, 0)
      for (app in lists) {
        if (app.activityInfo.flags and ApplicationInfo.FLAG_SYSTEM != 0) {
          systemApp = app.activityInfo.packageName
        } else {
          userApp = app.activityInfo.packageName
          userAppList.add(userApp)
        }
      }
      if (userAppList.contains("com.android.chrome")) {
        packageName = "com.android.chrome"
      } else {
        if (systemApp != null) {
          packageName = systemApp
        }
        if (userApp != null) {
          packageName = userApp
        }
      }
    }
    return packageName
  }

  @SuppressLint("MissingPermission")
  private fun createNotification(id:Int,isB:Boolean,notificationBtn:String,notificationContent:ArrayList<String>){
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
