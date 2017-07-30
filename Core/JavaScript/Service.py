#-*-coding:utf-8-*-
import sys
import time
from flask import Flask,jsonify
app = Flask(__name__)

appJSON={
    "controller":{
        "title":"JSON程序示例",
        "rightButton":{
        	"title":"点击",
        	"click":"${()=>{UI.alert('JSON程序','小示例');}}"
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
                "position":"`{{10,66},{${UI.screenW*0.9},120}}`",
                "backgroundColor":"rgb(240,240,240)",
            },
            "components":[
                {
                    "id":"nameLabel",
                    "type":"Label",
                    "style":{
                        "position":"`{{10,20},{${UI.screenW*0.3},40}}`",
                        "backgroundColor":"`${UI.cyanColor}`",
                        "text":"内部视图的标签",
                        "textColor":"rgb(132,132,132)",
                        "align":"center",
                        "adjustTextFont":1,
                    },
                },
                {
                    "id":"testBtn",
                    "type":"Button",
                    "style":{
                        "position":"{{200,40},{120,40}}",
                        "title":"这是按钮",
                        "titleColor":"`${UI.themeColor}`",
                        "fontSize":16,
                    },
                    "click":"${()=>{$dispatch('fetchData')}}",
                },
            ]
        },
        {
            "id":"listbox",
            "type":"ListView",
            "style":{
                "position":"`{{0,260},{${UI.screenW},270}}`",
                "backgroundColor":"rgb(250,250,250)",
                "itemSize":"`{${UI.screenW/3},90}`",
                "itemVMarign":0,
                "itemHMarign":0,
                "scrollDirection":"vertical"
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
