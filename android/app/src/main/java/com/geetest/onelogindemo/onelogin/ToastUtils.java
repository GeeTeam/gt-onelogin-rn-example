package com.geetest.onelogindemo.onelogin;

import android.content.Context;
import android.widget.Toast;


/**
 *  吐司工具类
 */
public class ToastUtils {

    public static void toastMessage(Context context, String param) {
        Toast.makeText(context, param, Toast.LENGTH_SHORT).show();
    }

}
