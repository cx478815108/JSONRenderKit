const isArray        = value => Object.prototype.toString.call(value) == '[object Array]';
const getType        = obj => ({}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase());
const keyValuesClone = obj => JSON.parse(JSON.stringify(obj));

const isFunString = (str) => {
    let regExp = /\$\{.*?\}/g;
    return regExp.test(str);
}

const isTemplateString = (str) => {
    let regExp = /\`.*?\`/g;
    return regExp.test(str);
}

const recoverJSON = (obj,bindContext = null) => {
    let type = typeof obj ;
    if (!bindContext) bindContext = obj;
    if (type == "object") {
        for (let key in obj) {
            let value = obj[key];
            if(typeof value == "string"){
                if(isTemplateString(value)){
                    value = "return "+value;
                    obj[key] = (new Function(value)).call(bindContext);
                }
            }
            recoverJSON(obj[key],bindContext);
        }
    }
}

const runScript = (script) =>{
    if(script == "undefined") return ;
    if(!isFunString(script)) return ;
    let funScript = script.replace('${', '{return ');
    let fun = new Function(funScript)();
    fun();
}

class URLRequest{
    constructor(obj){
        //显示赋值,提取JSON action是网络请求里面的东西
        this.url                 = obj.url;
        this.type                = (obj.type?obj.type: 'GET').toLocaleString();
        this.failure             = obj.failure?obj.failure.replace('${', '{return '): '';
        this.success             = obj.success?obj.success.replace('${', '{return '): '';
        this.check               = obj.check.replace('${', '{return ');
        this.render              = obj.render.replace('${', '{return ');
        this.dataKeyPath         = obj.dataArrayPath;
        this.parameters          = obj.parameters;
        this.itemToStyleTemplate = obj.itemToStyleTemplate;
    }

    excute(){
        //如果URL是模板字符串，还原为真实字符串
        //check if this.url is template string
        if(isTemplateString(this.url)){
            this.url = "return " + value;
            this.url = (new Function(value)).call(bindContext);
        }

        //开始调用OC的网络请求
        //start to send the Internet request
        oc_urlRequest(this.url,this.type,this.parameters,(json)=>{
            let checkFun        = new Function(this.check)();
            if (checkFun(json)) {//进行检查
                let realData    = json[this.dataKeyPath];
                //回调 success
                if(this.success){
                    let successFun   = new Function(this.success)();
                    successFun(realData);
                }
                // render
                let renderDatas = this.mapWithTemplate(realData,this.itemToStyleTemplate);
                let renderFun   = new Function(this.render)();
                    renderFun(renderDatas);
            }
            else{
                let failureFun = new Function(this.check)();
                failureFun('状态码不正确');
            }
        },(desc)=>{
            let failureFun = new Function(this.check)();
            failureFun(desc);
        });
    }

    /**
     * mapWithTemplate 从获取的JSON中，取出需要的值，并按模板生成数组，方便给ListView赋值 更新视图
     * mapWithTemplate fetch the value
     * @param  objs     the values array that contain the value you need
     * @param  template the template to produce the Styles could be used to update the ListView
     */
    mapWithTemplate(objs,template){
        let string = JSON.stringify(template).replace(/\${item/g, '${this');
        let result = [];
        objs.forEach((element, index) => {
            let newObj = JSON.parse(string);
            recoverJSON(newObj,element);
            result.push(newObj);
        });
        return result;
    }
}