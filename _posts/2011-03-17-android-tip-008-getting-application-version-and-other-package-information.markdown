---
layout:     post
title:      "Getting application version and other package information"
subtitle:   "Android tip #008"
author:     "eridem"
main-img: "img/featured/android_background.jpg"
permalink:  android-tip-008-getting-application-version-and-other-package-information
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

This code gets the version that you used in your `ManifestFile.xml` and save it in a String (in order to use it for your own proposes, for instance, a About screen). Furthermore, you can use the PackageInfo class to get other application information.

Create a version name in your manifest file.

```xml
<!-- AndroidManifest.xml -->

<manifest 
 xmlns:android="http://schemas.android.com/apk/res/android"
 android:versionCode="2"
 package="com.your.application" 
 android:versionName="1.2.1">

</manifest>
```

```java
// YourActivity.java

  String version = "";

  try {
    PackageManager manager = context.getPackageManager();
    PackageInfo info = manager.getPackageInfo(
      context.getPackageName(), 0);
    version = info.versionName;
  } catch (Exception e) {
    Log.e("YourActivity", "Error getting version");
  }

  Log.i("Application.Version", version);
```