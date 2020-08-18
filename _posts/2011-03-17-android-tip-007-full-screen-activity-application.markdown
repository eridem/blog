---
layout:     post
title:      "Full screen activity/application"
subtitle:   "Android tip #007"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-007-full-screen-activity-application
---

Set your android application on fullscreen view, removing the default Android task bar and the application title bar. We have two choices: editing the Activity with Java code and the other one is edit the Activity from the manifest file.

```java
// YourActivity.java

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    requestWindowFeature(Window.FEATURE_NO_TITLE);

    getWindow().setFlags(
      WindowManager.LayoutParams.FLAG_FULLSCREEN,
      WindowManager.LayoutParams.FLAG_FULLSCREEN);
    setContentView(R.layout.main);
  }
```

```xml
<!-- AndroidManifest.xml -->

<activity android:name=".YourActivity"

android:theme="@android:style/Theme.NoTitleBar.Fullscreen" />
```
