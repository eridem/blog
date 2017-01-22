---
layout:     post
title:      "Multi-language application"
subtitle:   "Android tip #014"
author:     "eridem"
main-img: "img/featured/android_background.jpg"
permalink:  android-tip-014-multi-language-application
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

If we need to create an application that supports different languages, we need to create different folders for values for different languages. Here an example of English (default), Spanish (es) and Swedish (sv). The language is selected automatically using the system language.

```
+ res
  + values
    - strings.xml
  + values-es
    - strings.xml
  + values-sv
    - strings.xml
```


```xml
<!-- English /res/values/strings.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <string name="hello">Hello</string>
</resources>

<!-- Spanish /res/values-es/strings.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <string name="hello">Hola</string>
</resources>

<!-- Swedish /res/values-sv/strings.xml -->
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <string name="hello">Hej</string>
</resources>
```

```java
// YourActivity.java

  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    String helloString = this.getString(R.id.hello);
  }
```