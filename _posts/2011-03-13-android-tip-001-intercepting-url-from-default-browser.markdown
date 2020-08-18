---
layout:     post
title:      "Intercepting URL from default browser"
subtitle:   "Android tip #001"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-001-intercepting-url-from-default-browser
---

This code intercepts an URL opened from the default Internet browser in Android and it is sent to your application. Using this code, you are able to use the URL for your own proposes. The user will be informed that your application can be used to open the link.

Add intent-filter to the Activity that will intercept the link.

```xml
<!-- Manifest.xml -->

<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="http"
   android:host="www.domain_to_intercept.com"
   android:pathPrefix="" />
</intent-filter>
```

Handle link in the Activity:

```java
// YourActivity.java

@Override
public void onCreate(Bundle savedInstanceState) {

  if (Intent.ACTION_VIEW.equals(action)) {
    String link = intent.getData().getScheme() + intent.getData().getSchemeSpecificPart();
    // method to handle the link
    this.handleThisLink(link);
  }

}
```
