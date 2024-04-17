---
title: "Cocoapods管理组件实际操作演示"
layout: post
author: Tom Liu
date: 2020-11-10 14:07:19 +0800
tag: ["cocoapods", "best practice"]
categories: ["Develop Tools"]
---



目前我们的项目工程使用`cocoapods` 来管理依赖，同时我们对项目进行组件化的时候，`cocoapods`也是必要的组件生命周期管理工具。

<!--more-->

---

## 名词解释

- 公共索引库 / 远程索引库

- 组件工程库 / 组件库

  - Readme文档
  - Example工程，内含外部需要用到的接口的使用例子（或者注释足够清晰）的
  - 组件代码

- 本地索引库

  - 截图

- 组件工程
  - `Example 目录`
  - 组件代码
  - 组件的`xxx.podspec`文件

- `spec`文件/`podspec`文件

- 壳工程

## 步骤归纳

### 创建和编写

1. 创建 `远程索引库` 和 `远程私有库`

    - 一般来说，你开发的组件不会涉及到初创索引库，也就是你们的`公共索引库`是已经存在的，目前我们的组件索引库名字是`example-app-ios-modules-ykspecs`，对应的`repo`地址是`http://gitlab.example.com/App/iOS/Modules/YKSpecs.git`

2. 将 `远程索引库` 添加到本地  `pod repo add [索引库名称] [索引库地址]`
    1. 这一步骤会在 `/Users/[username]/.cocoapods/repos`下拉取`远程索引库`到本地

    2. 这个目录以下称之为 `本地索引库`
    3. 你这是`索引库名称`单独为本地索引库命名了

3. 为在本地（任意目录）创建一个 `pod模板库`  ，`pod lib create [组件名]`，用此工程来为组件添加代码，并且利用`Example`工程进行测试

    - 组件名一般`YKXxxxxModule`或者`YKXxxxxComponent`

    - 主要关注 `Example` 和 `组件代码文件夹` 以及 `xxx.podspec`文件
    - 截图描述文件夹目录

4. 将需要组件化的代码添加到模板库的Classes目录下

    - 截图描述 新建文件并添加到组件文件目录

5. 修改`spec`描述文件
    1. `s.version`，这个是最常改动的字段，需要结合整个工程的`tag`
    2. `s.source`  组件工程的repo地址
    3. `s.source_files`  在组件工程中，组件代码的文件目录

6. 更新`Readme` 添加 `Change Log`

### 测试

1. 基于组件`Example`工程的测试
    - 你添加到`Classes`目录下的文件并不能在Example的类中以`<xxx/xx.h>`的形式引用，需要在`Example目录`先执行`pod install`

### 上传

#### 保存你的工程修改，并推送到`组件工程库`

```ruby
git add .
git commit -m "提交描述"
git remote add origin 远程私有库地址
git push origin master
git tag '0.1.0'
git push --tags
```

#### 提交`xxx.podspec`至私有`公共索引库`

- 验证`xxx.podspec`

```ruby
pod lib lint //本地lib验证，验证源代码的编译

pod spec lint //远程spec验证 ，验证spec文件中的各项内容、资源是否合规和可访问
```

> 具体操作：提交   `xxx.podspec`   到私有库

```shell
pod repo push [本地索引库名字]   [组件名].podspec
```

```shell
pod repo push example-app-ios-modules-ykspecs YKTomTestKit.podspec --allow-warnings
```

### 使用

```ruby
source 官方索引库url
source 私有索引库url
pod '[组件名称]'
pod install
```

## 具体流程演示

### 创建远程私有索引库和私有代码仓库

1. `spec repository`是索引仓库，所有的配置按照包名、版本号分门别类的存放在这个仓库。这个仓库只用来存放`spec`文件，用来`索引`，目前我们内部只有唯一的索引库，无须创建
2. `code repository`是代码仓库，我们把包代码上传到这个仓库。

**这里以 `gitlab`为例创建 `code repository`**

- 创建组件工程库的截图

### 将远程索引库添加到本地

将第一步中创建的`spec repository`添加到本地索引库

```ruby
// pod repo add 索引库名称 索引库地址
pod repo add YKSpecs http://gitlab.example.com/App/iOS/Modules/YKSpecs.git
```

查看本地所有的索引库

```shell
pod repo list
```

- pod repo list 截图

### 创建组件工程-- 使用`cocoapods`模板库

`cd`到你平时的工作目录 ，执行创建命令

```shell
// pod lib create 组件名
pod lib create YKTomTestKit
```

执行后会需要配置一些信息，直接按下图配置即可

- 创建过程的截图

这里会询问几个问题（答案根据实际情况设置），分别是：

```Y
1、语言选择 - ObjC
2、是不是需要一个demo项目工程  - Yes
3、测试框架使用哪一个  - None
4、是不是需要做基本的测试 - No
5、类前缀是什么 -  YK
```

### 添加组件代码

创建完成后会自动帮我们打开相应的`Example`项目，模板文件目录中会出现如图这些文件，我们把基础组件相关的东西丢到`Classes`文件夹中，并且把`ReplaceMe.m`文件删除

截图：

- 创建组件代码文件
- 选择目录
- 编写组件代码文件代码

默认`Classes`文件夹中存放的文件就是`pod install`时要下载下来的文件，当然可以通过修改`spec`文件的配置来更改位置

### 修改Spec描述文件

`spec`配置文件目录地址

配置说明如下，根据需要修改配置。

