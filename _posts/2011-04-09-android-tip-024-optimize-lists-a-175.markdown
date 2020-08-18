---
layout:     post
title:      "Optimize lists a 175%"
subtitle:   "Android tip #024"
author:     "eridem"
featured-image:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-024-optimize-lists-a-175
---

two operations are expensive when we create custom lists: `Inflate` (covered on the tip 23) and `findByViewId(int)`. We can avoid call to this second operation saving the views used for every row in a wrapper.

This pattern implies use a Model and a Wrapper. The Model will save the information of every row and the `Wrapper` will save the Views. We need to save the wrapper in every row view using the properties `getTag()` and `setTag(Object)`.

This example will use only one value in the model and a `TextView` in the wrapper, but you can extend it as much as you wish.

```java
// Model: Item.java

public class Item {
  private String value = null;

  public String getValue() {
    if (this.value == null) {
      this.value = "";
    }
    return this.value;
  }

  public void setValue(String value) {
      this.value = value;
  }
}
```

```java
// Wrapper: ItemWrapper.java

public class ItemWrapper {
  private View row = null;
  private TextView mTextView = null;

  public ItemWrapper(View row) {
    this.mRow = row;
  }

  private TextView getMTextView() {
    if (this.mTextView == null) {
      this.mTextView = (TextView) {
        this.row.findViewById(R.id.your_row_layout_textview);
      }
    }
    return this.mTextView;
  }

  public void populate(Item item) {
    this.getMTextView().setText(item.getValue());
  }
}
```

```java
// Adapter: MyAdapter.java

private List<Item> items;

@Override
public View getView(int position, View convertView, ViewGroup parent) {
    View row = convertView;
    ItemWrapper wrapper = null;

    if (row == null) {
        LayoutInflater inflater = (LayoutInflater) this.mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        row = inflater.inflate(R.layout.your_row_layout, null);

        wrapper = new ItemWrapper(row);
        row.setTag(wrapper);        
    } else {
        wrapper = (ItemWrapper) row.getTag();
    }

    // Populate row
    wrapper.populate(items.get(position));  

    return row;
}
```

*NOTE: related post: [Optimize lists a 150%](/android-tip-023-optimize-lists-a-150)*
