---
layout:     post
title:      "Update user interface from a thread"
subtitle:   "Android tip #011"
author:     "eridem"
main-img:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-011-update-user-interface-from-a-thread
---

With the class `Handler`, you can throw a Runnable class (a intended to be executed by a thread) and furthermore, you can update the user interface. On this code, we implements Runnable in our own `Activity` and we override the method run.

```java
// YourActivity.java

public class YourActivity extends Activity implements Runnable {
  
  @Override
  public void onCreate(Bundle savedInstanceState) {
    // ...

    // Throw new thread
    new Handler().postDelayed(this, 100);
  }

  @Override
  public void run() {
    // This is the method caught by the handler
    // and it is running in a thread.

    /* You can update the interface on here */  
  }
}
```
