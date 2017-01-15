---
layout:     post
title:      "SSH, execute remote commands with Android"
subtitle:   "Android tip #021"
author:     "eridem"
header-img: "img/featured/android_background.jpg"
permalink:  android-tip-021-ssh-execute-remote-commands-with-android
featured-author: Psychopulse
featured-link: http://psychopulse.deviantart.com/
---

We need to download the [JSCH](http://www.jcraft.com/jsch/) libraries and [JZLIB](http://www.jcraft.com/jzlib/) libraries that we can get directly on here:

- [Download JSCH 0.1.44](http://sourceforge.net/projects/jsch/files/jsch.jar/0.1.44/jsch-0.1.44.jar/download)
- [Download JZLib 1.0.7](http://www.jcraft.com/jzlib/jzlib-1.0.7.tar.gz)

We need to give `INTERNET` permission to our application in the manifest file.

In this example we execute the command `ls` in a remote machine using SSH and return the result. *NOTE: you should improve the code for exception handling.*

```xml
<!-- AndroidManifest.xml-->

<manifest ... >
 <uses-permission android:name="android.permission.INTERNET" />
</manifest>
```

```java
// MyClass.java

public static String executeRemoteCommand(
                       String username,
                       String password,
                       String hostname,
                       int port) throws Exception {     

  JSch jsch = new JSch();
  Session session = jsch.getSession(username, hostname, 22);
  session.setPassword(password);

  // Avoid asking for key confirmation
  Properties prop = new Properties();
  prop.put("StrictHostKeyChecking", "no");
  session.setConfig(prop);

  session.connect();

  // SSH Channel
  ChannelExec channelssh = (ChannelExec) session.openChannel("exec");      
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  channelssh.setOutputStream(baos);

  // Execute command
  channelssh.setCommand("ls");
  channelssh.connect();        
  channelssh.disconnect();

  return baos.toString();
}
```