```ruby
Pod::Spec.new do |s|
  s.name             = '框架名字，pod search "框架名"就是搜的这个'
  s.version          = '框架版本号1.0.0, 这里跟下面s.source中的tag有关'
  s.summary          = '框架简介'

  s.description      = "这个是详细描述，这里需要注意的是，这里文字的长度需要比  
  s.suYKTomTestKitmmary的要长，不然会出现警告"
                       
  s.homepage         = '仓库首页地址（例:http://git.vanke.com）'
  s.license          = '框架遵守的开源协议'
  s.author           = '框架的作者'
  s.source           = '框架的资源路径'

  s.ios.deployment_target = '框架支持的最低平台版本'

  s.source_files = '框架被其他工程引入时，会导入所填文件目录下的.h和.m文件'
  
  # s.resource_bundles = {
  #   'YKTomTestKit' => ['YKTomTestKit/Assets/*.png']
  # }

  # s.public_header_files = '框架公开的头文件'
  # s.frameworks = '框架依赖的framework'
  s.dependency '框架依赖的其他第三方库
end

```

### 安装与测试本地库

在Example项目的Podfile文件中可以看到

```shell
pod 'YKTomTestKit', :path => '../'
```

模板库已经默认帮我们在Podfile中指定了YKTomTestKit.podspec的位置，使组件YKTomTestKit可以正常安装使用和方便测试,

```shell
pod install
```

执行之后组件代码会集成到项目中，如上图所示，测试一下确保组件可用。

### 上传代码

#### 将代码（含Example和组件代码）提交到组件仓库

```shell
git add .
git commit -m 'firstCommit'
git remote add origin http://XiaoBing@git.vanke.com/plugins/weexPlugins/iOS/YKTomTestKit.git
// 第一次push如果报错的话可以加上-f
// git push -f origin master
git push origin master
```

#### 打标签

`tag`的版本`0.1.0`与`spec`中的`s.version`保持一致

```shell
git tag '0.1.0'
git push --tags
```

`tag`的 删除

```shell
git tag -d 标签名  

例如：git tag -d 0.1.0

git push origin :refs/tags/标签名  

例如：git push origin :refs/tags/0.1.0

```

### 提交podspec到私有索引库

在上传`spec`文件前我们可以做一个验证来节省时间，防止配置文件错误导致 `push`失败。

#### 验证`spec`

本地验证

```shell
// 本地验证不会验证 s.source 中的tag
//验证结果显示 ++工程名 passed validation++说明验证成功。
pod lib lint
pod lib lint --allow-warnings
```

远程验证

```shell
// 远程验证会验证 s.source
//验证结果显示 ++工程名.podspec passed validation++说明验证成功。
中的tag，如果此时没有打上相应的标签则会报错

pod spec lint
pod spec lint --allow-warnings --use-libraries
```

验证可能失败的原因

```shell
1. 如果有警告，会导致无法通过，需要添加  --allow-warnings
2. 如果使用了c函数相关的，需要添加  --use-libraries
3. 如果依赖了私有库，需要添加库的源  --sources='https://xxxx'
根据出现的问题添加命令：
pod lib lint --sources='https://xxxx' --use-libraries --allow-warnings
pod spec lint --sources='https://xxxx' --use-libraries --allow-warnings

如果有推到多个索引库地址，逗号隔开，如下:
pod repo push vanke-liuh44-mccspecs --sources='https://github.com/CocoaPods/Specs.git','https://github.com/aliyun/aliyun-specs.git' --use-libraries --allow-warnings

4. 使用了不支持i386架构的库，验证不通过
    在podspec文件中添加只编译64位系统命令：
# 新版极光推送SDK不支持i386, 需加下面这条命令只编译编译64位的系统，否则本地验证不通过
  s.pod_target_xcconfig = {
      'ARCHS[sdk=iphonesimulator*]' => '$(ARCHS_STANDARD_64_BIT)'
  }

```

#### 提交 `podspec`

```shell
// pod repo push 私有索引库名称 spec名称.podspec 
pod repo push example-app-ios-modules-ykspecs YKTomTestKit.podspec 
```

提交失败可能的原因

```shell
1. 如果有警告，会导致无法通过，需要添加--allow-warnings
2. 如果使用了c函数相关的，需要添加--use-libraries

根据问题添加命令

pod repo push example-app-ios-modules-ykspecs YKTomTestKit.podspec --use-libraries --allow-warnings
```

这里的操作过程是：先将我们的`spec文件` `push`到`远程索引库`，随后会拉取`新的远程索引库`到`本地索引库`。

成功之后可以测试搜索上传的组件

```shell
pod search '组件名'
```

### 使用私有库

#### `podfile`文件设置

```shell
//添加远程私有索引库地址
source 'http://git.vanke.com/liuh44/MccSpecs.git'
//官方索引库地址
source 'https://github.com/CocoaPods/Specs.git'

...
//添加使用组件
pod 'YKTomTestKit'
```

会去远程组件工程库寻找组件代码进行集成

```shell
 s.source_files = 'YKTomTestKit/Classes/**/*'
```

以上描述的就是我们的组件工程中的组件代码目录

#### 执行 `pod install`

- `pod install` 只会更新 `podfile`中**新增**的库
- `pod repo update` 会更新本地索引库
- `pod update <组件名>` 更新`podfile`中依赖的组件
- `pod repo update example-app-ios-modules-ykspecs` 只更新我们的私有库的索引库
  - 然后再 `pod update YKTomTestKit` ,更新指定的组件

## 常见问题和解决方案

### 过程中要注意的Tips

### 关于发布

- 你可以随意的 `commit & push`整个工程，但是只能在发布的时候打Tag
- `cocoapods 1.8` 之后使用cdn版本的源
