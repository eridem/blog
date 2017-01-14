---
layout:     post
title:      "Send and receive information from Activities"
subtitle:   "Android tip #005"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  android-tip-005-send-and-receive-information-from-activities
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

This is an easy example about how to pass information from one Activity to another and receive back information.

```java
// ActivityOne.java

public class ActivityOne extends Activity {
  private static final int ACT_TWO_CODE = 123;
  private static final String EXTRA_STRING = "extra_string";
  
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    Intent intent = new Intent(this, ActivityTwo.class);
    intent.putExtra(ActivityTwo.EXTRA_BOOLEAN, true);
    this.startActivityForResult(intent, ACT_TWO_CODE);
  }

  @Override
  public void onActivityResult(
    int requestCode, int resultCode, Intent data) {
    if (resultCode == Activity.RESULT_OK && requestCode == ACT_TWO_CODE) {
      String result = data.getExtras().getString(ActivityOne.EXTRA_STRING);
      result = result==null ? "Error receiving info" : result;
      Toast.makeText(this, result, Toast.LENGTH_LONG);
    }
  }
}
```

```java
// ActivityTwo.java

public class ActivityTwo extends Activity {
  private static final String EXTRA_BOOLEAN = "extra_boolean";
  
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    Boolean result = this.getIntent().getBooleanExtra(name, false);
    if (result == true) {
      Intent intent = new Intent(this, ActivityTwo.class);
      intent.putExtra(ActivityOne.EXTRA_STRING, "Hello from Activity two!");
      this.setResult(Activity.RESULT_OK, intent);
    } else {
      this.setResult(Activity.RESULT_CANCELED);
    }
    this.finish();
  }
}
```