---
layout:     post
title:      "Broadcast intents"
subtitle:   "Android tip #020"
author:     "eridem"
featured-image:   "img/featured/android-tip-right.jpg"
permalink:  android-tip-020-broadcast-intents
---

We can send broadcast messages *- `Intents` -* in our application. They can be useful when we need to comunicate Activities with other Activities, Services with Activities and so on. It is a good way to send and listen messages in the whole application.

We need a receiver *- which will listen the message -* and a sender *- which will send the message -*.

```java
// Sender.java

public static final String BROADCAST_MESSAGE = "my_message";

private void sendBroadcastMessage(Context context) {
  Intent i = new Intent();
  i.setAction(BROADCAST_MESSAGE);
  context.sendBroadcast(i);
}
```

```java
// ReceiverActivity.java

public class ReceiverActivity extends Activity {

  private BroadcastReceiver receiver = new BroadcastReceiver(){
    @Override
    public void onReceive(Context arg0, Intent arg1) {
      ReceiverActivity.this.doSomething();
    }
  };

  private void doSomething() {
  }

  public void onResume() {
    super.onResume();

    IntentFilter filter = new IntentFilter();
    filter.addAction(Sender.BROADCAST_MESSAGE);

    this.registerReceiver(this.receiver, filter);
  }

  public void onPause() {
    super.onPause();
    this.unregisterReceiver(this.receiver);
  }
}
```
