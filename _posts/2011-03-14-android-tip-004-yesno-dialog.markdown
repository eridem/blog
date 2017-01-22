---
layout:     post
title:      "Yes/No dialog"
subtitle:   "Android tip #004"
author:     "eridem"
main-img: "img/featured/android_background.jpg"
permalink:  android-tip-004-yesno-dialog
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

This code shows a yes/no dialog as pop-up. The code can handle the response.

```java
// YourActivity.java

DialogInterface.OnClickListener dialogClickListener = 
  new DialogInterface.OnClickListener() {

  @Override
  public void onClick(DialogInterface dialog, int which) {
    switch (which){
      case DialogInterface.BUTTON_POSITIVE:
        // On click YES button
        break;

      case DialogInterface.BUTTON_NEGATIVE:
        // On click NO button
        break;
    }
  }
};

AlertDialog.Builder builder = new AlertDialog.Builder(this);
builder.setMessage("Is this a yes-no dialog?")
  .setPositiveButton("Yes", dialogClickListener)
  .setNegativeButton("No", dialogClickListener)
  .show();
```