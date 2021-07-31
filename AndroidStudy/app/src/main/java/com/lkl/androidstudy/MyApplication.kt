package com.lkl.androidstudy

import android.app.Application
import com.github.moduth.blockcanary.BlockCanary
import com.lkl.androidstudy.blockcanary.AppBlockCanaryContext


class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Do it on main process
        BlockCanary.install(this, AppBlockCanaryContext()).start()
    }
}