---
layout:     post
title:      "Left and right swipe (gesture events)"
subtitle:   "Android tip #010"
author:     "eridem"
featured-image:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-010-left-and-right-swipe-gesture-events
---

Android has some tools to receive touch events, but with this code, we will received left and right swipes on the whole screen.

```java
// YourActivity.java

public class YourActivity extends Activity {
  private GestureDetector gestureDetector;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    // ...
    gestureDetector = new GestureDetector(new SwipeGestureDetector());
  }

  @Override
  public boolean onTouchEvent(MotionEvent event) {
    if (gestureDetector.onTouchEvent(event)) {
      return true;
    }
    return super.onTouchEvent(event);
  }

  private void onLeftSwipe() {
    // Do something
  }

  private void onRightSwipe() {
    // Do something
  }

  // Private class for gestures
  private class SwipeGestureDetector extends SimpleOnGestureListener {
    // Swipe properties, you can change it to make the swipe 
    // longer or shorter and speed
    private static final int SWIPE_MIN_DISTANCE = 120;
    private static final int SWIPE_MAX_OFF_PATH = 200;
    private static final int SWIPE_THRESHOLD_VELOCITY = 200;

    @Override
    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
      try {
        float diffAbs = Math.abs(e1.getY() - e2.getY());
        float diff = e1.getX() - e2.getX();

        if (diffAbs > SWIPE_MAX_OFF_PATH) {
          return false;
        }

        // Left swipe
        if (diff > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
           YourActivity.this.onLeftSwipe();

        // Right swipe
        } else if (-diff > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
          YourActivity.this.onRightSwipe();
        }
      } catch (Exception e) {
        Log.e("YourActivity", "Error on gestures");
      }
      return false;
    }
  }
}
```
