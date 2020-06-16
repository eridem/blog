---
layout:     post
title:      "Add shadow to labels, buttons and other views"
subtitle:   "Android tip #027"
author:     "eridem"
main-img: "img/featured/android-tip-left.jpg"
permalink:  android-tip-027-add-shadow-to-lables-buttons-and-other-view
---

We can drop shadows to our controls (`TextView`, `Buttons`, `Checkbox`, …). Adding this shadow, we can create a better interface in our applications (but be careful adding shadow to everything!).

![Shadow image](/img/posts/2011-06-03-shadow.png)

```xml
<!-- my_layout.xml -->

<TextView
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   
   android:textColor="@android:color/black"
   android:text="@string/eridemNet"
   
   android:shadowRadius="3"
   android:shadowDx="3"
   android:shadowDy="2"
   android:shadowColor="@android:color/black"
></TextView>
```
