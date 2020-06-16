---
layout:     post
title:      "Gradient backgrounds"
subtitle:   "Android tip #013"
author:     "eridem"
main-img:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-013-gradient-backgrounds
---

We can create easily backgrounds with XML drawables. In this example, we will create a new resource on the folder `drawables` that will contain a gradient and we will apply it to one of our layouts.

```xml
<!-- my_gradient.xml -->

<?xml version="1.0" encoding="utf-8"?>

<shape
  xmlns:android="http://schemas.android.com/apk/res/android"
  android:shape="rectangle">

  <gradient 
    android:angle="90" android:startColor="#FFFD7E00"
    android:endColor="#FFF4322A" android:type="linear" />

</shape>
```

```xml
<!-- your_layout.xml -->

<?xml version="1.0" encoding="utf-8"?>

<LinearLayout
  xmlns:android="http://schemas.android.com/apk/res/android"
  android:layout_width="fill_parent"
  android:layout_height="fill_parent"
  android:background="@drawable/my_gradient">
</LinearLayout>
```
