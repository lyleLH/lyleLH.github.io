---
title: ObjC runtime tips 01
date: 2023-02-16 13:53 +0800

layout: post
author: Tom Liu

tag: ["Basic Concepts", "Language", "iOS"]
---

Some hidden details in Language.

<!--more-->

## Runtime , Self and Super with Init

```objc
   @implementation Son : Father
   - (id)init
   {
       self = [super init];
       if (self) {
           NSLog(@"%@", NSStringFromClass([self class]));
           NSLog(@"%@", NSStringFromClass([super class]));
       }
       return self;
   }
   @end
```

output:

```shell
NSStringFromClass([self class]) = Son
NSStringFromClass([super class]) = Son

```

## Memory Management

[What and where are the stack and heap?](https://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)

- What are the stack and heap?
- Where are they located physically in a computer's memory?
- To what extent are they controlled by the OS or language run-time?
- What is their scope?
- What determines their sizes?
- What makes one faster?
