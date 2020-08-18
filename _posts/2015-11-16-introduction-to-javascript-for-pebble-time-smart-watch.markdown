---
layout:     post
title:      "Introduction to JavaScript for Pebble Time Smart-Watch"
author:     "eridem"
featured-image: img/featured/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch.jpg
permalink:  introduction-to-javascript-for-pebble-time-smart-watch
external: http://blog.loadimpact.com/blog/web-development/javascript-tutorial-for-pebble-time-smartwatch-pebblejs/
---

# PebbleJS

During this tutorial, I will explain some of the basics to start programming with PebbleJS. I will use images to illustrate the concepts we will find step-by-step. Advance documentation [can be found](https://developer.getpebble.com/docs/pebblejs/) on the Pebble site.

## Table of Contents

*   [Setting up everything](#setUp)
*   [Card, Menu and Window](#cardMenuWindow)
    *   [Button events](#buttonEvents)
    *   [Cards](#cards)
    *   [Menus](#menus)
*   [Actions bar](#actionBar)
*   [Ajax calls](#ajaxCalls)
*   [Extra: Adding images](#addingImages)
*   [Conclusion](#conclusion)

# Setting up everything {#setUp}

*   If you are a Windows user, I recommend to use a virtual machine with [Ubuntu](http://www.ubuntu.com).
*   [Create a developer account](https://auth.getpebble.com/users/sign_in) on their website.
*   Follow the installation instructions for for [Linux](https://developer.getpebble.com/sdk/install/linux/) or [Mac](https://developer.getpebble.com/sdk/install/mac/).
*   [Fork or download](http://github.com/pebble/pebblejs) the PebbleJS project on the development folder you are going to work with for your new project.

Once everything is set up, go to the root path of your project and use the following commands:

```bash
pebble clean
pebble build
pebble install --emulator basalt
```

To interact with the buttons on the emulator use the keyboard arrows.

![Pebble Button Schema](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/pebble-buttons-schema.png)

At this moment, the application should show an initial example from the main developer. If the emulator doesn't work, or it does not build correctly, revise the previous chapter before continuing.

# Card, Menu and Window {#cardMenuWindow}

The user interacts with different kinds of screens on its Pebble. Usually, when the user clicks on ```Select```, it opens a new screen with different information. When the user clicks on ```Back```, it goes back to the previous opened screen.

We can find some different _Window_ on the SDK already:

*   ```Window```: A blank screen where we can add anything at any valid coordinate
*   ```Card```: An already prepared _Window_ that contains a title, subtitle and body. Furthermore we can add icons
*   ```Menu```: A menu we can scroll that also shows different items with a title, subtitle and icon

![Pebble Window Types](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/windows.png)

In order to show any window, we need to invoke the method ```show()```.

```javascript
var UI = require('ui');
var wind = new UI.Window({});
wind.show();
```

All _Window_ has some common attributes.

![Common Window Attributes](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/commonWindowAttrs.png)

*   ```backgroundColor```: Changes the background color.
    Possible colors can be found on [this website](https://developer.getpebble.com/more/color-picker/)
*   ```scrollable```: it is used if the content of the screen is long.
    We use the *up* and *down* buttons to navigate on the screen.
    Cannot be used on the *Menu Window*
*   ```fullscreen```: Used to hide or show the top toolbar
    which indicates the time on the watch

```javascript
var UI = require('ui');
var wind = new UI.Window({
  fullscreen: false,
  scrollable: true,
  backgroundColor: 'yellow'
  });
wind.show();
```

## Button events {#buttonEvents}

Each _Window_ can intercept events when the user presses any button. The possible buttons are ```back```, ```up```, ```down``` and ```select```. They can be intercepted using the following code:

```javascript
var UI = require('ui');
var wind = new UI.Window({});

wind.on('click', 'back', function(e) { /* Click BACK */ });
wind.on('click', 'up', function(e) { /* Click UP*/ });
wind.on('click', 'down', function(e) { /* Click DOWN */ });
wind.on('click', 'select', function(e) { /* Click SELECT */ });

wind.show();
```

## Cards {#cards}

![Card Common Attributes](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/cardCommonAttrs.png)

*   ```title```: Shows a title at the top of the screen
*   ```icon```: Shows an icon at the left of the title
*   ```subtitle```: Shows a subtitle after the title with smaller font
*   ```subicon```: Shows an icon at the left of the subtitle
*   ```body```: Long text to display
*   ```banner```: Big icon before the body

```javascript
var UI = require('ui');
var card = new UI.Card({
  fullscreen: true,
  scrollable: true,
  title: 'Title',
  icon: 'images/one.png',  
  subtitle: 'Subtitle',
  subicon: 'images/two.png',
  body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue.',
  banner: 'images/watch.png',
  backgroundColor: 'yellow'
});

card.show();
```

If we use _scrollable_, the text of our _body_ will not be cut on the screen and we will be able to read it all using the _up_ and _down_ buttons.

NOTE: Read the section [Adding images](#addingImages) to add an image to the project.

## Menus {#menus}

![Menu Common Attributes](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/menuCommonAttrs.png)

*   ```backgroundColor```: Changes the background color
*   ```textColor```: Changes the text color
*   ```highlightBackgroundColor```: Changes the background color
    of highlight items
*   ```highlightTextColor```: Changes the text color of highlight items
*   ```sections```: Array with menu sections

    *   ```title```: Title of the section
    *   ```items```: Items of the section

        *   ```title```: Title of the item
        *   ```description```: Description of the item
        *   ```icon```: Icon of the item

```javascript
var UI = require('ui');
var menu = new UI.Menu({
  fullscreen: true,
  backgroundColor: 'yellow',
  textColor: 'blue',
  highlightBackgroundColor: 'blue',
  highlightTextColor: 'white',
  sections: [{
    title: 'Shows',
    items: [{
      title: 'Mr. Robot',
      subtitle: 'Follows a young computer programmer who suffers from social anxiety disorder and forms connections through hacking. He is recruited by a mysterious anarchist, who calls himself Mr. Robot.',
      icon: 'images/tv.png'
    }, {
      title: 'Rick and Morty',
      subtitle: 'An animated series that follows the exploits of a super scientist and his not so bright grandson.',
      icon: 'images/tv.png'
    }]    
  },
  {
    title: 'Movies',
    items: [{
      title: 'Blade Runner',
      subtitle: 'A blade runner must pursue and try to terminate four replicants who stole a ship in space and have returned to Earth to find their creator.',
      icon: 'images/tv.png'
    },
    {
      title: 'Alien',
      subtitle: 'The commercial vessel Nostromo receives a distress call from an unexplored planet. After searching for survivors, the crew heads home only to realize that a deadly bioform has joined them.',
      icon: 'images/tv.png'
    }]
  }]
});

menu.show();
```

In order to intercept which item has been selected, we can attach the event ```select``` to the menu. When the user clicks in the _select_ button, the function will be triggered and we will have the control over the item. We can access to the item using ```e.item``` (in case we named _e_ to the first argument).

```javascript
menu.on('select', function(e) {
  console.log('Selected item #' + e.itemIndex + ' of section #' + e.sectionIndex);
  console.log('The item is titled "' + e.item.title + '"');
});
```

# Actions bar {#actionBar}

The SDK give us the possibility to create an ```Action``` bar with 3 icons. We can attach it to any _Window_, but we should not attach it to the _Menu Window_ because the buttons are used to scroll and select the items. Neither when the _scrollable_ attribute is _true_.

![Common Actions Attributes](/img/posts/2015-11-16-introduction-to-javascript-for-pebble-time-smart-watch/commonActionsAttrs.png)

*   ```backgroundColor```: Background color of the *Actions* bar
*   ```up```: Icon for the *top* action menu
*   ```down```: Icon for the *down* action menu
*   ```select```: Icon for the *select* action menu

On the chapter [Button events](#buttonEvents) we can see an example of how to intercept the clicks for those buttons.

NOTE: Read the section [Adding images](#addingImages) to add an image to the project.

# Ajax Calls {#ajaxCalls}

Ajax calls with PebbleJS are straightforward. The smart-watch does not connect directly to the Internet, but it does through the mobile proxy. For us, this is totally transparent using the SDK.

```javascript
var ajax = require('ajax');

ajax(
  {
    url: 'http://jsonplaceholder.typicode.com/posts',
    method: 'get', /* Can use get, post, delete, put and options */
    type: 'json',
    headers: { 'User-Agent': 'From eridem.net' }, /* Specify special headers */
    async: true, /* Set to false for a blocking call */
    cache: true,
    data: {}, /* Used to attach a payload */
  },
  function(data, status, request) {
    /* reply data inside data argument */
  },
  function(error, status, request) {
    /* error contains the error message */
  }
);
```

# Extra: Adding images {#addingImages}

Adding images in PNG format requires two steps:

*   Add the image to the ```/resources/images/``` folder on the project.
*   Add an entry on the ```/appinfo.json``` under the section ```resources/media```. E.g:

```javascript
{
  "type": "png",
  "name": "IMAGE_NAME",
  "file": "images/your_added_image.png"
}
```

When we use it on our application, we need to do a reference using the file name. E.g.

```
  images/your_added_image.png
```

# Conclusion {#conclusion}

As we saw on this tutorial, when using the PebbleJS SDK and with knowledge of Javascript, we can start creating amazing applications. Of course, [the complete documentation](https://developer.getpebble.com/docs/pebblejs/) describe other menu features, such as accelerometer, add texts and shapes to a Window, vibrations, wake ups and more.
