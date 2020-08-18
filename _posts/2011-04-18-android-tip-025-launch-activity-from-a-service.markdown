---
layout:     post
title:      "Launch Activity from a service"
subtitle:   "Android tip #025"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-025-launch-activity-from-a-service
---

If we have a service in background and we need to launch an `Activity` in foreground, we need to add the tag `FLAG_ACTIVITY_NEW_TASK` to the `Intent`.

```java
// MyService.java

public class MyService extends Service {

  private void launchActivity() {
    Intent intent = new Intent(this, MyActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    this.startActivity(intent);
  }
  
}
```
