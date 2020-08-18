---
layout:     post
title:      "Inflating view"
subtitle:   "Android tip #002"
author:     "eridem"
featured-image:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-002-inflating-view
---

You can reuse a View from a XML file in your code loading it like a View. It is useful for dynamic Screens or when you create custom lists.

```java
// YourActivity.java

private View loadViewFromResources(LinearLayout parent, Context context) {
  LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

  View view = inflater.inflate(R.layout.your_layout_name, parent, false);
  return view;
}
```
