package com.geetest.onelogindemo.onelogin;


import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;


/**
 * 网络工具类
 */
public class HttpUtils {
    /**
     * 数据流
     *
     * @param inputStream
     * @return
     */
    private static String dealResponseResult(InputStream inputStream) {
        String resultData;
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byte[] data = new byte[1024];
        int len;
        try {
            while ((len = inputStream.read(data)) != -1) {
                byteArrayOutputStream.write(data, 0, len);
            }
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        resultData = new String(byteArrayOutputStream.toByteArray());
        return resultData;
    }

    /**
     * url获取
     *
     * @param urlString
     * @return
     */
    private static URL getValidateURL(String urlString) {
        try {
            return new URL(urlString);
        } catch (Exception e) {
        }
        return null;
    }

    public static String requestNetwork(String string, JSONObject params) {

        URL url = getValidateURL(string);

        HttpURLConnection httpURLConnection = null;
        try {
            httpURLConnection = (HttpURLConnection) url.openConnection();

            httpURLConnection.setDoInput(true);
            httpURLConnection.setDoOutput(true);
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setUseCaches(false);
            httpURLConnection.connect();
            if (params != null) {
                OutputStream outputStream = httpURLConnection.getOutputStream();
                outputStream.write(params.toString().getBytes());
                outputStream.flush();
                outputStream.close();
            }
            int responseCode = httpURLConnection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream intStream = httpURLConnection.getInputStream();
                return dealResponseResult(intStream);
            } else {
                return "url:" + string + ",responseCode:" + responseCode;
            }


        } catch (Exception e) {
            return "url:" + string + ",error:" + e.toString();
        } finally {
            if (httpURLConnection != null) {
                httpURLConnection.disconnect();
            }
        }
    }
}
