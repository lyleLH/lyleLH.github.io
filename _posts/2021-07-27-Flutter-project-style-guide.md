---
title: "Flutter project style guide"
layout: post
author: Tom Liu
date: 2021-07-27 14:07:19 +0800
tag: ["flutter", "best practice"]
categories: ["Flutter Application"]
---


在追求持续迭代的过程中，延长交付周期的因素有很多。代码质量和基础设施上的投资往往稀缺而昂贵。

两者比较之下，显然作为业务开发人员，我们在紧张的业务迭代中，应该可以做一点点微小的努力来提升代码质量。


<!--more-->

---


### 目录结构

这里处理的对象是工程的代码和资源文件


```
.
├── events              // 事件
├── models              // 模型
├── navigators          // 导航
├── networking          // 网络（含 http、socket 等）
├── pages               // 页面
├── redux               // 全局状态管理
├── themes              // 主题
├── utilities           // 工具
├── views               // 业务小部件
├── widgets             // 公共小部件
├── includes.dart       //
├── main.dart           // 入口文件
├── main_beta.dart      // 入口文件（beta 环境）
├── main_dev.dart       // 入口文件（dev 环境）
└── main_stable.dart    // 入口文件（stable 环境）
```

### 命名规范

#### 文件

请严格按照以下的命名规范来对文件进行命名。

- 目录名使用**下划线命名法**
  示例：`login`、`list_item`
- 文件名使用**下划线命名法**
  示例：`login`、`list_item`
- 类名**驼峰命名法（首字母大写）**
  示例：`LoginPage`、`ListItem`
- 匿名类名**驼峰命名法（以 `_` 开头）**
  示例：`_Login`、`_ListItem`
- 匿名方法名**驼峰命名法（以 `_` 开头）**
  示例：`_handleClickSubmit`、`_buildBody`

#### 图片资源

- 全部小写字母
- 单词之间使用下划线（`_`）连接
- 尽量不使用缩写作为名称

##### 前缀

| 名称        | 前缀               | 描述          |
| :---------- | :----------------- | :------------ |
| Icon        | `ic_`              | -             |
| Menu Icon   | `ic_menu_`         | AppBar 的图标 |
| TabBar Icon | `ic_tab_`          | TabBar 的图标 |
| Button      | `btn_`             | -             |
| RadioButton | `btn_radio_`       | -             |
| CheckBox    | `btn_check_`       | -             |
| Switch      | `btn_switch_`      | -             |
| Toggle      | `btn_toggle_`      | -             |
| RatingBar   | `btn_rating_star_` | -             |

e.g.

```
ic_launcher.png
ic_menu_share.png
ic_menu_back.png
ic_menu_settings.png
ic_tab_home.png
ic_tab_mine.png
```

##### 尺寸

| 名称   | 后缀      | 描述 |
| :----- | :-------- | :--- |
| Mini   | `_mini`   | -    |
| Small  | `_small`  | -    |
| Medium | `_medium` | -    |
| Large  | `_large`  | -    |
| Big    | `_big`    | -    |

##### 开关

| 名称 | 后缀   | 描述 |
| :--- | :----- | :--- |
| On   | `_on`  | -    |
| Off  | `_off` | -    |

##### 状态

| 名称     | 后缀        | 描述                                                   |
| :------- | :---------- | :----------------------------------------------------- |
| Normal   | `_normal`   | -                                                      |
| Pressed  | `_pressed`  | -                                                      |
| Selected | `_selected` | -                                                      |
| Checked  | `_checked`  | 常用于表单类的控件如 `CheckBox`、`Switch`、`Toggle` 等 |
| Disabled | `_disabled` | -                                                      |

##### 对齐

| 名称   | 后缀      | 描述 |
| :----- | :-------- | :--- |
| Top    | `_top`    | -    |
| Right  | `_right`  | -    |
| Bottom | `_bottom` | -    |
| Left   | `_left`   | -    |

##### 颜色

| 名称  | 后缀     | 描述 |
| :---- | :------- | :--- |
| White | `_white` | -    |
| Black | `_black` | -    |
| Red   | `_red`   | -    |
| Green | `_green` | -    |
| Blue  | `_blue`  | -    |

#### 页面

项目所有页面均需要添加到 `lib/pages/` 目录下，并遵循以下规范：

- 所有新增页面都需添加到 `pages` 目录下并包裹在一个同名的文件夹下
  例如：`pages/login/login.dart`，创建一个登录页面
- 页面的类名均与 `Page` 结尾
  例如：`LoginPage`

### 自定义小部件

为了统一风格等需求，项目中对一些常用的小部件进行了自定义，除非特殊情况，均应优先使用这些自定义小部件。

### 其他

- 避免引入非本项目一些链接及提交临时代码。

#### 相关链接

- https://flutter.dev/docs/development/tools/formatting
- https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo
- https://dart.dev/guides/language/effective-dart/style