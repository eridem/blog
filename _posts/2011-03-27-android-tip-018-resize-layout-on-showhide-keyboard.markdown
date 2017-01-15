---
layout:     post
title:      "Resize layout on show/hide keyboard"
subtitle:   "Android tip #018"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  android-tip-018-resize-layout-on-showhide-keyboard
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

Sometimes we need to resize the layout when the keyboard appears. For example, when you click in one of your `TextView`, and this one is hidden by the keyboard (or maybe other menus on the bottom). Easily we can change this behavior adding a small setting to the Activity in the manifest.

Using the field `android:windowSoftInputMode="adjustResize"` will do the work for us.

```xml
<!-- AndroidManifest.xml-->

<activity
 android:name=".net.eridem.myapp.YourActivity"
 android:windowSoftInputMode="adjustResize">
</activity>     
```