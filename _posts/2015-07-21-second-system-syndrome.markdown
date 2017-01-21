---
layout:     post
title:      "Second System Syndrome"
author:     "eridem"
#header-img: "img/featured/2015-07-21-second-system-syndrome.png"
#featured-author: Eridem
#featured-link: http://eridem.net
permalink:  second-system-syndrome
external: http://blog.loadimpact.com/blog/devops/second-system-syndrome/
---

This post is about a concept called Second System Syndrome, defined by Fred Brooks, in his book [The Mythical Man Month](http://www.amazon.com/Mythical-Man-Month-Software-Engineering-Anniversary/dp/0201835959):

> It refers to a condition that occurs after a first system has been implemented. When it seems to be working well, designers turn their attention to a more elaborate second system, which is often bloated and grandiose and fails due to its over-ambitious design. In the meantime, the first system may also fail because it was abandoned and not continually refined.

### Table of Contents

*   [Prologue](#prologue)
*   [Promises](#promises)
*   [Starting a Second System Syndrome](#starting)
*   [Knowledge](#knowledge)
*   [Team and rivalities](#teamAndRivalities)
*   [Feature race](#featureRace)
*   [Outside the Second System Syndrome](#outside)
*   [Presentation](#presentation) (presentation I did in my company)

### Prologue {#prologue}

Maybe, you as a reader, could recognize the following expression coming from your team:

> This system looks like crap and the code of the previous guy is understandable. We should implement it again avoiding mistakes made in the past with the best code practices and using the latest architectural designs.

As soon as this idea flourishes in the minds of team members, it’s difficult to take out.

Here are some reasons people try to salvage old code:

*   New developers in the company may not understand the previous architecture and code
*   New technologies have been learned during the latest years and the use of those in the current project, which implies to completely modify completely the system
*   The current system is unstable due to many applied hotfixes. It can be difficult to maintain those hotfixes

### Promises {#promises}

Commonly, managers, developers and architects gather to talk about it. They end up with great proposals in order to define how the new system should work:

> Better architecture. Split the design into modules with specific functionality.
> Generic design: We will easily make changes in the future and quickly.
> Less code: We will avoid repeated code, which the old system has.
> The latest technologies: Maybe they’ll also use the top notch frameworks that the community believes right now.
> Knowledge: If it exists already an implemented system and we know how it works.
> Fast delivery: Because we will have a better design, better technologies and a better approach, we will be able to finish it quickly.

All of those ideas are promising. Probably, in some cases, they are the solution to the current system. The idea of improving an existing system is something that we as developers need to embrace.

But the main idea and discussion I would like to cover in this entry comes which the following sentence:

> It will be easier to redo it than to fix it. Let’s start over.

### Starting {#starting}

All promises are gathered and the new approach started. Everybody has input for the new project, team seems to be happy (check section "[Team and Possible Conflicts](#teamAndRivalities)"). The project starts, or the [POC](https://en.wikipedia.org/wiki/Proof_of_concept) starts.

### Knowledge {#knowledge}

Some of the problems with the Second System Syndrome come with the knowledge of the [functional requirements](https://en.wikipedia.org/wiki/Functional_requirement).

The previous system, usually, does not have enough [test cases](https://en.wikipedia.org/wiki/Unit_testing) to prove that one specific functional requirement works correctly. This may slow down the progress of the second system because it could be difficult to prove the new implementation of a feature works exactly as before.

The first system may lack documentation. This issue could come from poor definition of [use cases](https://en.wikipedia.org/wiki/Use_case), documentation about the architecture and information about hotfixes patched in the previous system.

##### Found issues

*   Spend a lot of time trying to reproduce the behaviors of the first system
*   Spend time reading about the previous system directly from the first system code in order to locate valuable information
*   Hotfixes may not be documented

##### Possible solutions within a Second System Syndrome stage

*   Gather [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product) and functional requirements.
*   Add unit tests to the old system in order to test behaviors and functional requirements. For example, use [Behavior-driven development](https://en.wikipedia.org/wiki/Behavior-driven_development) frameworks like [Jasmin](https://jasmine.github.io/)
*   Create UX diagrams to understand the user experience flow of the application (e.g. using [Balsamiq](https://balsamiq.com/) or [Axure](http://www.axure.com/))
*   Create architecture diagrams in three layers: overview, module definition and detailed description
*   Spend more time learning about what previous system does. This may sound obvious but teams tend to ignore what has been done previously

### Team and Possible Conflicts {#teamAndRivalities}

People are the most important part of the project. From professionals to beginners, everybody has a role in the team. Figure out what role can help to create products with better quality and in a sorted way. As an example, two extremely "professional" members working in a project that cannot work as a team will end up in an unfinished and poor product.

It's also important to remember that team members could be affected from the Second System Syndrome. Professionally and personally.

Developers tend to embrace new technologies. When a second system needs to be implemented, it’s common to use new technologies or frameworks.

Team members may like to participate on the second system project, which could offer them more knowledge.

As the first system needs to be maintained, this could affect to some of the members that cannot participate full-time on the second system.

*   In the technical perspective, team members think their knowledge has not been improved because they do not participate in the second system
*   In the personal perspective, the team members could have difficulties collaborating between each other, which breaks the close cooperation that they had previously

Team members may not be opened to express their disappointments, or they could express them in bad ways.

##### Found issues

*   Team members may be affected professionally and personally

##### Possible solutions within a Second System Syndrome stage

*   Open discussions about ideas, technologies and feelings
*   Have a leader that can help cheer up the team
*   Accept and analyze suggestions from the team
*   Rotate members to implement maintenance the first system and implement the second one

### Feature race {#featureRace}

Features never end in a project. Features can be shaped as functional or nonfunctional requirements.

Normally, while the second system is being implemented, the first one is in production. Products change quickly and clients and salesmen agree to release features that are needed on the market.

Some important features can be planned to be implemented on the first system, that is currently in production, because they may start generating income to the company in short time.

The following diagrams explain the feature race between both systems:

![Feature race](/img/posts/2015-07-21-second-system-syndrome/FeatureRace.png)

In the first stage (stage A), the second system has been planned to have the same number of features that the first one. The architecture and design could cover those features and be slightly dynamic for changes.

When the first important feature is introduced on the first system, the second system needs to record it for future implementation (stage B).

Usually, the first system is able to implement and release the feature faster than the second system. Usually the second system is still implementing the missing features that the first system contains.

The following table describes the work needed on both systems:

| First system | Second System |
| --- | --- |
| Maintenance bugs/improvements | Maintenance bugs/improvements |
| Add new features | Add new features |
| Refactoring (make code better) | Refactoring (make code better) |
| Add test cases | Add test cases |
| - | Design new code/architecture |
| - | Implement missing features |

Note that refactoring the first system and add test cases could be slower than in the second system, which means that even the diagram shows the new feature with the same width (estimation), this could apply differently between systems.

The maintenance of the first system (refactoring and testing it) could end up in a feature race, where the first system may improve significantly before the second system is done. Adding new features in the second system may break the estimations done originally when the project started.

##### Found issues

*   First system may need still to implement some features due are required by managers/POs/salesmen/etc.
*   The curve to finish the second system may increment in the middle of the project
*   If the first system, which is on production, decides not to incorporate new features, competitors may take advantage of it (e.g. Netscape and Internet Explorer [case](http://coliveira.net/software/what-is-second-system-syndrome/))

##### Possible solutions within a Second System Syndrome stage

*   Implement firstly the [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product)
*   Create alpha and beta releases continuously

### Outside the Second System Syndrome {#outside}

As said previously, the team members have good reasons to improve the product they are working on: Better architecture, better design, less code, new frameworks, faster delivery.

During this post, I tried to explain the consequences of a Second System Syndrome and explain some of the solutions if we are inside this stage. But before end up this post, we should consider the following approach:

> Refactoring is the process of changing a software system in such a way that it does not alter the external behavior of the code yet improves its interanl structure [...] In essence when you refactor you are improving the design of the code after it has been written - Martin Fowler in "[Refactoring, Improving the design of existing code](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672)".

Refactoring gives us the possibility to modify an existing system and improve in such a way the system has the same features than before. Refactoring could cover from UX, Design, Architecture, APIs, Code, etc. For every of those areas, we may need to find an approach. The most common way is:

*   Start dividing the system in modules, or pieces, like a cake
*   Pick up one of those pieces and improve it slowly without affecting the whole system
*   Release it quickly. The reason to include “release” in the improvement process is related to avoid big complicate refactors that stops the common release flow of the product. Note that one of the big problems of the Second System Syndrome is the impossibility to finish it. Releasing quick “push” the team to improve the system and at the same time keep it stable

Some books about refactoring (in the code point of view):

| ![Clean Code](/img/posts/2015-07-21-second-system-syndrome/CleanCodeBook.jpg) | ![Refactoring, improving the design of existing code](/img/posts/2015-07-21-second-system-syndrome/RefactoringBook.jpg) |
| [Clean Code: A Handbook of Agile Software Craftsmanship](http://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882), by Robert C. Martin. | [Refactoring: Improving the Design of Existing Code](http://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672), by Martin Fowler. |

#### Extras

As an extra, we can apply some of the following suggestions to the current system:

*   Refactor code into behaviors, for example, using [Strategy Patterns](https://en.wikipedia.org/wiki/Strategy_pattern)so the knowledge is documented into the algorithms. Do not make at this point complicated refactoring, trying to reuse as much code as possible, only try to split it
*   Start applying [Behavior-driven development](https://en.wikipedia.org/wiki/Behavior-driven_development) to your current project to cover your functional requirements
*   Use about twice of your time learning and you will be able to multiple xN your speed implementing features
*   Spend time learning about existing code that makes a team member better developer and understand the context of the product
*   You can use the same tips than within the Second System Syndrome with the advantage that you improve what it is done already

### Presentation {#presentation}

Use the arrows on the left and right of the presentation in order to move between slides.

<iframe src="//cdn.knightlab.com/libs/timeline/latest/embed/index.html?source=1IS-nv6oTOIGybvZNVIJQGxfy85Y12mNG6eaiEQW19TI&amp;font=SansitaOne-Kameron&amp;maptype=toner&amp;lang=en&amp;height=650" width="100%" height="650" frameborder="0"></iframe>

Click [here](//cdn.knightlab.com/libs/timeline/latest/embed/index.html?source=1IS-nv6oTOIGybvZNVIJQGxfy85Y12mNG6eaiEQW19TI&font=SansitaOne-Kameron&maptype=toner&lang=en) to watch it on full size.