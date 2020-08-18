---
layout:     post
title:      "Play alarm sound"
subtitle:   "Android tip #022"
author:     "eridem"
featured-image:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-022-play-alarm-sound
---

We can play the user's alarm sound in our application using the class `RingtoneManager` and `MediaPlayer`.

```xml
<!-- AndroidManifest.xml-->

<manifest ... >
 <uses-permission android:name="android.permission.INTERNET" />
</manifest>
```

```java
// YourActivity.java

private MediaPlayer playAlarmSound() {
  Uri alert = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM); 
  MediaPlayer mMediaPlayer = new MediaPlayer();
  mMediaPlayer.setDataSource(this, alert);

  AudioManager audioManager = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
  int volumen = audioManager.getStreamVolume(AudioManager.STREAM_ALARM);
  
  if (volumen != 0) {
    mMediaPlayer.setAudioStreamType(AudioManager.STREAM_ALARM);
    mMediaPlayer.setLooping(true);
    mMediaPlayer.prepare();
    mMediaPlayer.start();
  }

  return mMediaPlayer; // We can stop it outside
}
```
