package com.lkl.androidstudy

import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.lkl.androidstudy.blockcanary.BlockCanaryDemoActivity
import com.lkl.androidstudy.navigation.NavigationActivity
import com.lkl.media.record.RecordActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun navigationBtnClick(view: View) {
        startActivity(Intent(this, NavigationActivity::class.java))
    }

    fun recordBtnClick(view: View) {
        startActivity(Intent(this, RecordActivity::class.java))
    }

    fun blockCanaryBtnClick(view: View) {
        startActivity(Intent(this, BlockCanaryDemoActivity::class.java))
    }
}