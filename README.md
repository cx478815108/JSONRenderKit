# JSONRenderKit

![](http://ou3yprhbt.bkt.clouddn.com/JSONRenderKitBanner.png)

------------------------

## 更简单，更方便地生成iOS 新界面 🚗 🚗 🚗 

**可以说是十分有趣的一个库了，下面简要说明**

&nbsp;&nbsp;&nbsp;&nbsp;有时候想要给app增加新功能，我都要大致经历这样几个步骤，编码->测试->打包->提交app store 审核，花费的时间很长，尤其是审核。你可能会说到这已经有现成的解决方案了，ReactNative 就是，并且可以热更新。是的，但是我不想因为简单的需求就引入整个React，增加了app 体积不说，门槛也相应提高了。
&nbsp;&nbsp;JSONRenderKit 核心就只几个.h.m 文件，团队其他人只要按照文档写出JSON 就可以为app 输出，战斗力一下子就上来啦😁。重要的是我可以用它给用户很多意想不到的彩蛋，算是能让人兴奋的了！
&nbsp;&nbsp;目前我已放进app -[掌上理工大](http://app.wutnews.net/#/) （app store 可以搜索）里面使用啦。代码有详细注释你也可以修改源代码并扩展新组件后放进的你自己的项目，重要的是你也可以参考JavaScript 是怎样和OC 进行交互的。要是有兴趣，你也可以自己将他打造成为一个有用的工具。

## 快速开始
开始写一个JSON尝试一下吧！[JSON文档](https://github.com/cx478815108/JSONRenderKit/blob/master/Document.md)在这里。

![](http://ou3yprhbt.bkt.clouddn.com/all.png)

------------------------


**Objective-C**

```
#import "SSBaseRenderController.h"
.
{
        ...
        SSBaseRenderController *obj = [[SSBaseRenderController alloc] init];
        obj.url = @"http://xxxxxxxxxx";
        [self.navigationController pushViewController:obj animated:YES];
}
```

## Run

1. 运行`Core/JavaScript/Service.py` 脚本
2. 用Xcode打开这个project，并运行即可

py脚本推荐使用`sublime`打开，搜索`sublime` 的Python build，并配置好后 按下`command + B` 出现以下截图即正常！当然你用其他方法启动py脚本也可以。
启动的`Python`进程可以用活动监视器查找`Python`关闭。

![](http://ou3yprhbt.bkt.clouddn.com/sublime.png)

## 安装

### 手动安装

[下载这个Demo](https://github.com/cx478815108/JSONRenderKit/archive/master.zip) 将 `JSONRenderKit` 里面的 `Core` 文件夹拖入Xcode.
暂时不支持CocoaPods安装


## 联系我

[XiongChen](mailto:feelings0811@wutnews.net) -> feelings0811@wutnews.net

