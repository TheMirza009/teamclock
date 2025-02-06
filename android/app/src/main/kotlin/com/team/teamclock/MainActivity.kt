package com.team.teamclock

import android.content.Intent
import android.os.Bundle
import android.provider.AlarmClock
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val ALARM_SETTINGS_CHANNEL = "com.team.teamclock/alarmsettings"
    private val NAVIGATION_CHANNEL = "com.team.teamclock/navigation"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_SETTINGS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openAlarmSettings") {
                try {
                    val intent = Intent(AlarmClock.ACTION_SHOW_ALARMS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Could not open alarm settings.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val alarmId = intent?.extras?.getString("alarmId")
        if (alarmId != null) {
            flutterEngine?.let { engine ->
                MethodChannel(engine.dartExecutor.binaryMessenger, NAVIGATION_CHANNEL)
                    .invokeMethod("navigateToAlarm", alarmId) // This calls Flutter
                    .also {
                        println("Alarm ID sent to Flutter: $alarmId")
                    }
            }
        } else {
            println("No alarmId found in intent extras.")
        }
    }

}

