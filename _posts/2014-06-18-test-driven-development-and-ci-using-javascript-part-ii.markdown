---
layout:     post
title:      "Test Driven Development and CI using JavaScript [Part II]"
description: "Code Quality"
author:     "eridem"
featured-image: "img/featured/2014-06-18-test-driven-development-and-ci-using-javascript-part-ii.jpg"
permalink:  test-driven-development-and-ci-using-javascript-part-ii
external: http://blog.loadimpact.com/blog/test-driven-development-and-ci-using-javascript-part-ii/
---

*This is the second half of a two part article on Test Driven Development and Continuous Integration (CI) using JavaScript.*

Behavior-Driven Development (BDD) is a specialized version of Test Driven Development (TDD) focused on behavioral specifications. Since TDD does not specify how the test cases should be done and what needs to be tested, BDD was created in response to these issues.

It's easy to talk about Behavioral Driven Development (BDD), but it's more difficult to actually put it into practice. BDD is a fairly new concept, so it's not completely intuitive for some coders who have been working with Continuous Integration (CI) for a long time.

This article gives a real-world example application using the concept of a `Shapes` object. The `Shapes` object contains classes for each shape and the application is a small JavaScript application that uses BDD for testing.

# BDD and Software Testing

This tutorial covers how to use BDD to test your JavaScipt code. In the following example, some test cases are written along with the corresponding code. The code is then refactored to fix bug issues.

Project: *Create an application that contains a set of shapes. For every shape, calculate its area.*

## Application structure

You can create different kinds of folder structures for your applications. For example, you can divide your code into public and private folders to correspond to your class types.

Create a structure for your project using the following:

```
+ public 
   + javascripts 
       + app
       + lib 
           - require.js 
+ private
   + javascripts 
       + lib 
           + jasmine-2.0.0 
       + spec 
- SpecRunner.html
```

Save your Jasmine libraries in the private folder. In the public folder, store *RequireJS* to use in your models.

## Creating a test

Using TDD as methodology, you start creating small test cases. Test cases require good design, but you also need to consider your code. You can also rewrite some of your test cases as you improve your code.

Start creating tests for your application. For example, the following is a list of considerations you could make about your application:

*   Do you want to organize my shapes into classes? Since a shape could represent one object, it's a good idea to design a class for each shape.
*   You will probably need a method to calculate the area of your shapes.

The following is a test case that fits the above two code requirements:

```javascript
// /private/javascripts/spec/Shape/SquareSpec.js

describe("Shapes", function () {
    describe("Square", function () {
        var that = this;

        beforeEach(function (done) {
            require(['Shape/Square'], function (Square) {
                that.shape = new Square();
                done();
            });
        });

        it("with side 0 should have an area of 0", function () {
            expect(that.shape.getArea(0)).toBe(0);
        });

        it("with side 2 should have an area of 4", function () {
            expect(that.shape.getArea(2)).toBe(4);
        });

        it("with side 4 should have an area of 16", function () {
            expect(that.shape.getArea(4)).toBe(16);
        });

        it("with side 123.123 should have an area of 15159.27", function () {
            expect(that.shape.getArea(123.123)).toBe(Math.pow(123.123, 2));
        });
    });
});
```

The above test case fits the division specifications.

*   Suites: The method describe is used with the story's name. In this case, you want to `describe` the actions to apply to `Shape` and `Square`. The second argument is a function, which will contain Spec or more Suites.
*   Spects: The keyword `it` is used with a "_with XXX should_" sentence. The way the sentence is written varies with the test case, but you should always write it as if you are writing a user story.  The second argument is a function where you start using your code for testing.
*   Expect: This statement helps you test code with simple sentences for output. These statements usually do comparisons between values. They start with `expect` and find different kinds of "Matches," which are comparison functions. An example of a "Match" is the function `toBe`.

This code gives you tips for organizing the code later. The story for the first test looks like this:

*   **Given** a Shape which is a Square
*   **And** with side 0
*   **Then** the shape should have an area of 0

In order to create this story and obtain the right result, you create expectations:

*   `expect` the area of 0 `toBe` 0

As you can see, it is very easy to read the tests, which allows you to create stories.

## Creating the model

Now that we did a small test, we may have some idea about how to organize our code. We will create a base class called Shape.js and a class that represents the shape `Square`.

```javascript
// /public/javascripts/app/Shape/Shape.js

define("Shape/Shape", [], function() {
    function Shape() {
    }

    Shape.prototype.getArea = function() {
        return 0;
    };

    return Shape;
});
```

```javascript
// /public/javascripts/app/Shape/Square.js
define("Shape/Square", ["Shape/Shape"], function (Shape) {
    function Square() {
        Shape.call(this);
    }
    Square.prototype = new Shape();
    Square.prototype.constructor = Square;

    Square.prototype.getArea = function (side) {
        return side * side;
    };

    return Square;
});
```

