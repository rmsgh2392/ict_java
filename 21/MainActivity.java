package com.example.helloandroid;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    Button button;
    Button btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main); //레이아웃 설정 R => (res {resources} > layout)

        button = (Button) this.findViewById(R.id.button);
        /*
        *   <Button
        android:id="@+id/button"
         />
        *
        * */
        btn = (Button) this.findViewById(R.id.btn);

        MyHandler handler = new MyHandler();

        button.setOnClickListener(handler);
        btn.setOnClickListener(handler);
    }

    class MyHandler implements View.OnClickListener {

        @Override
        public void onClick(View view) {
            if(view == button){
                Toast.makeText(MainActivity.this, "안녕 안드로이드", Toast.LENGTH_SHORT).show();
            } else if (view == btn){
                Toast.makeText(MainActivity.this, "꺼져 이년아", Toast.LENGTH_SHORT).show();
            }
        }
    }
}