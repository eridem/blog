---
layout:     post
title:      "Database not open"
subtitle:   "Android tip #019"
author:     "eridem"
featured-image:   "img/featured/android-tip-left.jpg"
permalink:  android-tip-019-database-not-open
---

A very common error when we are working with database is not check that we have the database opened. So, we will receive the exception `java.lang.IllegalStateException: database not open`. We can fix it with a simple condition before we execute any query.

```java
// YourClass.java

SQLiteDatabase d = null;

// Initialization, other queries and so on...
// ...

if (d == null || !d.isOpen()) {
  d = db.getWritableDatabase(); 
  // d = db.getReadableDatabase();
}

// Your query here
// ... 
```
