## 说明
这是一个好玩的库，目前我已经放进正式项目里面啦，你可以在app store搜索“掌上理工大”。
你也可以修改源代码并扩展新组件后放进的你自己的项目，这样就可以用JSON来布局一些简单的页面。
重要的是你也可以参考JavaScript是怎样和OC进行交互的,代码里面有详细的注释。要是有兴趣，你可以自己将他打造成为一个有用的工具。
JSON示例：JSONRenderKit/render.json
截图如下

This is a funny library and I have use it in my app you can search “掌上理工大” on app store! With this library ,you can generate simple native UI,if you are interested on it you can make it a powerful library!
What important is that you can learn how to use JavaScript to communicate with Objective-C!I have added the code annotations to it!
JSON demo：JSONRenderKit/render.json

### Screenshots
![-w240](https://github.com/cx478815108/JSONRenderKit/blob/master/screenshots/demo.png?raw=true)

![-w440](https://github.com/cx478815108/JSONRenderKit/blob/master/screenshots/service.png?raw=true)

-------

### Run the Demo
1. clone or download this project.
2. run the JSONRenderKit/Core/JavaScript/Service.py before to run the demo in Xcode.

    **I recommand you to run the Python script on Sublime Text 3.
    if you have no idea about how to run just Google it!**
    
-------
## Document

#### JSON中可以调用的全局对象,函数,属性

1.可调用的对象只有`UI`,`$props`,`$actions`

| UI工具类| 作用说明 |
| --- | --- |
| UI.log(msg) | 在Xcode打印台输出msg |
| UI.alert(title,msg) | 弹出提示框,title标题,msg信息 |
| UI.screenW | 当前iOS设备的屏幕宽度 |
| UI.screenH | 当前iOS设备的屏幕高度 |

    UI其他属性 UI.themeColor，UI.cyanColor，UI.orangeColor， UI.pureColor，
             UI.lightCyanColor，UI.blueColor，UI.pinkRedColor，UI.lightOrgangeColor


| 其他对象 | 作用 |
| :-: | :-: |
| `$actions` | `$actions.xxx`获取某个action |
| `$props` | `$actions.xxx`获取某个自定义属性  |

2.可以调用的全局函数有

| 函数 | 作用 |
| :-: | :-: |
| `$getView(viewId)` | 获取视图 |
| `$dispatch(actionName)` | 触发某个action |

-------

##### 原理说明和JSON值的填充
Objective-c通过网络获取到JSON后，会传递给JavaScript，成为一个对象，这样得以调用一些写好的工具类。

1. **属性调用** - 使用ES6的模板字符串，即可调用工具类的属性或者其他全局属性
2. **颜色设置** - 支持rgb()函数，rgba()函数，十六进制字符串，推荐使用rgb()函数
3. **函数编写** - 使用${()=>{自定义代码}}，一般在按钮的click字段编写，必须使用箭头函数或者function定的函数

例子如下

```
{
"style":{
    "position":"`{{10,66},{${UI.screenW*0.9},120}}`",
    "backgroundColor":"rgb(240,240,240)",
    },
}
```
position调用了UI.screenW属性。backgroundColor使用了rgb函数

-------


### JSON整体格式约定

>
```
{
    "lifeCircle":{}, #视图生命周期
    "controller":{}, #控制器标题，和右上角按钮
    "components":[], #这里面放所有视图，视图包含层级关系，视图里面还可以嵌套"components":[]，里面为该视图的子视图
    "props":{},      #这里面定义的是你自己规定的变量，可以是列表，可以是控制视图是否显示的布尔值，你可以在箭头函数里面改变属性值
    "actions":{},    #这里面定义的都是动作，比如请求数据，更改视图外观等
    "style":{},      #这里面用来改变控制器的外观，标题，标题颜色，背景色等
}
``` 
-------


### lifeCircle说明

lifeCircle里面放的是视图的生命周期,你可以在对应的生命周期做相应的操作，例如：加载数据

```
"lifeCircle":{
    	"viewDidMount":"${()=>{$dispatch('fetchData')}}", #视图已经Mount，可以加载视图所需数据了
    	"viewDidUnmount":"",#视图已经Unmount了
    },
```
        
-------

### controller说明

controller里面放的是页面的一些简要设置

```
"controller":{
    	"title":"页面标题",
    	"backgroundColor":"rgb(xx,xx,xx)",  #页面背景色
    	"rightButton":{ #页面右上角按钮
        	"title":"哈哈",  #按钮标题
        	"click":"${()=>{UI.alert('JSON程序','小示例');}}" #按钮点击事件
        }
    },
```
        
-------
### components说明
>

components里装的是视图，一个视图有4个基本字段

| 字段 | 字段解释 |
| --- | --- |
| id | 视图的唯一标识，可以使用$getView(id)，获取该视图 |
| type | 视图类型：View,ScrollView,Label,ImageView,TextField,TextView,ListView |
| style | 视图的各种属性，例如颜色，圆角，border等 |
| components | 是一个数组，里面装的是嵌套的子视图，子视图也有id,type,style,components字段 |


```
{
    "id":"view1", 
    "type":"View", #规定了一个普通视图
    "style":{
        "position":"`{{10,66},{${UI.screenW*0.3},40}}`", #视图在界面上显示的位置
        "backgroundColor":"`${UI.cyanColor}`", #视图的背景色
        "borderColor":"`${this.props.pureColor}`", #视图边框颜色
        "borderWidth":1, #视图的边框宽度
    },
    "components":[
        {
          "id":"nameLabel",
          "type":"Label", #规定了一个标签视图
          "style":{
              "position":"`{{10,66},{${UI.screenW*0.3},40}}`",
              "backgroundColor":"`${UI.cyanColor}`",
              "text":"标签标题",
              "textColor":"rgb(132,132,132)",
              "align":"center", #标签文字的对其方式，居中还是左，右对其
              },
          },
          {
               "id":"btn",
               "type":"Button", #规定了一个按钮视图
               "style":{
                   "position":"{{200,80},{120,40}}",
                   "title":"请求数据",  #按钮的标题
                   "titleColor":"`${UI.themeColor}`", #按钮标题颜色
                   "fontSize":16, #字体大小
               },
               "click":"${()=>{$props.testIndex++}}", #点击按钮调用的函数
           },
        ]
 }
```

##### 列表视图
列表视图多了一个item字段对应一个cell

举例

```
{
  "id":"listbox",
  "type":"ListView",
  "style":{
      ...,
      "itemSize":"`{${UI.screenW/3},90}`", #小视图大小，宽为屏幕的1/3，高为90
      "itemVMarign":0,
      "itemHMarign":0,
  },
  "item":[ #cell 配置
      {
          "id":"appname",
          "type":"Label",   
          "style":{
              "position":"`{{0,60},{${UI.screenW/3},30}}`",
              "text":"标签",
              ...
          },
      },
      {
          "id":"appicon",
          "type":"ImageView",
          "style":{
              "position":"{{48,30},{26,26}}",
              "image":"https://static.wutnews.net/icon/calendar/2x.png?2",    #图片的URL地址，也可以立即写，等从网络更新
              "imageMode":"aspectfit", #设置图片填充模式
          },
      },
  ],
"dataArray":[   #每个item填充的数据，dataArray有多少个，就有多少个cell
       {
           "itemBackgroundColor":"rgb(110,110,110)",
           "subStyles":[
               {
                   "viewId":"appname",
                   "style":{
                       "text":"标签1",
                        ...
                   }
               },
           ]
       },
       ...
  ],
}
```
ListView的dataArray字段可以省略，如果省略，你可以从网络获取数据

-------

### props说明
    props里面存放自定的变量，可以通过$props.xxx访问
    你可以在此定义一个数组，存放从网络获取的数据
    也可以在此定义一个变量，控制一个视图是否隐藏
    也可以在此定义一个变量，当做计步器使用    

-------

### actions说明,actions一般用于更新UI
    actions里面存放的都是你预先自定义的动作(action)，有网络请求动作，也有更改视图文本，颜色等动作
    目前提供两种。
    每个动作都有名称使用$actions.xxx获取，例如$actions.fetchData
    下面定义了两个动作fetchData(网络请求动作),newState(基本动作)
    
1.使用action
    
        请在按钮的click字段，使用$dispatch('fetchData')，从而action作用于对应视图
    例如:"click":"`${()=>{$props.testIndex++;$dispatch('fetchData')}}`",
        点击按钮后，props.testIndex会加一，并且触发名字为fetchData的action

2.更新UI

    2.1 用于更新UI的数据都是单向流动的，且必须通过视图的style来更新。
    2.2 存在父子视图的数据更新，必须设通过先设置给父视图再设置给子视图数据设置里面的style。
        
举例：现在有一个Label视图，Label视图有若干个子视图，其中有一个Id为appname的Label视图

```
style:{ #父视图的style
    backgroundColor:xxx,
    text:"父视图新标题",   
    subStyles:[ #如果要更新子Label视图，必须添加该字段
        {
             "viewId":"appname",
             "style":{
                 "text":"这是新标题",
             }
        },
        {
            ...
        }
    ]
}
```

-------
现在要请求一个JSON，其截图如下
![](https://github.com/cx478815108/JSONRenderKit/blob/master/screenshots/listViewJSON.png?raw=true)


```
"actions":{
        "fetchData":{
            "viewId":"listbox",   #该动作作用到的视图
            "URLRequest":{
                "type":"get", #网络请求方式 get ,post
                "url":"http://palmwhut.sinaapp.com/member/get_app?timestamp=0&platform=ios",  #请求URL地址
                "check":"${(json)=>{return json.status == '200'}}", #请求完成后检查JSON是否符合预期
                "failure":"${(desc)=>{$UI.alert('信息获取失败'+desc)}}", #请求失败回调
                "success":"${(data)=>{$props.apps.concat(data);}}", #请求成功回调,只用于保存原始数据,可以省掉该字段
                "dataArrayPath":"data",  #从上面截图中的的"data"字段获取需要的数组
                "itemToStyleTemplate":{ #将请求后的数组里面的每一个对象的对应值取出，生成itemToStyleTemplate模型，放进内部数组，传递给finalResult定义的函数，用来更新UI
                    "subStyles":[
                        {
                            "viewId":"appname",
                            "style":{
                                "text":"`${item.name}`", # item就是截图中data数组里面的单个对象
                            }
                        },
                        {
                            "viewId":"appicon",
                            "style":{
                                "image":"`${item.icon[3x]}`", #js命名规范无法使用item.icon.3x获取除非item.icon.x3
                            }
                        },
                    ]
                },
                "render":"${(data)=>{$getView('listbox').addData(data).reloadData()}}", #开始更新ListView 
            },
        },
        "newState":{
            "viewId":"header", #该动作作用到的视图
            "style":{
                "backgroundColor":"rgb(140,140,140)",
                "subStyles":[
                    {
                        "viewId":"nameLabel",
                        "style":{
                            "text":"`new index${$props.testIndex}`",
                        }
                    },
                    ...
                ]
            }
        }
```

-------


### 各种视图说明

`ScrollView,Label,ImageView,TextField,TextView,ListView`,`View`的style同样会影响上面6个视图

View 的style

| style字段 | 作用 |
| :-: | :-: |
| backgroundColor | 视图背景色 |
| cornerRadius | 圆角半径 |
| borderWidth | 边框宽度 |
| borderColor | 边框颜色 |
| hidden | 是否显示 |
| position | 视图坐标 |

-------
ScrollView 的style

| style字段 | 作用 |
| :-: | :-: |
| showVBar | 是否显示竖滚动条 |
| showHBar | 是否显示横滚动条 |
| splitPage | 是否分页 |
| allowScroll | 是否允许滚动 |
| scrollSize | 滚动区域大小 |

-------

Label 的style

| style字段 | 作用 |
| :-: | :-: |
| text | 标签的文字 |
| textColor | 文字颜色 |
| align | 文字对齐方式,取值：left,right,center |
| adjustTextFont | 是否根据标签宽度自动调整字体大小 |

-------

ImageView 的style

| style字段 | 作用 |
| :-: | :-: |
| imageMode | 图片模式 取值：fill,aspectfit,aspectfill |
| image | 图片的url地址，必须包含http |

fill：普通填充  aspectfit：等比缩放  aspectfill：等比填充

-------

TextField 的style

| style字段 | 作用 |
| :-: | :-: |
| textColor | 文字颜色 |
| align | 文字对齐方式,取值：left,right,center |
| borderStyle | 特殊边框样式,取值：none,line,bezel,roundedRect |
| cursorColor | 光标颜色 |
| fontSize | 文字大小 |
| placeholder | 占位文字 |
| showClear | 是否允许编辑时显示清楚按钮 |
| clearOnBegin | 是否允许每次开始编辑时清空 |

可以调用的属性，textField.text

-------

TextView 的style TextView是大文本输入，TextField只能在一行输入

| style字段 | 作用 |
| :-: | :-: |
| textColor | 文字颜色 |
| align | 文字对齐方式,取值：left,right,center |
| cursorColor | 光标颜色 |
| fontSize | 文字大小 |

可以调用的属性，textField.text

-------

ListView 的style 

| style字段 | 作用 |
| :-: | :-: |
| scrollDirection | 列表滚动方向,取值：horizontal,vetical(默认) |
| showVBar | 是否显示竖滚动条 |
| showHBar | 是否显示横滚动条 |
| splitPage | 是否分页 |
| allowScroll | 是否允许滚动 |
| itemSize | 小视图item的大小，取值{width,height} |
| allowScroll | 是否允许滚动 |

可以调用的属性 listView.dataArray
可以调用的方法 listView.setDataArray(传递一个数组)
             listView.addData(传递一个数组) 
             listView.reloadData(刷新视图数据)   




