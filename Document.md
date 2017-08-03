

## JSON中可以调用的全局对象,函数,属性

1.可调用的对象只有`UI`,`$props`,`$actions`

| UI工具类| 作用说明 |
| --- | --- |
| UI.log(msg) | 在Xcode打印台输出msg |
| UI.alert(title,msg) | 弹出提示框,title标题,msg信息 |
| UI.showIndicator(style) | 弹出提示器,style可取 'white','whitelarge','gray'|
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


3.新增的API

| API | 作用 |
| :-: | :-: |
| array.removeAtIndex(index) | 删除数组中第index个元素 |


-------

## JSON值的填充

1. **属性调用** - 使用ES6的模板字符串，即可调用工具类的属性或者其他全局属性
2. **颜色设置** - 支持rgb()函数，rgba()函数，十六进制字符串，推荐使用rgb()函数
3. **函数编写** - 使用`${()=>{自定义代码}}`，一般在按钮的click字段编写，必须使用箭头函数或者function定的函数

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
    "components":[], #这里面放所有视图，视图包含层级关系，可嵌套"components":[]，为该视图的子视图
    "props":{},      #这里面定义的是你自己规定的变量
    "actions":{},    #这里面定义的都是动作，比如请求数据，更改视图外观等
    "style":{},      #这里面用来改变控制器的外观，标题，标题颜色，背景色等
}
``` 
-------

## 更新UI
1. 用于更新UI的数据都是单向流动的，且必须通过视图的style来更新。
2. 存在父子视图的数据更新，必须设先设置给父视图,父视图会自动传递给子视图数据，一般更改style属性更新UI

详细请见Demo


### lifeCircle说明

lifeCircle里面放的是JSON执行生命周期,你可以在对应的生命周期做相应的操作，例如：加载数据

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
        	"title":"clickme",  #按钮标题
        	"click":"${()=>{UI.alert('JSON测试','小示例');}}" #按钮点击事件
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


##### 列表视图

列表视图多了以下字段

| 字段 | 说明 |
| :-: | :-: |
| item | 每个item小视图的子视图 |
| itemStyle | 每个item小视图的style |
| dataArray | 数据数组 |

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

目前只有两种action，代表两种动作
    
| action种类 | action说明 |
| --- | --- |
| 普通类 | 用于更新UI |
| 网络请求类 | 用于请求任何JSON后更新listView |
只要你定义的字段包含URLRequest即被视为网络请求类


| URLRequest字段 | 说明 |
| :-: | :-: |
| type | ‘GET’或者’POST' |
| url | json的网络地址 |
| check | 用于检验JSON是否符合你的要求 |
| failure | JSON请求失败回调 |
| success | JSON请求成功回调 - 你可以保存原始数据到$props |
| extractData | 从JSON中提取你需要的数组 |
| willSend | 即将发送请求，你可以弹出菊花指示器 |
| willRender | 即将把数据给listView |
| itemToStyleTemplate | 把你提取的数组按照这个格式转化为数据数组，提供给listView |
| render | 把数据给listView的dataArray |
| didRender | listView数据设置完毕，可以关闭句话指示器了 |


| 普通action字段 | 说明 |
| --- | --- |
| viewId | 这个action作用的视图 |
| valKey | 这个action作用的视图的属性，视图根据valKey传递oldVal到reduce |
| reduce | 请返回一个新数据，新数据将会被设置到视图，更新UI |

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




