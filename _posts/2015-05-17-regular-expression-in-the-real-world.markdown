---
layout:     post
title:      "Regular Expression in the Real World"
author:     "eridem"
#header-img: "img/featured/2015-05-17-regular-expression-in-the-real-world.jpg"
#featured-author: Build Azure
#featured-link: https://buildazure.com
permalink:  regular-expression-in-the-real-world
external: http://blog.loadimpact.com/blog/regular-expression-in-the-real-world/
---

Regular expressions are patterns used to search or search and replace in a text.

The purpose of this post is to motivate the use of RegExp in our real life, showing examples of common uses.

Jump to the [Cheap Sheet section](#cheatsheet) before continuing if you are not familiarized with the RegExp syntax.

## Contents

- [Search: Searching for a class in C# with prefix and suffix](#searchingclass)
- [Replace: Refactoring some HTML code](#refactorhtml)
- [Validation: Web Api validation in .NET using models](#validatingapi)
- [Web scraping](#scraping)

## Searching for a class in C# with prefix and suffix {#searchingclass}

##### Problem

In this example, we can consider that we have several classes that contains a prefix and suffix in the name of the class. For example, it’s very common that developers write sometimes the name of the project as the prefix and the base class as suffix:

```charp
public class MyProjectCardAdapter

public class MyProjectWorkshopAdapter

public class MyProjectWheelsAdapter
```

##### Solution

```
(class\s+MyProject)([\d\w]+)(Adapter)
```

##### Tips

*   Use `\s+` in order to skip as many spaces between `class` and the name of the class in case we have more than one space.
*   `[\d\w]+` means that we can have a sequence (1..infinity) marked by + which contains digits or words used for the name of the adapter.
*   Use parentheses to organize our search and be more readable. But they are optional.

## Refactoring some HTML code {#refactorhtml}

##### Problem

We would like to refactor some HTML code. For this example, we have some old code that uses paragraphs and classes to define titles and subtitles in certain text.

```html
<p class="title title-section">Title here</p>
<p>blah blah blah</p>
<p class="bold-text">blah blah blah</p>
<p>blah blah blah</p>
<p class="title title-subsection">Subtitle here</p>
<p class="bold-text">blah blah blah</p>
<p>blah blah blah</p>
```

##### Solution

```
Search: <p(.*?)class="(.*?)title-section(.*?)"[^>]*>(.*?)</p>
Replace: <h1>$3</h1>
```

```
Search: <p(.*?)class="(.*?)title-subsection(.*?)"[^>]*>(.*?)</p>
Replace: <h2>$3</h2>
```

##### Result

```html
<h1>Title here</h1>
<p>blah blah blah</p>
<p class="bold-text">blah blah blah</p>
<p>blah blah blah</p>
<h2>Subtitle here</h2>
<p class="bold-text">blah blah blah</p>
<p>blah blah blah</p>
```

##### Tips

*   Use `(.*?)` if you don't know there is something before the class you are looking for — same rule for after. Doing `(.*?)WHATEVER(.*?)`, looks, in normal search, like `*WHATEVER*`.
*   Instead, use `(._?)` at the close of the HTML tag, use `[^>]` to define that until you get to the next `>`.
*   Group what you want to reuse in the replacement. In our case, we group the content between the paragraphs in the third group `($3)`.

## Web Api validation in .NET using models {#validatingapi}

##### Problem

We would like to include validation in the attributes of our models when the client makes a call to our API. Adding validation on the individual attributes of our models, we skip adding more logic inside our controllers and make them focus on the business logic.

```csharp
public class RegisterBindingModel
{
    [Required]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; }
}
```

##### Solution

We would like to have at least one digit, one uppercase letter and one lowercase letters. The minimal amount of digits is 6, but this can be validated with another attribute on .NET.

RegExp: `^(?=._[a-z])(?=._[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$`

```csharp
public class RegisterBindingModel
{
    [Required]
    [StringLength(100, ErrorMessage = "The {0} must be at least {2} characters long.", MinimumLength = 6)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]*$", 
     ErrorMessage = "The password should have upercase letter, lowercase letters and digits.")]
    [DataType(DataType.Password)]
    [Display(Name = "Password")]
    public string Password { get; set; }
}
```

##### Tips

*   Using Lookahead we can verify some conditions before match the text
*   With `(?=.*[a-z])` we will look ahead that the text contains at least one lowercase character
*   With `(?=.*[A-Z])` we will look ahead that the text contains at least one lowercase character
*   With `(?=.*\d)` we will look ahead that the text contains at least one lowercase character
*   `[a-zA-Z\d]*` is the "real" match, but it does not contains the logic to understand if there is at least one minimal appearance of a lowercase letter, uppercase letter and a digit

In this example, we would like to parse information from a website (HTML) and recollect it inside some objects in our C# application.

Without focusing on the example to scrap, let's say we created a regular expression that recognizes items in a list, where:

*   the first group correspond to the name of a product;
*   the second one correspond to its composition;
*   and the third one to its price.

```html
<li>(.+?)\s*?\((.*?)\)\s*?(\d+|\d+.\d+)</li>
```

## Web scraping {#scraping}

##### Problem

Using .NET C#, we created a class to recreate the information that we want to obtain:

```csharp
internal class Dish
{
    public string Name { get; set; }
    public string Composition { get; set; }
    public float Price { get; set; }
}
```

Using the RegExp class and iterating over the Match class, we can obtain the information of the search for each found on the input text (HTML):

```csharp
private static ICollection<Dish> ParseHtmlInput(string htmlInputText)
{
    List<Dish> result = new List<Dish>();
    RegExp RegExp = new RegExp(@"<li>(.+?)\s*?\((.*?)\)\s*?(\d+|\d+.\d+)</li<");
    Match match = RegExp.Match(htmlInputText);

    while (match.Success)
    {
        var name = match.Groups[1].Value;
        var composition = match.Groups[2].Value;
        var price = match.Groups[3].Value;

        var priceAsFloat = 0f;
        float.TryParse(price, out priceAsFloat);

        result.Add(new Dish { Name = name, Composition = composition, Price = priceAsFloat });

        match = match.NextMatch();
    }

    return result;
}
```

## Common Search RegExp cheat sheet {#cheatsheet}

| RegExp | Description | Example |
| :-- | :-- | :-- |
| `\d` | Match a number from `0` to `9` (`\D` match the opposite) | `\d\d\d` |
| `\w` | Match a word character from `A-Z` and `a-z` (`\W` match the opposite) | `\w\w\w` |
| `\s` | Match any space character but next line | `\s\s\s` |
| `\n` | Match next line | `\n\n\n` |
| `.` | Match any character but next line | `...` |
| `*` | Repetition of character (or group) from `0` to infinity | `\d*` |
| `+` | Repetition of character (or group) from `1` to infinity | `\d+` |
| `?` | Repetition of character (or group) from `0` to `1` | `\d?` |
| `{N1}, {N1,N2}` | Repetition from `N1` to `N2` | `\d{1,5}` |
| `[...]` | Explicit set of characters that can match | `[abc]` means `(a | b | c)` |
| `[^...]` | Explicit set of characters that cannot match | `[^abc]` means `!(a | b | c)` |

## Common Replace RegExp cheat sheet

| RegExp | Description | Example |
| :-- | :-- | :-- |
| `(...)` | Grouping sequence |
| `$N` | Used on replace section means replace for the group number `N` | Search: `hello (\w+)` Replace: `goodbye $1` |
| `\N` | Used on search means to match the same RegExp than group number `N` | Search: `<(\w+)>.*</\1>` |

## Lookahead and Lookbehind cheat sheet

| RegExp | Description | Example |
| :-- | :-- | :-- |
| `(?=X)` | Lookahead: Asserts that what immediately follows the current position in the string is `X` | `(?=foo)` |
| `(?<=X)` | Lookbehind: Asserts that what immediately precedes the current position in the string is `X` | `(?<=foo)` |
| `(?!X)` | Negative Lookahead: Asserts that what immediately follows the current position in the string is not `X` | `(?!foo)` |
| `(?<!X)` | Negative Lookbehind: Asserts that what immediately precedes the current position in the string is not `X` | `(?<!foo)` |

## References:

*   [http://www.rexegg.com/](http://www.rexegg.com/): These cheat sheets and more information can be found here.