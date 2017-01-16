---
layout:     post
title:      "Check missing strings for a multi-language Android application"
subtitle:   "Lint those texts"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  check-missing-strings-for-a-multi-language-android-app
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

When we are creating a multi-language application for Android, we need to create several folders to save the strings of different languages. When we are handling hundred or thousand of strings, we can forget adding a string in all language files.

Looking for a tool to organize all the strings in my project and check if any string was missing, I found the [W.F.M.H's blog](http://wfmh.org.pl/carlos/blog/) were you can download a PHP script to help you for checking all your strings.

The usage is easy:

```bash
./string-check.php values/strings.xml values-es/strings.xml
```

You could get a result similar to:

```
Missing in <LANG> (You need to add these to your file)
File: values-es/strings.xml
------------------------------------------------------
header_title
description_label

Missing in EN (you probably shall remove it from your <LANG> file)
File: values/strings.xml
------------------------------------------------------------------
mysection_label

Summary
----------------
BASE file: 'values/strings.xml'
LANG file: 'values-de/strings.xml'
   2 missing strings in your LANG file.
   1 obsolete strings in your LANG file.
```

For more information about the project, visit the main website: 

[W.F.M.H.’s blog, Android translators’ helper tool](http://wfmh.org.pl/carlos/blog/2010/07/06/android-translators-helper-tool/)

Or download the script directly from his/her website: [strings-check.zip](http://wfmh.org.pl/carlos/blog/wp-content/strings-check.zip)