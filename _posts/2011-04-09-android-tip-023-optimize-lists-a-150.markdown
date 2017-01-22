---
layout:     post
title:      "Optimize lists a 150%"
subtitle:   "Android tip #023"
author:     "eridem"
main-img: "img/featured/android_background.jpg"
permalink:  android-tip-023-optimize-lists-a-150
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

We can optimize the `Adapters` attached to a `ListView` inflating our custom layouts when it is necessary. This process is easy to implement with only one condition (Android will managed the rest of the work).

```java
// MyAdapter.java

@Override
public View getView(int position, View convertView, ViewGroup parent) {
    View row = convertView;

    if (row == null) {
        LayoutInflater inflater = (LayoutInflater) this.mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        row = inflater.inflate(R.layout.your_row_layout, null);     
    }

    // Populate row
    // ...

    return row;
}
```

*NOTE: related post: [Optimize lists a 175%](/android-tip-024-optimize-lists-a-175)*