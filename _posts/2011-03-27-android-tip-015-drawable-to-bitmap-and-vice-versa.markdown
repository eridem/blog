---
layout:     post
title:      "Drawable to Bitmap (and vice versa)"
subtitle:   "Android tip #015"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-015-drawable-to-bitmap-and-vice-versa
---

This code convert a `Bitmap` to `Drawable` and vice versa. It is useful when we are working with graphics.

```java
// YourActivity.java

private Bitmap drawableToBitmap(Drawable drawable) {
  if (drawable == null) {
    return null;
  }

  return ((BitmapDrawable)drawable).getBitmap();
}

private Drawable bitmapToDrawable(Bitmap bitmap) {
  if (bitmap == null) {
    return null;
  }
  
  return new BitmapDrawable(bitmap);
}
```
