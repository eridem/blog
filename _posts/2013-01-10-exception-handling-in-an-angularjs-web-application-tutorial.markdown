---
layout:     post
title:      "Exception Handling in an AngularJS Web Application"
author:     "eridem"
header-img: "img/featured/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial.svg"
permalink:  exception-handling-in-an-angularjs-web-application-tutorial
external: http://blog.loadimpact.com/blog/exception-handling-in-an-angularjs-web-application-tutorial/
---

During this tutorial I will implement best practices for exception handling in an [AngularJS](https://docs.angularjs.org/api) web application. I’ll start creating the structure of a demo application, throw some test exceptions and intercept them. The second part of this tutorial will cover some frameworks that will help you organize your exception logs using [Raven](http://ravenjs.com/) with [Sentry](http://getsentry.com/).

# Creating web app structure

*Note: You can skip this section if you already know how to setup your web application with Yeoman and AngularJS.*

In order to use Yeoman to create a basic structure of your web app with *AngularJS*, you need to have installed Yeoman on your computer. A basic tutorial to install it can be found here: <http://yeoman.io/gettingstarted.html>

Once installed, run the following command and follow the instructions. When asked to install *SASS*, reply `N`. Rest of settings/questions can be set as default.

```bash
mkdir exceptionHandling
cd exceptionHandling
yo angular
```

The command will create a structure where you can find the structure of your web app and other files to configure it with Grunt and Bower (for more information, check <http://gruntjs.com> and <http://bower.io>). Now you are ready to execute your AngularJS application. Open a terminal and navigate to the root of your application. Run the following command to keep the web application running in the background:

```bash
grunt serve
```

Now, open your browser with the following url: <http://localhost:9001>

# Exceptions and Promises

## Exception

In order to keep a good structure of your exceptions, create an object for every throw exception. The structure of this thrown object should look like this (this is just an example):

```javascript
function MyException(message) {
  this.name = 'MyException';
  this.message= message;
}
MyException.prototype = new Error();
MyException.prototype.constructor = MyException;
```

Then, you can throw the exceptions as error objects:

```javascript
throw new MyException('Something was wrong!');
```

## Promises

Promise is an interface class that helps you to control if the call to a function – that may be executed asynchronously – has finished successfully or with an error. It is very similar to have a try-catch-finally block for async calls. This is just an example:

```javascript
function myAsyncFunction() {
  var deferred = $q.defer();
  // Doing something async...
  setTimeout(function() {

    // Notify AngularJS model about changes
    scope.$apply(function() {
      deferred.notify('Async method has ended.');
      
      /* This is just a random boolean value for the demo */
      var randomResult = (Math.random(2).toFixed(1) * 10) % 2;

      if (randomResult) {
        deferred.resolve('OK');
      } else {
        deferred.reject('FAIL');
      }
    });
  }, 1000);
  return deferred;
}
```

Then, you can call to your async function obtaining the results with the promise interface:

```javascript
myAsyncFunction()
  .then(successCallback)
  .catch (errorCallback)
  .finally(alwaysCallback);
```

# Throwing some exceptions

Now add to your controller a function that raises an exception. Open the file under the path `app/scripts/controllers/main.js` and write this content:

```javascript
'use strict';

angular.module('exceptionHandlingApp')
  .controller('MainCtrl', ['$scope', '$q',
    function($scope, $q) {
      function MainCtrlInitException(message) {
        this.name = 'MainCtrlInitException';
        this.message = message;
      }
      MainCtrlInitException.prototype = new Error();
      MainCtrlInitException.prototype.constructor = MainCtrlInitException;

      function init() {
        /* We just reject the promise of this function. Only for the demo */
        return $q.reject("Cannot init");
      }

      init().
      catch (
        function(cause) {
          throw new MainCtrlInitException(cause);
        });
    }
  ]);
```

As you can see in the example, in the function `init`, I reject the promise that will cause the catch interface to be called. Then, I throw a custom exception. Opening the console of your browser, you should see the results of this exception.

# Intercepting exceptions with Decorators

*AngularJS* has its own exception handler. You can override it with a Decorator that helps you to extend the functionality of an object in *AngularJS*. You can create a new Decorator using [Yeoman Angular Generator](https://github.com/yeoman/generator-angular) in the terminal applying the following command:

```bash
yo angular:decorator customExceptionHandler
```

This command will create a new file under the path: 

```app/scripts/decorators/customExceptionHandlerDecorator.js```

Replace its content with the following code:

```javascript
'use strict';

angular.module('exceptionHandlingApp')
  .config(function($provide) {
    $provide.decorator('$exceptionHandler', ['$log', '$delegate',
      function($log, $delegate) {
        return function(exception, cause) {
          $log.debug('Default exception handler.');
          $delegate(exception, cause);
        };
      }
    ]);
  });
```

In your browser, you should see the new result or your exception handler:

![Image 1](/img/posts/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial/image-1.png)

# Intercepting exceptions with Sentry

*Sentry* is a system that helps you organize your exceptions using a web application. You can setup an account on <http://getsentry.com> or install it on your own server. You will need to create a new project and obtain the API key to interact with your application.

![Image 2](/img/posts/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial/image-2.png)

Be sure that you configure your hosts file to point your localhost as another domain. In windows, you can find this file under `%SYSTEMROOT%\System32\drivers\etc\hosts` or in Linux/Mac under `/etc/hosts` For example, you can use:

```
127.0.0.1   example.com
```

And configure *Sentry* to accept calls from *example.com*:

![Image 3](/img/posts/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial/image-3.png)

In order to interact with *Sentry*, we will need to use *RavenJS* with *Sentry*. On the bottom of your `app/index.html` file, before the last body tag, add the following line:

```html
<script src="//cdn.ravenjs.com/1.1.14/jquery,native/raven.min.js"></script>
```

```javascript
// app/scripts/app.js

/* global Raven:true */
'use strict';

angular
  .module('exceptionHandlingApp', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute'
  ])
  .config(function ($routeProvider) {
      Raven.config('https://7be...............491@app.getsentry.com/2...2', {
        logger: 'Error Handling Demo',
      }).install();

    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });
  });
```

You will create a Decorator that interacts with *Sentry*, sending the exceptions to that server. You can use Yeoman Angular Generator:

```bash
yo angular:decorator sentryExceptionHandler
```

And replace the content of the file under `app/scripts/decorators/sentryExceptionHandlerDecorator.js`:

```javascript
/* global Raven:true */
'use strict';

angular.module('exceptionHandlingApp')
  .config(function($provide) {
    $provide.decorator('$exceptionHandler', ['$log', '$delegate',
      function($log, $delegate) {
        return function(exception, cause) {
          $log.debug('Sentry exception handler.');
          Raven.captureException(exception);
          $delegate(exception, cause);
        };
      }
    ]);
  });
```

Congratulations! Now you will see your exceptions appear on *Sentry*:

![Image 4](/img/posts/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial/image-4.png)

![Image 5](/img/posts/2013-01-10-exception-handling-in-an-angularjs-web-application-tutorial/image-5.png)
