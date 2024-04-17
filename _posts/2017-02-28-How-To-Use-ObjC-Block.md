---
title: "How To Use Objective-C Block?"
layout: post
author: Tom Liu
date: 2017-02-28 14:07:19 +0800
tag: ["Basic Concepts"]
categories: ["ObjC"]
---

Block 作为语言特性 在 Mac OS X 10.4 和 iOS4.0 之后被加入到 GCC 编译器中,此特性的支持需要 GCC 编译器和相关运行期组建,可以在 C、C++、Objective-C、和 Objective-C++代码中使用

<!--more-->

---

## 基础概念

### 结构组成

`return_type (^block_name)(parameters)`

返回类型+`^`+ `(`Block 名称`)`+`(`参数列表`)`

### 声明和定义（实现）

声明一个 Block

```c
int (^addOperationBlock)(int a, int b)
```

定义（实现）刚才声明的 Block

```c
^(int a ,int b){
  return a + b;
}
```

### 结构解释

- Block 定义好了之后，可以像函数那样使用它

  ```
  //Block的定义
  int (^addBlcok)(int a,int b) = ^(int a,int b){
    return a + b ;
  }
  //Block的使用
  int add = addBlcok(2,5);//add = 7，和调用函数基本一样

  ```

  如 C 函数的定义和使用

  ```c
  //返回一个整数的平方
  int sqr_int(int x){
    return (x* x)
  }
  //使用
  int num = sqr_int(5) //num =25

  ```

### 特别说明：与函数的表示的差异

> **Block 与函数类似，只不过是直接定义在另一个函数里的，和定义它的那个函数共享同一个范围内的东西**

- Block 的定义是在某一个函数内的(回想一下以前使用 Block 的场景先)

- 函数的定义是独立在其他函数外部的

- Block 的特性，能够捕获它声明的范围内的所有变量（后面会再讲讲这一点）

