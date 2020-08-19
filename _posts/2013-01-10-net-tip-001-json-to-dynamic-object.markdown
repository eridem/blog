---
layout:     post
title:      "Json to dynamic object"
description: ".NET Tip #001"
author:     "eridem"
main-img: "img/featured/2013-01-10-net-tip-001-json-to-dynamic-object.jpg"
permalink:  net-tip-001-json-to-dynamic-object
---

We can convert a JSON string to a dynamic object. This could be convenient if we can not define a hard-type model and still accessing to the object in code using properties (probably you could create a plugin system where every plugin “knows” how to access to those properties; as well you could use Razor engine for templates).

```csharp
public static dynamic JsonToDynamic(string json)
{
  dynamic result = JObject.Parse(json);
  return result;
}

public static void Test()
{
  var json = "{ "Name" : "ERiDeM", "Website" : "eridem.net" }";
  dynamic obj = JsonToDynamic(json);

  Console.WriteLine("Name: " + obj.Name);
  Console.WriteLine("Website: " + obj.Website);
}
```
