---
layout:     post
title:      "Use custom fonts"
subtitle:   "Android tip #016"
author:     "eridem"
main-img:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-016-use-custom-fonts
---

In order to use custom fonts in some `Views`, we need to import the font files to the folder `/assets/font/` and apply the typeface to the `View` (not all views support it, some examples are `TextView`, `Button`, `RadioButton`, and so on). Here an easy example using `Arial.ttf`.

```
+ assets
  + font
    - Arial.ttf
```

```java
// YourActivity.java

Typeface fontResource = Typeface.createFromAsset(
  context.getAssets(), "font/Arial.ttf");

TextView textView = (TextView) this.findViewById(R.id.tv1);
textView.setTypeface(fontResource);
```
