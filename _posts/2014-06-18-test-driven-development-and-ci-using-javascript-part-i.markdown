---
layout:     post
title:      "Test Driven Development and CI using JavaScript [Part I]"
description: "Code Quality"
author:     "eridem"
featured-image: "img/featured/2014-06-18-test-driven-development-and-ci-using-javascript-part-i.jpg"
permalink:  test-driven-development-and-ci-using-javascript-part-i
external: http://blog.loadimpact.com/blog/test-driven-development-and-ci-using-javascript-part-i/
---

In this tutorial, we will learn how to apply TDD (Test-Driven Development) using JavaScript code. This is the first part of a set of tutorials that includes TDD and CI (Continuous Integration) using JavaScript as the main language.

### Some types of testing

There are several approaches for testing code and each come with their own set of challenges. Emily Bache, author of _The Coding Dojo Handbook_, writes about them in more detail on her blog - [Coding is like cooking](http://coding-is-like-cooking.info/)

1.  Test Last: in this approach, you code a solution and subsequently create the test cases.
    *   Problem 1: It's difficult to create test cases after the code is completed.
    *   Problem 2: If test cases find an issue, it's difficult to refactor the completed code.
2.  Test First: you design test cases and then write the code.
    *   Problem 1: You need a good design and formulating test cases increases the design stage, which takes too much time.
    *   Problem 2: Design issues are caught too late in the coding process, which makes refactoring the code more difficult due to specification changes in the design. This issue also leads to scope creep.

![tdd-diagram-1](/img/posts/2014-06-18-test-driven-development-and-ci-using-javascript/tdd-diagram-1.png)

3.  Test-Driven: You write test cases parallel to new coding modules. In other words, you add a task for unit tests as your developers are assigned different coding tasks during the project development stage.

![tdd-diagram-2](/img/posts/2014-06-18-test-driven-development-and-ci-using-javascript/tdd-diagram-2.png)

### TDD approach

[TDD](https://en.wikipedia.org/wiki/test-driven_development) focuses on writing code at the same time as you write the tests. You write small modules of code, and then write your tests shortly after. Patterns to apply to the code:

*   Avoid direct calls over the network or to the database. Use interfaces or abstract classes instead.
*   Implement a real class that implements the network or database call and a class which simulates the calls and returns quick values (`Fakes` and `Mocks`).
*   Create a constructor that uses `Fakes` or `Mocks` as a parameter in its interface or abstract class.

Patterns to apply to unit tests:

*   Use the `setup` function to initialize the testing, which initializes common behavior for the rest of the unit test cases.
*   Use the `TearDown` function to release resources after a unit test case has finalized.
*   Use `assert()` to verify the correct behavior and results of the code during the unit test cases.
*   Avoid dependency between unit test cases.
*   Test small pieces of code.

### Behavior-Driven Development

[Behavior-Driven Development (BDD)](https://en.wikipedia.org/wiki/behavior-driven_development) is a specialized version of TDD focused on behavioral specifications. Since TDD does not specify how the test cases should be done and what needs to be tested, BDD was created in response to these issues. Test cases are written based on user stories or scenarios. Stories are established during the design phase. Business analysts, managers and project/product managers gather the design specifications, and then users explain the logical functionality for each control. Specifications also include a design flow so test cases can validate proper flow. This is an example of the language used to create a BDD test story:

> **Story**: Returns go to stock **In order** to keep track of stock **As a** store owner **I want to** add items back to stock when they're returned

* * *

> **Scenario 1**: _Refunded items should be returned to stock_ **Given** a customer previously bought a black sweater from me **And** I currently have three black sweaters left in stock* **When** he returns the sweater for a refund* **Then** I should have four black sweaters in stock*

* * *

> **Scenario 2**: Replaced items should be returned to stock* **Given** that a customer buys a blue garment* **And** I have two blue garments in stock* **And** three black garments in stock.* **When** he returns the garment for a replacement in black,* **Then** I should have three blue garments in stock* **And** two black garments in stock

## Frameworks to Install

### 1\. Jamine

[Jasmine](http://jasmine.github.io) is a set of standalone libraries that allow you to test JavaScript based on BDD. These libraries do not require DOM, which make them perfect to test on the client side and the server side. You can download it from [http://github.com/pivotal/jasmine](http://github.com/pivotal/jasmine). It is divided into `suites`, `specs` and `expectations`.

*   `Suites` define the unit's story.
*   `Specs` define the scenarios.
*   `Expectations` define desired behaviors and results.

Jasmine has a set of helper libraries that lets you organize tests.

### 2\. RequireJS

RequireJS is a Javascript library that allows you to organize code into modules, which load dynamically on demand. By dividing code into modules, you can speed up the load-time for application components and have better organization of your code. You can download *RequireJS* from [http://www.requirejs.org](http://www.requirejs.org/)
