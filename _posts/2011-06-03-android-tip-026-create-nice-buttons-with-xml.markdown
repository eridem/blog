---
layout:     post
title:      "Create nice buttons with XML"
subtitle:   "Android tip #026"
author:     "eridem"
main-img:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-026-create-nice-buttons-with-xml
---

We can create nice buttons simply using few colors and gradients. We need to create a `Selector` resource and attach all the shape items for every state: `pressed`, `focussed`, `disabled` and `normal`. In the most common cases, focussed and normal could show the same result. In the case of pressed and normal, we will invert the colors. And in the case of disabled, we will use other colors (like a gray color).

![Button image](/img/posts/2011-06-03-button.png)

```xml
<!-- colors.xml in /values/ -->

<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="NiceButtonStartColor">#4AA02C</color>
    <color name="NiceButtonEndColor">#348017</color>
    <color name="NiceButtonDisabledStartColor">#565051</color>
    <color name="NiceButtonDisabledEndColor">#736F6E</color>
    <color name="NiceButtonBorderColor">#254117</color>
</resources>
```

```xml
<!-- nice_button.xml in /drawables/ -->

<?xml version="1.0" encoding="utf-8"?>
<selector
   xmlns:android="http://schemas.android.com/apk/res/android">

    <item android:state_pressed="true" >
        <shape>
            <gradient
               android:endColor="@color/NiceButtonStartColor"
               android:startColor="@color/NiceButtonEndColor"
               android:angle="270" />
            <stroke
               android:width="1dp"
               android:color="@color/NiceButtonBorderColor" />
            <corners
               android:radius="3dp" />
            <padding
               android:left="0dp"
               android:top="10dp"
               android:right="0dp"
               android:bottom="10dp" />
        </shape>
    </item>

    <item android:state_focused="true" >
        <shape>
            <gradient
               android:startColor="@color/NiceButtonStartColor"
               android:endColor="@color/NiceButtonEndColor"
               android:angle="270" />
            <stroke
               android:width="1dp"
               android:color="@color/NiceButtonBorderColor" />
            <corners
               android:radius="3dp" />
            <padding
               android:left="0dp"
               android:top="10dp"
               android:right="0dp"
               android:bottom="10dp" />
        </shape>
    </item>

    <item android:state_enabled="false">
            <shape>
            <gradient
               android:startColor="@color/NiceButtonDisabledStartColor"
               android:endColor="@color/NiceButtonDisabledEndColor"
               android:angle="270" />
            <stroke
               android:width="1dp"
               android:color="@color/NiceButtonBorderColor" />
            <corners
               android:radius="3dp" />
            <padding
               android:left="0dp"
               android:top="10dp"
               android:right="0dp"
               android:bottom="10dp" />
        </shape>
    </item>

    <item>        
        <shape>
            <gradient
               android:startColor="@color/NiceButtonStartColor"
               android:endColor="@color/NiceButtonEndColor"
               android:angle="270" />
            <stroke
               android:width="1dp"
               android:color="@color/NiceButtonBorderColor" />
            <corners
               android:radius="3dp" />
            <padding
               android:left="0dp"
               android:top="10dp"
               android:right="0dp"
               android:bottom="10dp" />
        </shape>
    </item>
</selector>
```

```xml
<!-- my_layout.xml -->

<!-- ... -->
<!-- Better if you use most of the attributes in a style -->
<Button 
   android:id="@+id/btnStart"
   android:layout_width="fill_parent"  
   android:layout_height="40dp"
   android:layout_margin="3dp"
   android:gravity="center"

   android:background="@drawable/nice_button"

   android:text="@string/labelStart"
   android:textColor="@android:color/white"
   android:textSize="18sp"
   android:shadowRadius="1"
   android:shadowDx="1"
   android:shadowDy="1"
   android:shadowColor="@android:color/black"
></Button>
<!-- ... -->

```
