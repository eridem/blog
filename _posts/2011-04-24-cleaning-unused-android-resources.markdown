---
layout:     post
title:      "Cleaning unused Android resources"
subtitle:   "Cleaning automated"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  cleaning-unused-android-resources
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

On middle/big projects we usually add lots of resources that we can use on code files, layouts or other resources. When we start to do modifications to the project, sometimes we forgot to remove unused strings, drawables, layouts and so on.

I wanted to create a script to check these unused resources on our Android project, but I found a project which already does this task. This project is called `android-unused-resources`, and we can download it from:

<http://code.google.com/p/android-unused-resources/>

The use is simple, add the file to the root project and execute it:

```bash
java -jar AndroidUnusedResources.jar
```