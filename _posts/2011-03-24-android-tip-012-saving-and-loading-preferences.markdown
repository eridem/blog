---
layout:     post
title:      "Saving and loading preferences"
subtitle:   "Android tip #012"
author:     "eridem"
main-img:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-012-saving-and-loading-preferences
---

Save and load preferences on Android is quite easy. You can save primitive values as Key-Value. `SharedPreferences` class on android is very useful to save states on Android.

```java
// YourActivity.java

private static final String PREFS_NAME = "preferences";
private static final String PREF_USERNAME = "pref_username";

/* ... */

private final String yourDefaultUsernameValue = "";
private String yourUsernameValue;

/* ... */

private void savePreferentes(Context context) {
  SharedPreferences settings = getSharedPreferences(PREFS_NAME, Context.MODE_APPEND);
  SharedPreferences.Editor editor = settings.edit();

  // Edit and commit
  editor.putString(PREF_USERNAME, yourUsernameValue);
  editor.commit();
}

private void loadPreferences(Context context) {
  SharedPreferences settings = getSharedPreferences(PREFS_NAME, Context.MODE_APPEND);

  // Get value
  yourUsernameValue = settings.getString(PREF_USERNAME, yourDefaultUsernameValue);
}
```