As you can see, our shape contains a method to calculate the area. In the case of the `Square`, we need to pass it an argument for the `side`.

## Running tests

A SpecRunner file is a file that runs all your test cases. You can organize them into suites and sets of `SpecRunners`. For this example, you create one file that runs all test cases.

Open the file _SpecRunner.html_ and modify it with the following content:

```html
<!-- /SpecRunner.html -->
<!DOCTYPE HTML>

<html>

<head>
  <metahttp-equiv="Content-Type"content="text/html; charset=UTF-8">
  <title>Jasmine Spec Runner v2.0.0</title>

  <link rel="shortcut icon"type="image/png" href="private/javascripts/lib/jasmine-2.0.0/jasmine_favicon.png">
  <link rel="stylesheet"type="text/css" href="private/javascripts/lib/jasmine-2.0.0/jasmine.css">

  <script type="text/javascript" src="public/javascripts/lib/require.js"></script>
  <script type="text/javascript">
    requirejs.config({
    baseUrl: 'public/javascripts/app',
    paths: {
        jasmine: 'private/javascripts/lib/jasmine-2.0.0/jasmine'
    },
    shim: {
        jasmine: {
            exports: 'jasmine'
        }
    }
    });
  </script>

  <script type="text/javascript" src="private/javascripts/lib/jasmine-2.0.0/jasmine.js"></script>
  <script type="text/javascript" src="private/javascripts/lib/jasmine-2.0.0/jasmine-html.js"></script>
  <script type="text/javascript" src="private/javascripts/lib/jasmine-2.0.0/boot.js"></script>

  <!-- include source files here... -->
  <script type="text/javascript" src="public/javascripts/app/Shape/Square.js"></script>

  <!-- include spec files here... -->
  <script type="text/javascript" src="private/javascripts/spec/Shape/SquareSpec.js"></script>
</head>

<body></body>

</html>
```

The content is divided in three main sections:

*   Load and configure libraries for requireJS (`public/javascripts/lib/require.js`).
*   Load the necessary libraries for Jasmine (`private/javascripts/lib/jasmine/...`).
*   Load the application source files (`public/javascripts/app/Shape/Square.js`).
*   Load the test source files (`private/javascripts/spec/Shape/SquareSpec.js`).

If you execute (open) the file with your favorite browser, you see the following result:

![Green Lines copy](/img/posts/2014-06-18-test-driven-development-and-ci-using-javascript/green-lines-copy.png)

All green labels show us that all tests have been passed correctly.

#### Refactoring code

In most cases, you'll need to do a least a little refactoring after running your test cases. The following is an example of some real-world questions you could have about the test case results:

*   You could set the size of "*side*" using the method `setSide` instead of passing it though `getArea` method.

Do the following changes to the test cases, which create a new method `setSide`:

```javascript
// /private/javascripts/spec/Shape/SquareSpec.js

describe("Shapes", function () {
   describe("Square", function () {
      var that = this;

      beforeEach(function (done) { 
            require(['Shape/Square'], function (Square) { 
              that.shape = new Square(); 
              done(); 
            }); 
      });

      it("with side 0 should have an area of 0", function () { 
         **that.shape.setSide(0);** 
         expect(that.shape.**getArea**()).toBe(0); 
      });

      it("with side 2 should have an area of 4", function () { 
         **that.shape.setSide(2);** 
         expect(that.shape.**getArea**()).toBe(4); 
      });

      it("with side 4 should have an area of 16", function () { 
         **that.shape.setSide(4);** 
         expect(that.shape.**getArea**()).toBe(16);
      });

      it("with side 123.123 should have an area of 15159.27", function () { 
         **that.shape.setSide(123.123);** 
         expect(that.shape.**getArea**()).toBe(Math.pow(123.123, 2)); 
    }); 
  }); 
});
```

After you make the changes to the test cases, refresh your browser. In this example, the test cases fail.

![fail copy](/img/posts/2014-06-18-test-driven-development-and-ci-using-javascript/fail-copy.png)

Since the test cases failed, you know you've broken your application. The failed test cases are the advantage of BDD since these test cases let you know that there are errors in your application - before you write too much code. Because you've only written a small amount of code, you only have a small amount of code to refactor from the failed test cases. If you had written the entire application, you would have hours of refactoring ahead of you. Even if you have one class used in several modules, every module has its own test.

Now we can fix the model:

```javascript
// /public/javascripts/app/Shape/Square.js

define("Shape/Square", ["Shape/Shape"], function (Shape) {    
    function Square() {
        Shape.call(this);

        this.side = 0;
    }
    Square.prototype = new Shape();
    Square.prototype.constructor = Square;

    Square.prototype.setSide = function (value) {
        this.side = value;
    };

    Square.prototype.getArea = function () {
        return this.side * this.side;
    };

    return Square;
});
```

After you refactor your code, the tests will now run successfully.

In this tutorial, a basic use for TDD in JavaScript was used. However, you can use TDD in any language that supports test cases.
