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
	            "type":"GET",
	            "url":"http://palmwhut.sinaapp.com/member/get_app?timestamp=0&platform=ios",
	            "check":"${(json)=>{return json.status == '200';}}",
	            "failure":"${(desc)=>{UI.alert('信息获取失败',desc)}}",
	            "extractData":"${(json)=>{$props.apps=$props.apps.concat(json.data);return json.data;}}",
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
                "render":"${(data)=>{$getView('listbox').setDataArray([]).addDatas(data).reloadData()}}",
            },
        },
	}
}

translation={
    "controller":{
        "title":"翻译示例",
    },
    "components":[
    	{
    		"id":"searchField",
    		"type":"TextField",
    		"style":{
    			"position":"`{{6,6},{${UI.screenW-80},36}}`",
	            "textColor":"rgb(80,80,80)",
	            "borderStyle":"none",
	            "backgroundColor":"rgb(240,240,240)",
	            "cornerRadius":4,
	            "placeholder":"请输入你要翻译的单词",
    		}
    	},
    	{
    		"id":"searchButton",
    		"type":"Button",
    		"style":{
    			"position":"`{{${UI.screenW-68},4},{68,40}}`",
	            "titleColor":"rgb(40,40,40)",
	            "title":"search"
    		},
    		"click":"${()=>{$dispatch('transAction');}}"
    	},
    	{
    		"id":"resultList",
    		"type":"ListView",
    		"style":{
    			"position":"`{{0,60},{${UI.screenW},${UI.screenH-60}}}`",
        		"itemSize":"`{${UI.screenW},54}`",
        		"itemVMarign":0,
        		"scrollDirection":"vertical",
    		},
    		"itemStyle":{
        		"separatorDirection":"bottom",
        		"separatorColor":"rgb(240,240,240)",
        	},
        	"item":[
        		{
        			"id":"fixLabel",
        			"type":"Label",
        			"style":{
        				"position":"`{{13,8},{${UI.screenW-13},20}}`",
        				"fontSize":12,
        				"textColor":"rgb(200,200,200)",
        			}
        		},
        		{
        			"id":"descLabel",
        			"type":"Label",
        			"style":{
        				"position":"`{{13,30},{${UI.screenW-13},20}}`",
        				"fontSize":14,
        				"textColor":"rgb(80,80,80)",
        			}
        		},
        	],
        	"dataArray":[
        		{
        			"subStyles":[
	        			{
	        				"viewId":"fixLabel",
	                   		"style":{
	                   			"text":"译文",
	                   		},
                		},
                		{
	        				"viewId":"descLabel",
	                   		"style":{
	                   			"text":"Who am I?",
	                   		},
                		},
           			]
       			},
       			{
        			"subStyles":[
	        			{
	        				"viewId":"fixLabel",
	                   		"style":{
	                   			"text":"译文",
	                   		},
                		},
                		{
	        				"viewId":"descLabel",
	                   		"style":{
	                   			"text":"Who are you?",
	                   		},
                		},
           			]
       			},
        	]
    	}
    ],
    "props":{
    	"transResults":[]
    },
    "actions":{
    	"transAction":{
            "viewId":"resultList",
            "URLRequest":{
	            "type":"get",
	            "url":"`https://dict.bing.com.cn/api/http/v2/4154AA7A1FC54ad7A84A0236AA4DCAF3/zh-cn/en-us/?q=${$getView('searchField').text}&format=application/json`",
	            "check":"${(json)=>{return true}}", #进行检查 必须返回一个布尔值
	            "failure":"${(desc)=>{UI.alert('信息获取失败',desc)}}",
	            # "success":"${(data)=>{$props.apps=$props.apps.concat(data);}}", #将结果进行保存
	            "extractData":"${(json)=>{return json.LEX.C_DEF[1].SEN}}",
	            "willRender":"",
                "willSend":"${()=>{UI.showIndicator('gray');}}",
                "itemToStyleTemplate":{
                    "subStyles":[
                		{
                			"viewId":"descLabel",
                			"style":{
                				"text":"`${item.D}`",#item.icon.3x 语法格式不正确
                            }
                        },
                        {
                			"viewId":"fixLabel",
                			"style":{
                				"text":"译文",#item.icon.3x 语法格式不正确
                            }
                        },
                    ]
                },
                "render":"${(renderData)=>{$getView('resultList').setDataArray([]).addDatas(renderData).reloadData()}}",
                "didRender":"${()=>{UI.hideIndicatorDelay(0.618)}}",
            },
        },
    }
}


