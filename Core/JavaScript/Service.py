#-*-coding:utf-8-*-
import sys
import time
from flask import Flask,jsonify
app = Flask(__name__)

appJSON={
    "controller":{
        "title":"JSON程序示例",
        "rightButton":{
            "title":"请求",
            "click":"${()=>{$dispatch('fetchData')}}"
        }
    },
    "lifeCircle":{
        "viewDidMount":"${()=>{$dispatch('fetchData')}}",
    },
    "components":[
    	{
    		"id":"header",
            "type":"View",
            "style":{
            	"position":"`{{2,0},{${UI.screenW-2},200}}`",
            	"backgroundColor":"rgb(255,255,255)",
            },
            "components":[
            	{
                    "id":"nameLabel",
                    "type":"TextView",
                    "style":{
	                    "position":"`{{6,6},{${UI.screenW-12},264}}`",
	                    "backgroundColor":"`rgb(255,255,255)`",
	                    "text":"	相信大家肯定有这样的烦恼，因为各式各样的需求，每次app更新版本都需要编码->测试->打包->提交app store 审核，这样花费的时间太多，又或者你会想到这不是有现成的解决方案嘛，ReactNative就可以，并且可以热更新（不同于JSPatch）。是的，但是我不想因为简单的需求就引入那么多文件，更增加了app体积。JSONRenderKit核心就只有几个.h.m文件。\n\n    同时一个非常好玩的库，不用重新command+R，只要改动JSON就可以看到新的UI效果。之所以说他好玩，因为它可以做很多彩蛋，给用户惊喜。\n\n并且我也已经正式放进项目-（”掌上理工大 “app store 可以搜索）里面使用啦，并且抽出代码，详细注释做成了Demo放在github。你也可以修改源代码并扩展新组件后放进的你自己的项目，重要的是你也可以参考JavaScript是怎样和OC进行交互的,代码里面有详细的注释。要是有兴趣，你可以自己将他打造成为一个有用的工具。",
	                    "textColor":"rgb(132,132,132)",
	                    "cornerRadius":4,
	                    "borderColor":"rgb(244,244,244)",
	                    "borderWidth":1,
	                    "allowEdit":0,
	                    "fontSize":14.0,
                	},
            	},
            ]
        },
        {
        	"id":"listbox",
        	"type":"ListView",
        	"style":{
        		"position":"`{{0,270},{${UI.screenW},270}}`",
        		"itemSize":"`{${UI.screenW/3},90}`",
        		"itemVMarign":0,
        		"itemHMarign":0,
        		"scrollDirection":"vertical",
        	},
        	"itemStyle":{
        		"separatorDirection":"right|bottom",
        		"separatorColor":"rgb(240,240,240)",
        	},
        	"clickItem":"${(index)=>{UI.alert('you pressed',$props.apps[index].name)}}",
        	"item":[
        		{
        			"id":"appname",
        			"type":"Label",
        			"style":{
        				"position":"`{{0,60},{${UI.screenW/3},30}}`",
        				"text":"标签",
        				"align":"center",
        				"fontSize":14,
        				"textColor":"rgb(130,130,130)",
        			},
                },
                {
                	"id":"appicon",
                	"type":"ImageView",
                	"style":{
                		"position":"{{48,30},{26,26}}",
                		"image":"https://static.wutnews.net/icon/calendar/2x.png?2",
                		"imageMode":"aspectfit",
                	},
                },
            ],
        }
    ],
	"props":{
    	"testIndex":1,
        "apps":[],
    },
    "actions":{
        "fetchData":{
            "viewId":"listbox",
            "URLRequest":{
	            "type":"get",
	            "url":"http://palmwhut.sinaapp.com/member/get_app?timestamp=0&platform=ios",
	            "check":"${(json)=>{return json.status == '200'}}", #进行检查 必须返回一个布尔值
	            "failure":"${(desc)=>{$UI.alert('信息获取失败',desc)}}",
	            "success":"${(data)=>{$props.apps=$props.apps.concat(data);}}", #将结果进行保存
	            "dataArrayPath":"data",
                "itemToStyleTemplate":{
                "subStyles":[
                	{
                		"viewId":"appname",
                		"style":{
                			"text":"`${item.name}`",
                			}
                		},
                		{
                			"viewId":"appicon",
                			"style":{
                				"image":"`${item.icon['3x']}`",#item.icon.3x 语法格式不正确
                                }
                            },
                    ]
                },
                "render":"${(renderData)=>{$getView('listbox').setDataArray([]).addData(renderData).reloadData()}}",
            },
        },
        "newState":{
            "viewId":"header",
            "style":{
                "backgroundColor":"rgb(140,140,140)",
                "subStyles":[
                	{
                		"viewId":"nameLabel",
                		"style":{
                			"text":"`index${$props.testIndex}`",
                		}
                	},
	                {
	                "viewId":"testBtn",
	                "style":{
	                	"title":"`new index${$props.testIndex}`",
	                	}
	                }
                ]
        	}
		}
	}
}

@app.route('/')
def hello_world():
    return 'JSON render Hello World!'

@app.route('/appjson', methods=['GET'])
def get_appjson():
    return jsonify(appJSON)

if __name__ == '__main__':
    app.run()
