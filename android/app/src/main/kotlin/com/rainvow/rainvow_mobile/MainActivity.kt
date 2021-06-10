package com.rainvow.rainvow_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {
    /**
     * shared_preferences (앱 저장소)
     * flutter sharedpreferences MissingPluginException error 에러 해결을 위한 코드
     * */
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

}
