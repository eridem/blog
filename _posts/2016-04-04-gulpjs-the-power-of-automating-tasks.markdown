---
layout:     post
title:      "Gulp.js, the power of automating tasks"
author:     "eridem"
main-img: img/featured/2016-04-04-gulpjs-the-power-of-automating-tasks.png
permalink:  gulpjs-the-power-of-automating-tasks
---

[Gulp.js](http://gulpjs.com/) is a task runner and/or build system. We use Gulp.js for agile development processes and repetitive tasks. It is divided into ```tasks``` to define different operations; ```watchers``` to triggers operations on file system changes; ```pipes``` to connect operations on the process; and a long list of [available plugins](http://gulpjs.com/plugins/) from the community.

You can find snippets for Visual Studio on the following repository: <https://github.com/eridem/gulpjs-the-power-of-automating-tasks>

## Contents

*   [Requirements](#requirements)
*   [Set up a Gulp.js project](#setUpAGulpJSProject)
*   [Creating tasks](#creatingTasks)
    *   [Tasks with arguments](#tasksWithArguments)
    *   [Task dependencies](#taskDependencies)
*   [Watchers](#watchers)
    *   [Watch options](#watchOptions)
*   [Pipes, sources and destinations](#pipesSourcesAndDestinations)
    *   [Async tasks](#asyncTasks)

## Requirements

We need to install nodejs on our computer following the instructions from their [main website](https://nodejs.org/).

## Set up a Gulp.js project

Access your terminal and create a new folder for this example. We will install all needed packages:

```javascript
$ mkdir gulp-tutorial
$ cd gulp-tutorial
$ gulp install -g gulp-cli # Install Gulp Client globally
$ npm install gulp --save-dev # Install Gulp on our project
$ npm install gulp-util del gulp-notify q through2 --save-dev # Libraries to use in our examples

```

The main point for Gulp is the ```gulpfile.js``` file. Let's start adding the basic packages inside this file:

```javascript
'use strict';
var gulp = require('gulp');
var gutil = require('gulp-util');
var del = require('del');
var notify = require('gulp-notify');
```

The packages ```gulp``` and ```gutil``` are part of the Gulp.js project. ```del``` and ```notify``` will be used for the examples later on.

## Creating tasks

Gulp.js is based on a set of tasks that can be executed synchronously or asynchronously.

Each task has a name and function that will be executed as soon as the task is invoked. Append the following tasks to your _gulpfile.js_ file:

```javascript
gulp.task('sayHi', function () { // gulp sayHi
    gutil.log(gutil.colors.yellow('Hello!'));
});

gulp.task('sayBye', function () { // gulp sayBye
  gutil.log(gutil.colors.yellow('Bye bye!'));
});
```

Then, access to the terminal and write:

```bash
$ gulp sayHi
> Hello!
$ gulp sayBye
> Bye bye!
```

As we can see, we can use the _gulp_ client to execute those tasks from the terminal.

### Tasks with arguments

We can pass arguments to the task from the terminal using the following syntax:

```bash
gulp MYTASK --ARG_NAME ARG_VALUE
```

Using _gutil_ we can access the variables from the terminal. Let's take this task, for example:

```javascript
gulp.task('sayCheers', function () { // gulp sayCheers --name YOUR_NAME
  var name = gutil.env.name || 'No name';
  gutil.log(gutil.colors.red('Cheers'), gutil.colors.red(name));
});
```

And execute the command:

```bash
gulp sayCheers --name ERiDeM
```

### Task dependencies

Gulp tasks can be executed in three different ways:

*   manually from the Gulp client (terminal);
*   by dependency of another task;
*   by a watcher (we will go into this later).

When Gulp tasks depends of other tasks, we can create a task chain.

In the following example we will see some tasks that represent a person's daily actions: Wake up, Take shower, Dress Up and Let's go. As we will see in the code, the second argument of a task could be an array of task dependencies.

```javascript
gulp.task('daily:wakeUp', function () { 
  gutil.log(gutil.colors.red('Daily:'), gutil.colors.red('Wake up'));
});

gulp.task('daily:takeShower', ['daily:wakeUp'], function () {
  gutil.log(gutil.colors.red('Daily:'), gutil.colors.red('Take shower'));
});

gulp.task('daily:dressUp', ['daily:wakeUp', 'daily:takeShower'], function () {
  gutil.log(gutil.colors.red('Daily:'), gutil.colors.red('Dress up'));
});

gulp.task('letsgo', ['daily:dressUp'], function () {  // gulp letsgo
  gutil.log(gutil.colors.red('Go go go!'));
});
```

Gulp will resolve the order of dependencies and it will not repeat a task if it has already been executed. In this example, when running "letsgo", we will see the following output:

```
Daily: wake up
Daily: Take shower
Daily: Dress up
Go go go!
```

As we can see, "dressUp" has dependencies on "wakeUp" and "takeShower", but even "wakeUp" depends on two different tasks. It's resolved by Gulp and it doesn't execute twice.

## Watchers

A ```watch``` on Gulp represents a change on the file system that triggers one task or a set of tasks. For this example, we need to create the following file structure. You can decide what to add inside the files:

```
- src
  - module
    - dev
      - file03.dev
      - file04.dev
    - text
      - file01.txt
      - file02.txt
```

We would like that the _letsgo_ task is automatically executed on changes in any file inside the _src_ folder. We can create the following task that will run a watch:

```javascript
gulp.task('watcherCommon', function () {
  gulp.watch(['src/**/*'], ['letsgo']);
});
```

When we execute this task from the terminal, using _gulp watcherCommon_, Gulp will keep running, listening for new changes.

If we do a change on any file, _letsgo_ will be executed and we will see this message on the screen:

```
Daily: wake up
Daily: Take shower
Daily: Dress up
Go go go!
```

As previously explained, the Gulp will figure out the order of the tasks to execute. To prove this, we will "mess up" the tasks:

```javascript
gulp.watch(['src/**/*'], ['daily:wakeUp', 'daily:dressUp', 'letsgo', 'daily:wakeUp', 'daily:takeShower']);  
gulp.watch(['src/**/*'], ['daily:wakeUp', 'letsgo', 'daily:dressUp']);
```

Both watchers, will have the same results than the previous example.

### Watch options

Watchers can be delayed. There are two kinds of delays:

*   Delay the execution of the watch every time a file changes: interval;
*   Sleep the watch for some time and listen after it: debounceDelay.

```javascript
gulp.task('watcherAdvanced', function () {
  var options = {
    interval: 5000,
    debounceDelay: 5000,
  };

  var watcher = gulp.watch(['src/**/*'], options, ['daily:wakeUp']);

  watcher.on('change', function (event) {
    gutil.log(gutil.colors.red('change:'), gutil.colors.yellow(JSON.stringify(event)));  // type = [added|changed|deleted], path = "..."
  });
});
```

## Pipes, sources and destinations

One of the main features from Gulp.js is the capability to pipe actions. Using ```.pipe(...)``` we can stream [Vinyl files](https://github.com/gulpjs/vinyl-fs) from one pipe to another one.

Gulp gives us to default features to start with. ```.src``` will obtain all files to start working on the pipe (each file is processed individually). Meanwhile, ```.dest``` will save the results into files.

```javascript
gulp.task('op:copyFiles', function () {

  return gulp.src(['./src/**/*.txt', '!./src/**/*.dev'])
    .pipe(gulp.dest('./dest')); 

});

```

We can combine different _dest_ in order to save the results in different places.

The power of gulp is using different plug-ins that we can attach on the pipe method to do different transformations. For instance, the following code will do the same thing as the previous one but will show a message for each file processed (note that it is based on the plugin "gulp-notify"):

```javascript
gulp.task('op:copyFiles', function () {

  return gulp.src(['./src/**/*.txt', '!./src/**/*.dev'])
    .pipe(gulp.dest('./dest'))
    .pipe(notify('Task: copy a file'));

});

```

### Async tasks

Commonly, we will want our tasks to be async, so they can take as much time they need before pass to the next one. Or maybe we want to execute different tasks in parallel.

We can make our tasks async two different ways.

Using callbacks on the task function:

```javascript
gulp.task('op:copyFiles', function (cb) {
   var exec = require('child_process').exec;
   exec('background work', function (err) {
     setTimeout(function () {
       gutil.log(gutil.colors.red('Task:'), gutil.colors.yellow('Copying files'));

       gulp.src(['./src/**/*.txt', '!./src/**/*.dev'])
       .pipe(gulp.dest('./dest'))     
       .pipe(notify('Task: copy a file')); 

       cb();
     }, 1000);
   }); 
}

```

Returning a Promise (most common):

```javascript
gulp.task('op:copyFiles', function (cb) {
   var Q = require('q');
   // do async stuff
   var deferred = Q.defer();
   setTimeout(function () {
     gutil.log(gutil.colors.red('Task:'), gutil.colors.yellow('Copying files'));

     gulp.src(['./src/**/*.txt', '!./src/**/*.dev'])
              .pipe(gulp.dest('./dest'))
              .pipe(notify('Task: copy a file')); 

     deferred.resolve();
   }, 1000);
}

```

## Conclusion

During this post, we went though the most common features of Gulp.js. Now that we understand the syntax, we have a longer journey of plugin discovering and receipts from people are using on their main projects! Enjoy automating your tasks!