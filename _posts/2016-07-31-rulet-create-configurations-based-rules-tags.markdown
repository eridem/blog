---
layout:     post
title:      "Rulet, create configurations based on rules and tags"
author:     "eridem"
main-img:   /img/featured/2016-07-31-rulet-create-configurations-based-rules-tags.jpg
permalink:  rulet-create-configurations-based-rules-tags
---

# Rulet

**_Rulet_** is a library to think differently when we need to create settings for our applications. It is based on **_rules_** and **_tags_** that will help us to combine sets of objects.

Can be installed using:

```bash
npm install rulet
```

## Let's start with an example

### The problem

Suppose that we have different environments, different apps, different scenarios. Our matrix combination of rules should have 3 dimensions and we need to define settings for all of them:

```javascript
let settings = {
    qa: {
        firstApp: {
            loginRight: {
                username: "Right", password: "right"
            },
            loginWrong: {
                username: "Wrong", password: "wrong"
            }
        },
        secondApp: {
            loginRight: {
                username: "RightForSecondApp", password: "right"
            },
            loginWrong: {
                username: "Wrong", password: "wrong"
            }
        }
    },
    prod: {
        firstApp: {
            loginRight: {
                username: "Right", password: "right"
            },
            loginWrong: {
                username: "Wrong", password: "wrong"
            }
        },
        secondApp: {
            loginRight: {
                username: "RightsForSecondAppInProd", password: "right"
            },
            loginWrong: {
                username: "Wrong", password: "wrong"
            }
        }
    }
}
```

Another alternative could be the use of a _common_ attribute, and reuse it in some cases. But, what happens when we need different _commons_ in different situations? We end up in the same approach.

### The solution

With _Rulet_ we organize the settings based on _rules_ and _tags_.

*   _rules_ are JS conditions on the first level of an object. You can create any kind of condition using _tags_. E.g:

```javascript
let settings = {
      // Rule 1
      "(myTag1 || myTag2) && myTag3": { mySetting: 123 },

      // Rule 2
      "myTag3": { myAnotherSetting: 456 }
  };
```

*   _tags_ are use to fetch the desired information. **_Rulet_** will apply all _rules_ from top to bottom, combining them.

```javascript
let tags = ['myTag3', 'myTag1'];

      let rulet = new Rulet(settings, tags);
      let outConfiguration = rulet.getConfiguration();

      console.log(outConfiguration); /* Will print: { mySetting: 123, myAnotherSetting: 456 } */
```

## A real example

```javascript
const Rulet = require('rulet');

let settings = {
    "qa || prod": {
        loginWrong: {
            username: "Wrong", password: "wrong"
        }
    },
    "(qa || prod) && firstApp": {
        loginRight: {
            username: "Right", password: "right"
        }
    },
    "qa && secondApp": {
        loginRight: {
            username: "RightForSecondApp", password: "right"
        }
    },
    "prod && secondApp": {
        loginRight: {
            username: "RightsForSecondAppInProd", password: "right"
        }
    }
};

let tags = ['qa', 'secondApp'];

let rulet = new Rulet(settings, tags);
let outConfiguration = rulet.getConfiguration();

console.log(outConfiguration);
/* Will print:
    {
        loginRight: { username: "RightForSecondApp", password: "right" },
        loginWrong: { username: "Wrong", password: "wrong" }
    }
*/
```