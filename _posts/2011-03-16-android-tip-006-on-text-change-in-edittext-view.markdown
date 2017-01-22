---
layout:     post
title:      "On text change in EditText view"
subtitle:   "Android tip #006"
author:     "eridem"
main-img: "img/featured/android_background.jpg"
permalink:  android-tip-006-on-text-change-in-edittext-view
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

Create a listener when an EditText changes the text inside. I have added a button to enable or disable depending of the text inside the EditText. I post this example because the EditText listener does not start like `setOn...Listener` and sometimes it is not clear for finding it.

```java
// YourActivity.java

@Override
private Button btnSave;

public void onCreate(Bundle savedInstanceState) {

  EditText edit = (EditText) this.findViewById(R.id.edit_text);
  Button btnSave = (Button) this.findViewById(R.id.btn_save);

  edit.addTextChangedListener(new TextWatcher() {            
    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {}
    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

    @Override
    public void afterTextChanged(Editable s) {
      String text = edit.getText().toString().trim();
      YourActivity.this.btnSave.setEnabled(text.length() != 0);
    }
  });

}
```