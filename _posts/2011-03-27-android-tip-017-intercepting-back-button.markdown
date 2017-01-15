---
layout:     post
title:      "Intercepting back button"
subtitle:   "Android tip #017"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  android-tip-017-intercepting-back-button
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

In order to intercept the *BACK* button and other buttons (without include *HOME* button), we need to override the method `dispatchKeyEvent` in our `Activity`. Another way to do that is overriding the method `onBackButton()`.

```java
// YourActivity.java

@Override
public boolean dispatchKeyEvent(KeyEvent event) {       
    // Handling the back button
    if (event.getKeyCode() == KeyEvent.KEYCODE_BACK) {
        this.showQuitDialog();
        return true;
    } else {
        return super.dispatchKeyEvent(event);
    }
}

@Override
public void onBackPressed() {
  this.showQuitDialog();
}
```