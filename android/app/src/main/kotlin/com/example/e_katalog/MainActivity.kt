package com.katalog.mebel

import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowInsetsController
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Mengatur agar tampilan menggunakan edge-to-edge
            window.setDecorFitsSystemWindows(false)
            val controller = window.insetsController
            controller?.systemBarsBehavior = 
                WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        } else {
            // Pengaturan untuk versi Android di bawah R (API 30)
            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
            )
        }
    }
}
