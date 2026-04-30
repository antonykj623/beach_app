package com.beach.beach_app




import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.app/storage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            val prefs: SharedPreferences =
                getSharedPreferences("MyPrefs", Context.MODE_PRIVATE)

            when (call.method) {

                "setValue" -> {
                    val key = call.argument<String>("key")
                    val value = call.argument<String>("value")

                    prefs.edit().putString(key, value).apply()
                    result.success(true)
                }

                "getValue" -> {
                    val key = call.argument<String>("key")
                    val value = prefs.getString(key, null)
                    result.success(value)
                }

                else -> result.notImplemented()
            }
        }
    }
}
