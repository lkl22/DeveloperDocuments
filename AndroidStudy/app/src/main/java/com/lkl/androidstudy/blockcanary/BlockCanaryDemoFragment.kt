package com.lkl.androidstudy.blockcanary

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.annotation.Nullable
import androidx.fragment.app.Fragment
import com.lkl.androidstudy.R
import java.io.FileInputStream
import java.io.IOException


class BlockCanaryDemoFragment: Fragment(), View.OnClickListener {
    companion object {
        private const val TAG = "BlockCanaryDemoFragment"

        fun newInstance(): BlockCanaryDemoFragment {
            return BlockCanaryDemoFragment()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    @Nullable
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_block_canary_demo, null)
    }

    override fun onViewCreated(view: View, @Nullable savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val button1: Button = view.findViewById<View>(R.id.button1) as Button
        val button2: Button = view.findViewById<View>(R.id.button2) as Button
        val button3: Button = view.findViewById<View>(R.id.button3) as Button
        button1.setOnClickListener(this)
        button2.setOnClickListener(this)
        button3.setOnClickListener(this)
    }

    override fun onDestroyView() {
        super.onDestroyView()
    }

    override fun onActivityCreated(@Nullable savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.button1 -> try {
                Thread.sleep(2000)
            } catch (e: InterruptedException) {
                e.printStackTrace()
                Log.e(TAG, "onClick of R.id.button1: ", e)
            }
            R.id.button2 -> {
                var i = 0
                while (i < 100) {
//                    readFile()
                    ++i
                }
            }
            R.id.button3 -> {
                val result = compute()
                println(result)
            }
            else -> {
            }
        }
    }

    private fun compute(): Double {
        var result = 0.0
        for (i in 0..999999) {
            result += Math.acos(Math.cos(i.toDouble()))
            result -= Math.asin(Math.sin(i.toDouble()))
        }
        return result
    }

    private fun readFile() {
        var reader: FileInputStream? = null
        try {
            reader = FileInputStream("/proc/stat")
            while (reader.read() !== -1);
        } catch (e: IOException) {
            Log.e(TAG, "readFile: /proc/stat", e)
        } finally {
            if (reader != null) {
                try {
                    reader.close()
                } catch (e: IOException) {
                    Log.e(TAG, " on close reader ", e)
                }
            }
        }
    }
}