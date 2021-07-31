package com.lkl.media.record;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.graphics.PixelFormat;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.lkl.media.R;
import com.tbruyelle.rxpermissions3.RxPermissions;

public class RecordActivity extends AppCompatActivity {
    private static final String TAG = "RecordActivity";

    private LinearLayout linearLayout = null;
    private Button buttonRecord = null;
    private Button buttonCapture = null;
    private boolean isRecord = false;
    private int mScreenWidth;
    private int mScreenHeight;
    private int mScreenDensity;
    private WindowManager windowManager;
    private View floatWindowView;
    private RxPermissions rxPermissions;
    private Button bt_play;
    private float lastX;
    private float lastY;
    private float mTouchStartX;
    private float mTouchStartY;
    /**
     * 浮动窗原始位置
     */
    private float startPositionX = 0;
    private float startPositionY = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_record);

        rxPermissions = new RxPermissions(this);
        getScreenBaseInfo();
        initView();
        initClick();

    }

    @Override
    protected void onStart() {
        super.onStart();
        rxPermissions.request(Manifest.permission.CAMERA, Manifest.permission.MOUNT_UNMOUNT_FILESYSTEMS, Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.WRITE_SETTINGS)
                .subscribe(granted -> {
                });
    }

    private void initWindow() {
        windowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        //设置悬浮窗布局属性
        final WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
        //设置类型
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
        } else {
            layoutParams.type = WindowManager.LayoutParams.TYPE_PHONE;
        }
        //设置行为选项
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;
        //设置悬浮窗的显示位置
        layoutParams.gravity = Gravity.LEFT;
        //设置x周的偏移量
        layoutParams.x = 0;
        //设置y轴的偏移量
        layoutParams.y = 0;
        //如果悬浮窗图片为透明图片，需要设置该参数为PixelFormat.RGBA_8888
        layoutParams.format = PixelFormat.RGBA_8888;
        //设置悬浮窗的宽度
        layoutParams.width = WindowManager.LayoutParams.WRAP_CONTENT;
        //设置悬浮窗的高度
        layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT;
        //设置悬浮窗的布局
        floatWindowView = LayoutInflater.from(this).inflate(R.layout.float_window, null);
        floatWindowView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                Log.d(TAG, "MotionEvent: " + event.toString());
                return false;
            }
        });
        //加载显示悬浮窗
        windowManager.addView(floatWindowView, layoutParams);
        bt_play = floatWindowView.findViewById(R.id.bt_play);
        bt_play.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void onClick(View view) {
                if (isRecord) {
                    bt_play.setText("开始录屏");
//                    toggleTouch();
//                    Settings.System.putInt(getContentResolver(),
//                            "show_touches", 1);
                    stopScreenRecord();
                } else {
                    bt_play.setText("停止录屏");
//                    Settings.System.putInt(getContentResolver(),
//                            "show_touches", 0);
                    startScreenRecord();
                }
            }
        });
        bt_play.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {
                windowManager.removeView(floatWindowView);
                return false;
            }
        });
    }

    private void toggleTouch() {
//        try {
//            Class clazz = Class.forName("com.android.server.input.InputManagerService");
//            Constructor constructor = clazz.getConstructor(Context.class);
//            Object object = constructor.newInstance(this);
//            Field field = clazz.getDeclaredField("mPtr");
//            long ptr = field.getLong(object);
//
//            Method method = clazz.getDeclaredMethod("nativeSetShowTouches", Long.class, Boolean.class);
//            method.invoke(null, ptr, true);
//
//        } catch (ClassNotFoundException | NoSuchMethodException | IllegalAccessException | InstantiationException | InvocationTargetException | NoSuchFieldException e) {
//            e.printStackTrace();
//        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (windowManager != null) {
            windowManager.removeView(floatWindowView);
        }
    }

    private void initClick() {
        buttonRecord.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void onClick(View view) {
                if (isRecord) {
                    stopScreenRecord();
                } else {
                    startScreenRecord();
                }
            }
        });
        buttonCapture.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                initWindow();
            }
        });

    }

    private void initView() {
        linearLayout = (LinearLayout) findViewById(R.id.linearLayout);
        buttonRecord = (Button) findViewById(R.id.buttonRecord);
        buttonCapture = findViewById(R.id.buttonCapture);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1000) {
            if (resultCode == RESULT_OK) {
                //获得录屏权限，启动Service进行录制
                Intent intent = new Intent(RecordActivity.this, ScreenRecordService.class);
                intent.putExtra("resultCode", resultCode);
                intent.putExtra("resultData", data);
                intent.putExtra("mScreenWidth", mScreenWidth);
                intent.putExtra("mScreenHeight", mScreenHeight);
                intent.putExtra("mScreenDensity", mScreenDensity);
                startService(intent);
                Toast.makeText(this, "录屏开始", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(this, "录屏失败", Toast.LENGTH_SHORT).show();
            }

        }
    }

    //start screen record
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void startScreenRecord() {
        //Manages the retrieval of certain types of MediaProjection tokens.
        MediaProjectionManager mediaProjectionManager =
                (MediaProjectionManager) getSystemService(Context.MEDIA_PROJECTION_SERVICE);
        //Returns an Intent that must passed to startActivityForResult() in order to start screen capture.
        Intent permissionIntent = mediaProjectionManager.createScreenCaptureIntent();
        startActivityForResult(permissionIntent, 1000);
        isRecord = true;
        buttonRecord.setText(new String("停止录屏"));
    }

    //stop screen record.
    private void stopScreenRecord() {
        Intent service = new Intent(this, ScreenRecordService.class);
        stopService(service);
        isRecord = false;
        buttonRecord.setText(new String("开始录屏"));
        Toast.makeText(this, "录屏成功", Toast.LENGTH_SHORT).show();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // 在这里将BACK键模拟了HOME键的返回桌面功能（并无必要）
//        if (keyCode == KeyEvent.KEYCODE_BACK) {
//            simulateHome();
//            return true;
//        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * 获取屏幕基本信息
     */
    @RequiresApi(api = Build.VERSION_CODES.DONUT)
    private void getScreenBaseInfo() {
        //A structure describing general information about a display, such as its size, density, and font scaling.
        DisplayMetrics metrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(metrics);
        mScreenWidth = metrics.widthPixels;
        mScreenHeight = metrics.heightPixels;
        mScreenDensity = metrics.densityDpi;
    }

    /**
     * 模拟HOME键返回桌面的功能
     */
    private void simulateHome() {
        //Intent.ACTION_MAIN,Activity Action: Start as a main entry point, does not expect to receive data.
        Intent intent = new Intent(Intent.ACTION_MAIN);
        //If set, this activity will become the start of a new task on this history stack.
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        //This is the home activity, that is the first activity that is displayed when the device boots.
        intent.addCategory(Intent.CATEGORY_HOME);
        this.startActivity(intent);
    }
}