- 这里是两个 C 语言中函数和 Block 的应用例子

  - [函数与 Block 的表达差异一](https://github.com/lyleLH/BlockIntro/blob/master/main_v1)
  - [函数与 Block 的表达差异二](https://github.com/lyleLH/BlockIntro/blob/master/main_v2)

## Block 的使用说明

### 为 Block 创建 typedef

> Block 直接使用并不是很强大，而 Block 的语法与其他类型的变量比较起来稍显怪异，非常难记也很难读（Block 的类型（inherent type）是由参数列表和返回值组成并决定的，Block 的名字反而写在类型中间）
> 鉴于此，我们应该为常用的 Block 取一个别名，这样有利于组织 API

利用 C 语言的类型定义给 Block 起一个易读的别名
比如：

```c
typedef int(^LHSomeBlock)(BOOL flag ,int value);

```

这条语句就是向系统中添加了一个名为 LHSomeBlock 的新类型，此后就不需要用复杂的 Block 类型来创建变量了，可以直接使用这个新的类型：

```c
LHSomeBlock blcok = ^(BOOL flag, int value) {

}
```

这样对于 API 可以大大简化，增强易读性

例子：

```c
//简化前
- (void)startWithCompletionHandler:(void(^)(BOOL flag,int value))completion

//简化后
- (void)startWithCompletionHandler:(LHSomeBlock)completion

```

## 用法实例及其理解

### 直接在定义的地方使用（直接用）

这一点其实很没有必要

例如，我要在**某处**得到两个整数的和的平方
假设这个某处是在任何当前编码的函数如 `someFunction()` 中

(你也可以认为是在 `viewDidLoad` 函数中)

```objc
#import <Foundation/Foundation.h>

//第二种方法所定义的函数
int sqrOfadd(int a,int b){
    return (a + b)* (a + b);
}

void someFunction(){
    int a = 10;
    int b = 20;
    int result = 0;
    //接下来我想知道 a 与 b 的和的平方
    //1.a b 都在函数范围内，直接算
  // result = (a + b)*(a + b); 搞定
    //2.这个计算步骤可能会很常用于是我定义一个函数封装一下这个过程
  // result =  sqrOfadd(a, b);
    //3.直接使用Block。这种方式显得很没有必要
    int (^sqrOfaddBlock)(int a,int b)=  ^(int a,int b){
        return (a+b)*(a+b);
    };
    result = sqrOfaddBlock(a,b);
    NSLog(@"sqrOfaddOpeeration result : %d",result);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        someFunction();
    }
    return 0;
}
```

对比代码中列出的 1、2、3 三种方法，Block 直接使用的方式显得很弱智 :(

### 结合 typedef 使用

> 作为一个新的类型：
>
> a.可以直接声明该类型的变量并使用（第一种用法）
> b.作为某些类的属性
> c.作为参数出现在某些函数的参数中被调用
> 这里继续介绍 b 和 c 类用法

### 作为属性的用法

可以被当成一般的 OC 对象的属性,有差异的是：

- setter 方法（或者对实例变量的赋值操作）就是用一个同**类型**(Block 的类型（inherent type）是由参数列表和返回值组成并决定的)的 Block 赋值给这个属性（实例变量），并且可以发挥 Block 的特性--顺带利用在赋值时的函数内所捕获的值实现了 Block
- getter 方法就是调用 Block 了，就和调用一般的函数一样，需要带上参数

以实现一次登陆的网络请求为例子：

`LHLoginModel.h`

```objc

#import <Foundation/Foundation.h>

typedef void(^LHNetResponseBlock)(NSDictionary *response) ;

@interface LHLoginModel : NSObject

@property (nonatomic,copy)LHNetResponseBlock loginResponse;


- (void)loginAPIServerWithUsername:(NSString*)usernane andPassword:(NSString*)password;

@end

```

`LHLoginModel.m`

```
#import "LHLoginModel.h"

@implementation LHLoginModel

- (void)loginAPIServerWithUsername:(NSString*)usernane andPassword:(NSString*)password {

    //请求服务器的登陆借口，获得相应
    //......调用Block，但是Block的实现在别处（控制器中）
    //...传递响应
    NSDictionary * response = @{@"code":@"1"};
    if(_loginResponse){
        _loginResponse(response);
    }
}

@end

```

`ViewController.m`

```
#import "ViewController.h"
#import "LHLoginModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LHLoginModel * loginModel = [[LHLoginModel alloc]init];
    //先进行赋值，保证Block的实现代码不为空
    loginModel.loginResponse = ^(NSDictionary*response){
        //此处在控制器中来处理响应和完善业务逻辑
        NSLog(@"%@",response);
    };
    //loginAPIServerWithUsername方法中调用_loginResponse的时候有内省一次，所以Block调用的时候不能为空
    [loginModel loginAPIServerWithUsername:@"liuhao" andPassword:@"123456"];


}

```

从代码中可以看出这么做，代码显得冗余（后面有更简洁的方法），而且逻辑并不清晰，因为例子中正常思维应该是先调用

```objc
[loginModel loginAPIServerWithUsername:@"liuhao" andPassword:@"123456"];
```

再去处理`response`

```objc
loginModel.loginResponse = ^(NSDictionary*response){
        //此处在控制器中来处理响应和完善业务逻辑
        NSLog(@"%@",response);
    };

```

但是这个例子中并不能这样做，因为我的请求方法是模拟的并不是异步的，`viewDidLoad`中执行`loginAPIServerWithUsername`中马上就去调用 Block 了，但是`viewDidLoad`中的下一句给 Block 赋值的操作（block 的实现）却还没有执行，导致 Block 为空

### Block 作为参数的用法

作为参数的用法就比较简单了，函数在被调用的时候，block 的调用其实是在当前 API 函数的内部的，作为参数的 block 需要在 API 被调用的时候被实现

`LHLoginModel.h`

```objc
#import <Foundation/Foundation.h>

typedef void(^LHNetResponseBlock)(NSDictionary *response) ;

@interface LHLoginModel : NSObject

+ (void)logOutServerWithUsername:(NSString*)usernane andPassword:(NSString*)password response:(LHNetResponseBlock)response;

@end


```

`LHLoginModel.m`

```objc
#import "LHLoginModel.h"

@implementation LHLoginModel

+ (void)logOutServerWithUsername:(NSString*)usernane andPassword:(NSString*)password response:(LHNetResponseBlock)response {
    //请求服务器的登出接口，获得相应
    //......调用Block，但是Block的实现在别处（控制器中）
    //...传递响应
    NSDictionary * result = @{@"code":@"1",@"msg":@"logout success!"};
    response(result);
}

@end


```

`ViewController.m`

```objc
#import "ViewController.h"
#import "LHLoginModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LHLoginModel logOutServerWithUsername:@"liuhao" andPassword:@"123456" response:^(NSDictionary *response) {
        NSLog(@"%@",response);
    }];


}


@end

```

### 用法的额外补充

- 注意循环引用
- 注意 block 作为属性的内存管理语义
- block 调用前注意检查是否为空
- block 捕获的变量不能再其内部修改，除非加上一些修饰符

---

[原文链接](https://github.com/lyleLH/BlockIntro)
