---
title: "How To Understand ObjC Class ?"
layout: article
author: Tom Liu
date: 2017-02-28 14:07:19 +0800
tag: ["Basic Concepts"]
categories: ["ObjC"]
---


本系列文章介绍的并不是一些艰深的内容。重要的是找到一些以前学习过程中主动地、被动地错误吸收的知识将它从脑中剔除，并理清其所给人带来的矛盾。但是还是有一个主线的，那就是正确理解 `Objective-C` 中的对象含义。

<!--more-->

---


## 目的和基础

目的是看懂`Objective-C`对象和类的定义的数据结构表示


### 几点基础知识
- C 语言的结构体的表示，`typedef` 语义的作用，结构体指针
- 一个 Objective-C 类的表示，C 语言的结构体和 Object-C 类的表达差异
- C 和 OC 从语言类型上分类的一些差异主要来自runtime特性
      
****

## C 语言结构体

>在C语言中，结构体(struct)指的是一种数据结构，是C语言中聚合数据类型(aggregate data type)的一类。
>
>结构体可以被声明为变量、指针或数组等，用以实现较复杂的数据结构。
>
>结构体同时也是一些元素的集合，这些元素称为结构体的成员(member)，且这些成员可以为不同的类型，成员一般用名字访问。
>
>简单的说：结构体是聚合了一系列数据的数据结构


结构体的定义如下:

```
 struct tag { member-list } variable-list ; 
```

- `struct` 为结构体关键字 

- `tag` 为结构体的标识,也叫**结构名**

- `member-list`为结构体成员列表

- `variable-list`为结构体声明的变量（此处的“声明”是一个动词）
- 结构体声明的末尾要加上分号




在一般情况下，`tag`、`member-list`、`variable-list`这3部分至少要出现2个


结构体作为 C 语言的一种**聚合数据类型**(`aggregate data type`)，一般都会拥有成员变量(`member-lis`)，所以下面只举出两例如下：


### 例子1

这个结构体并没有标明其标签（缺少`tag`）

```
struct 
{
    int a;
    char b;
    double c;
} s1;
```

### 例子2

结构体的`tag`被命名为`SIMPLE`,没有接着用来**声明变量**（`variable-list`）

```
struct SIMPLE
{
    int a;
    char b;
    double c;
};

```
使用这种结构体用来声明变量的方式如下：

```
struct SIMPLE simple1;
struct SIMPLE simple2;

```

### 结构体变量的成员变量的访问一（点运算符）

对结构体变量的成员变量的方位使用`.运算符`以上面定义的 `struct SIMPLE`类型的对象为例子：

```
struct SIMPLE simple1;
simple1.a = 100;
simple1.b = 100;
simple1.c = 0.5;

```

### 结构体变量的成员变量的访问二（箭头运算符）

```
//定义一个结构体
struct gstudent {
    char name[20];
    int age;
    float height;
    
};

//编写一个函数，用来修改某一个学生的身高
/*接受的参数为:
    struct gstudent *   类型（一个结构体指针）
    int                 类型
 */
void changeStudentHeight (struct gstudent * student,int height) {
    student->height = height;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //结构体的初始化
        struct gstudent tom = {"tom liu",25,170};
    
        changeStudentHeight(&tom,180);//tom两个月后长到了180公分
        
        printf("tom现在的身高是%f\n",tom.height);
        
    }
    return 0;
}

```
例子中

```
student->height = height;
```
这一句是一种简写，因为涉及到对对象存储的值的修改所以要用到指针

所以函数:
```
void changeStudentHeight (struct gstudent * student,int height)
```
接受的参数有一个结构体指针

因而在函数内访问结构体对象的成员的值的时候需要这么做：

```
(* student).height = height;
```
简写为:
```
student->height = height;
```


**相信以上用`->` 访问结构体成员的方式各位iOS开发人员会有印象，后面会讲到**


## 结合typedef

>在 C 和 C++ 中 `typedef`关键字用来对一个资料类型取一个新名字，目的是为了使源代码更易于阅读和理解。
>
>简单的解释就是`typedef`声明可以给原有的数据类型定义“同义词”，他的作用等同于数据类型名称
>

### 有效利用`typedef`声明简化冗长的写法:

```
struct gstudent {
    char name[20];
    int age;
    float height;
    
};

//改写后形式
//注意此处省掉了原来结构体的tag(gstudent)
typedef struct {
    char name[20];
    int age;
    float height;
    
}Student;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
     //struct gstudent tom = {"tom liu",25,170};
     //使用typedef后用新的别名来声明一个变量tom2
      Student tom2 ={"tom liu",25,170};
    }
    return 0;
}



```

***
参考：维基百科、《明解C语言》

