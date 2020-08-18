---
layout:     post
title:      "Getting the device wallpaper"
subtitle:   "Android tip #009"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-009-getting-the-device-wallpaper
---

We can get the background that is currently used by the device and convert it to a drawable object. We may use it to set up the background of our application as the wallpaper or set up the source of a ImageView.

```java
// YourActivity.java

WallpaperManager wallpaperManager = WallpaperManager.getInstance(this);
Drawable wallpaperDrawable = wallpaperManager.getDrawable();

ImageView iv = new ImageView(this);
iv.setImageDrawable(wallpaperDrawable);

```
