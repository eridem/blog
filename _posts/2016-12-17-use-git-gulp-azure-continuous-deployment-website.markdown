---
layout:     post
title:      "Use Git, Gulp and Azure for Continuous Deployment a Website"
author:     "eridem"
main-img: "img/featured/2016-12-17-use-git-gulp-azure-continuous-deployment-website.jpg"
permalink:  use-git-gulp-azure-continuous-deployment-website
---

During these years I am being using a variety of CI and CD tools such as [Jenkins](https://jenkins.io/), [Travis CI](https://travis-ci.com/), [TeamCity](http://www.jetbrains.com/teamcity/), [Bamboo](https://www.atlassian.com/software/bamboo), [Octopus](https://octopus.com/), ... for Continuous Integration and Deployment. Each one has POS and CONS and in most of the cases we choose the alternative that the developers feel more comfortable with and the variety of projects within the company.

## Objective

The objective of this tutorial is to automate the deployment of a website in *Azure*:

- We will use `GIT` to trigger the automatic deployment when a branch changes.
- We will run [`Gulp`](/gulpjs-the-power-of-automating-tasks) to generate our website within Azure.
- We will use the results of the `Gulp` task to deploy our website `./dist`.

![Process](/img/posts/2016-12-17-use-git-gulp-azure-continuous-deployment-website/schema.png)

## Setting up GULP

For this example, we will create a task called `build` that will generate our website inside a folder called `dist`.

```
+ project
  + src
  + dist
  - gulpfile.js
```

How we configure the task `build` may depend between projects.

```javascript
// gulpfile.js
// ...

gulp.task('build', function() {
  // Your way to build a website for production-ready. Example:
  return gulp.src(['./src'])
    .pipe(gulp.dest(conf.paths.dist));
})
```

## Creating an Azure Web App to host our website

In order to host our website, we will create a new `Web App`. 

- Go to the [Azure portal](https://portal.azure.com) and click on the `+` symbol.
- Search and click on the `Web App` featured apps.
- Follow the steps to generate a new resource for hosting your website.

![Create Web App from Azure](/img/posts/2016-12-17-use-git-gulp-azure-continuous-deployment-website/create-web-app-from-azure.jpg)

When the website is created:

- Select your application
- Select menu `Deployment options`
- Select `Choose Source`.
- Azure will ask you several questions to access to your GIT repository. Follow the steps and connect your website to `master`, `release` or any of the branches you may use to have the latest stable changes.

![Select Deployment Options](/img/posts/2016-12-17-use-git-gulp-azure-continuous-deployment-website/select-deployment-options.jpg)

## Running Gulp and deploying the `dist` folder

At this moment, for each change you `push` to the branch you configured on this section, Azure will try to deploy the website using all the sources from this repository.

This is something that we may like in some projects, but our objective is run *Gulp* before the deployment and pick only the `dist` folder.

Firstly we access to our repository path via terminal and install the Azure CLI tool and generate the Azure scripts for deployment:

```bash
npm install azure-cli --global
azure site deploymentscript --node
```

This will generate two new files that we will `commit` to our repository:

```
+ project
  + src
  + dist
  - gulpfile.js
  - .deployment
  - deploy.cmd
```

We will open the file `deploy.cmd` and go to the section `:: Deployment`. You should have a section similar to this one:

```
:Deployment
echo Handling node.js deployment.

:: 1. KuduSync
IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (
  call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
  IF !ERRORLEVEL! NEQ 0 goto error
)

:: 2. Select node version
call :SelectNodeVersion

:: 3. Install npm packages
IF EXIST "%DEPLOYMENT_TARGET%\package.json" (
  pushd "%DEPLOYMENT_TARGET%"
  call :ExecuteCmd !NPM_CMD! install --production
  IF !ERRORLEVEL! NEQ 0 goto error
  popd
)
```

Which we will modify it and reorder some steps:

1. Select node version
2. Install npm packages
3. Execute Gulp
4. KuduSync

Here the final result for the section:

```
:Deployment
echo Handling node.js deployment.

:: 1. Select node version
call :SelectNodeVersion

:: 2. Install npm packages
IF EXIST "%DEPLOYMENT_SOURCE%\package.json" (
  call :ExecuteCmd !NPM_CMD! install
  IF !ERRORLEVEL! NEQ 0 goto error
)

:: 3. Execute Gulp
IF EXIST "%DEPLOYMENT_SOURCE%\gulpfile.js" (
    call .\node_modules\.bin\gulp build
    IF !ERRORLEVEL! NEQ 0 goto error
)

:: 4. KuduSync
IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (
  call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%\dist" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
  IF !ERRORLEVEL! NEQ 0 goto error
)
```

- Now we execute `npm install` firstly which will install all dependencies needed. You may need to use or remove the flag `--production` depending if you need development tools or not during the process.
- We execute the `gulp build` task in the third step.
- We copy the results into the deployment target: `%DEPLOYMENT_SOURCE%\dist` => `%DEPLOYMENT_TARGET%`

## Testing locally

If you would like to test the scripts from your local machine, you can run the script `deploy.cmd` from your project. This will generate a folder one folder back called `..\artifacts`.

The website inside `..\artifacts\wwwroot` will be the one your website is contained and the one the Azure Web App will use.

> Happy coding!