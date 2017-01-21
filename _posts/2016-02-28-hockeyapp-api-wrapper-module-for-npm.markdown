---
layout:     post
title:      "HockeyApp API Wrapper module for NPM"
author:     "eridem"
main-img: /img/featured/2016-02-28-hockeyapp-api-wrapper-module-for-npm.jpg
permalink:  hockeyapp-api-wrapper-module-for-npm
---

I created a module for Node.JS (NPM) which will allow us to obtain an APK download link directly from code in one of our apps.

[https://www.npmjs.com/package/hockeyapp-api-wrapper](https://www.npmjs.com/package/hockeyapp-api-wrapper)

## Init project

```bash
$ mkdir my-test-project
$ cd my-test-project
$ npm init
$ npm install --save hockeyapp-api-wrapper
```

## Testing the module

Create a file called ```app.js``` which the following contents.

*   ```YOUR_HOCKEYAPP_AUTH_TOKEN``` must be your HockeyApp Auth Token that you can find on your [HockeyApp Settings](https://rink.hockeyapp.net/manage/auth_tokens).
*   ```YOUR HOCKEY APP TITLE``` must be a valid app title that you can find on the [HockeyApp dashboard](https://rink.hockeyapp.net/manage/dashboard).

```javascript
// Import module
var HockeyApp = require('hockeyapp-api-wrapper');

var YOUR_HOCKEYAPP_AUTH_TOKEN = 'aaaabbbbccccdddd0000111122223333';

// Create API client. Note that you can create more than one at the same time.
var hockeyAppCli = new HockeyApp().init(YOUR_HOCKEYAPP_AUTH_TOKEN);

// Get all apps
hockeyAppCli.getApps().then(function(appsResponse) {
    // Get an specific app by the title
    var app = HockeyApp.getAppByTitleMatch(appsResponse, "YOUR HOCKEY APP TITLE");

    // Get all versions for that specific app
    hockeyAppCli.getVersions(app).then(function(versionResponse) {
        // Get latest version
        var version = HockeyApp.getLatestVersion(versionResponse);

        // Generate download link
        var downloadUrl = hockeyAppCli.getLatestAndroidVersionDownloadLink(app, version);

        // Print download link
        console.log(downloadUrl);
    });
});
```

The result will be something similar to:

```
https://rink.hockeyapp.net/api/2/apps/XXXXXXXXXXXXXXXXXXXX/app_versions/XXXX?format=apk
```