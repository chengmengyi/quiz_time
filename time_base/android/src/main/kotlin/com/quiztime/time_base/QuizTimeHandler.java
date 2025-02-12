package com.quiztime.time_base;


import android.os.Handler;
import android.os.Message;
import androidx.annotation.Keep;

@Keep
public class QuizTimeHandler extends Handler{

    public QuizTimeHandler() {

    }

    @Keep
    @Override
    public void handleMessage(Message message) {
        int r0 = message.what;
        QuizTimeLoad.QuizTimeLoadFuncTwo(r0);
    }
}