todo={
    "controller":{
        "title":"todo",
    },
    "components":[
        {
            "id":"addField",
            "type":"TextField",
            "style":{
                "position":"`{{6,6},{${UI.screenW-80},36}}`",
                "textColor":"rgb(80,80,80)",
                "borderStyle":"none",
                "backgroundColor":"rgb(240,240,240)",
                "cornerRadius":4,
                "placeholder":"请输入项目",
            }
        },
        {
            "id":"addButton",
            "type":"Button",
            "style":{
                "position":"`{{${UI.screenW-68},4},{68,40}}`",
                "titleColor":"rgb(40,40,40)",
                "title":"add"
            },
            "click":"${()=>{$dispatch('addToDo');}}"
        },
        {
            "id":"todoList",
            "type":"ListView",
            "style":{
                "position":"`{{0,60},{${UI.screenW},${UI.screenH-60-64}}}`",
                "itemSize":"`{${UI.screenW},60}`",
                "itemVMarign":0,
                "scrollDirection":"vertical",
            },
            "itemStyle":{
                "separatorDirection":"bottom",
                "separatorColor":"rgb(240,240,240)",
                "itemHighlightColor":"rgb(220,220,220)",
            },
            "item":[
                {
                    "id":"nameLabel",
                    "type":"Label",
                    "style":{
                        "position":"`{{13,8},{${UI.screenW/2-13},20}}`",
                        "fontSize":18,
                        "textColor":"rgb(20,20,20)",
                        "adjustTextFont":1,
                    }
                },
                {
                    "id":"deleteLabel",
                    "type":"Label",
                    "style":{
                        "position":"`{{13,30},{${UI.screenW/2-13},20}}`",
                        "fontSize":14,
                        "textColor":"rgb(90,90,90)",
                        "adjustTextFont":1,
                    }
                },
            ],
            "clickItem":"${(index)=>{$props.selectedIndex=index;$dispatch('removeToDo')}}",
            "dataArray":[
                {
                    "subStyles":[
                        {
                            "viewId":"nameLabel",
                            "style":{
                                "text":"apple",
                            },
                        },
                        {
                            "viewId":"deleteLabel",
                            "style":{
                                "text":"tap to delete",
                            },
                        },
                    ]
                },
                {
                    "subStyles":[
                        {
                            "viewId":"nameLabel",
                            "style":{
                                "text":"orange",
                            },
                        },
                        {
                            "viewId":"deleteLabel",
                            "style":{
                                "text":"tap to delete",
                            },
                        },
                    ]
                },
            ]
        }],
    "props":{
        "selectedIndex":-1,
        "toDoItemStyle":{
            "subStyles":[
                {
                    "viewId":"nameLabel",
                    "style":{
                        "text":"`${$getView('addField').text}`",
                    },
                },
                {
                    "viewId":"deleteLabel",
                    "style":{
                        "text":"tap to delete",
                    },
                },
            ]
        },
    },
    "actions":{
        "removeToDo":{
            "viewId":"todoList",
            "valKey":"dataArray",
            "reduce":"${(oldVal)=>{return oldVal.removeAtIndex($props.selectedIndex);}}",
        },
        "addToDo":{
            "viewId":"todoList",
            "valKey":"dataArray",
            "reduce":"${(oldVal)=>{oldVal.push($props.getCopy('toDoItemStyle'));return oldVal;}}",
        }
    }
}

@app.route('/')
def hello_world():
    return 'JSON render Hello World!'

@app.route('/appjson', methods=['GET'])
def get_appjson():
    return jsonify(appJSON)

@app.route('/trans', methods=['GET'])
def get_translation():
    return jsonify(translation)

@app.route('/todo', methods=['GET'])
def get_todo():
    return jsonify(todo)

if __name__ == '__main__':
    app.run()
