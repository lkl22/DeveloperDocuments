package com.lkl.androidstudy.blockcanary

import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.lkl.androidstudy.R


class BlockCanaryDemoActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_block_canary_demo)
        supportFragmentManager.beginTransaction()
            .add(R.id.container, BlockCanaryDemoFragment.newInstance())
            .commit()
        val fab = findViewById<View>(R.id.fab) as FloatingActionButton
        fab.setOnClickListener { showTipDialog() }
    }

    private fun showTipDialog() {
        val builder: AlertDialog.Builder = AlertDialog.Builder(this)
        builder.setTitle("Tip")
        builder.setMessage(resources.getString(R.string.hello_world))
        builder.setNegativeButton("ok", null)
        builder.show()
    }
}