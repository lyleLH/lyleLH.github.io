---
layout: post
title: Constructor Injection First | SE Princple
date: 2024-09-23 11:23 +0800
categories: ["SE Princple"]
tag: ["Coding Method"]
---
[Explain why constructor inject is better than other options [duplicate]](https://stackoverflow.com/questions/21218868/explain-why-constructor-inject-is-better-than-other-options)

[A Comprehensive Guide to Best Practices and Common Scenarios Using Dependency Injection in .NET 8 with C#10](https://dev.to/homolibere/a-comprehensive-guide-to-best-practices-and-common-scenarios-using-dependency-injection-in-net-8-with-c10-c3m)

[Dependency Injection: Everything You Need to Know](https://builtin.com/articles/dependency-injection)

[Microsoft - Dependency Injection - Overview](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection)

**Do not hard-coded dependencies for the following reasons:**

- To replace MessageWriter with a different implementation, the Worker class must be modified.
- If MessageWriter has dependencies, they must also be configured by the Worker class. In a large project with multiple classes depending on MessageWriter, the configuration code becomes scattered across the app.
- This implementation is difficult to unit test. The app should use a mock or stub MessageWriter class, which isn't possible with this approach.

## My Issue

perplexity -- [What is dependency injection, how does this idea coming, what is the background and scenerio](https://www.perplexity.ai/search/what-is-dependency-injection-h-KBVWLuGfSJeJT1NCgCzHgQ#0)

