---
layout:     post
title:      "Sync two ScrollLayouts when scroll"
subtitle:   "Android tip #028"
author:     "eridem"
main-img:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-028-sync-two-scrolllayouts-when-scroll
---

If we need to scroll two `ScrollLayout` at the same time we can create a new `View` that implements the standard `ScrollView` in order to create a listener which allow us to know when this one is scrolling and modify the behavior of the other (or maybe because we want to know about the scroll behavior).

```java
// IScrollListener.java

public interface IScrollListener {
  void onScrollChanged(IScrollListener scrollView, int x, int y, int oldx, int oldy);
}
```

```java
// ObservableScrollView.java

public class ObservableScrollView extends ScrollView {

  private IScrollListener listener = null;

  public ObservableScrollView(Context context) {
      super(context);
  }

  public ObservableScrollView(Context context, AttributeSet attrs, int defStyle) {
      super(context, attrs, defStyle);
  }

  public ObservableScrollView(Context context, AttributeSet attrs) {
      super(context, attrs);
  }

  public void setScrollViewListener(IScrollListener listener) {
      this.listener = listener;
  }

  @Override
  protected void onScrollChanged(int x, int y, int oldx, int oldy) {
      super.onScrollChanged(x, y, oldx, oldy);
      if (listener != null) {
          listener.onScrollChanged(this, x, y, oldx, oldy);
      }
  }
}
```

Use two `ObservableScrollView` in your layout: `oScrollViewOne`, `oScrollViewTwo`.

```java
// YourActivity.java

public class YourActivity extends Activity implements ScrollViewListener {
  ObservableScrollView oScrollViewOne, oScrollViewTwo;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);

    oScrollViewOne = (ObservableScrollView) this.findViewById(R.id.oScrollViewOne);
    oScrollViewTwo = (ObservableScrollView) this.findViewById(R.id.oScrollViewTwo);

    oScrollViewOne.setScrollViewListener(this);
    oScrollViewTwo.setScrollViewListener(this);
  }

  @Override
  void onScrollChanged(IScrollListener scrollView, int x, int y, int oldx, int oldy) {

    if (scrollView == oScrollViewOne) {
      oScrollViewTwo.scrollTo(x, y);
    } else if (scrollView == oScrollViewTwo) {
      oScrollViewOne.scrollTo(x, y);
    }
  }
}
```
