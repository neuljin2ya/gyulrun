package com.example.gyulrun

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "gyulrun/gallery"
        ).setMethodCallHandler { call, result ->
            if (call.method != "saveImage") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val bytes = call.arguments as? ByteArray
            if (bytes == null) {
                result.error("invalid_image", "Invalid image bytes", null)
                return@setMethodCallHandler
            }

            try {
                result.success(saveImage(bytes))
            } catch (error: Exception) {
                result.error("save_failed", error.localizedMessage, null)
            }
        }
    }

    private fun saveImage(bytes: ByteArray): Boolean {
        val fileName = "gyulrun_${System.currentTimeMillis()}.png"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
                put(MediaStore.Images.Media.MIME_TYPE, "image/png")
                put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + "/GyulRun")
                put(MediaStore.Images.Media.IS_PENDING, 1)
            }
            val uri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
                ?: return false
            contentResolver.openOutputStream(uri)?.use { output ->
                output.write(bytes)
            } ?: return false
            values.clear()
            values.put(MediaStore.Images.Media.IS_PENDING, 0)
            contentResolver.update(uri, values, null, null)
            return true
        }

        val picturesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        val gyulRunDir = File(picturesDir, "GyulRun")
        if (!gyulRunDir.exists()) gyulRunDir.mkdirs()
        val imageFile = File(gyulRunDir, fileName)
        FileOutputStream(imageFile).use { output ->
            output.write(bytes)
        }
        val values = ContentValues().apply {
            put(MediaStore.Images.Media.DATA, imageFile.absolutePath)
            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
        }
        contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
        return true
    }
}
