Object.assign(String.prototype,{
    runWithArgs(...args){
        if(!this.isFunString()){
            console.log(this + ' is not a valid function string in JSONRenderKit!');
            return;
        }
        let funScript = this.replace('${', '{return ');
        let fun       = new Function(funScript)();
        return fun(...args);
    },
    isFunString(){
        let testStr = this.toString();
        return testStr.startsWith('${') && testStr.endsWith('}');
    },
    isTemplateString(){
        let testStr = this.toString();
        return testStr.startsWith('`') && testStr.endsWith('`');
    },
    firstUpperCase(){
        return this.replace(/^\S/,(s)=>{return s.toUpperCase()});
    },
    containSubStr(string){
        return this.indexOf(string)>0;
    }
});

Object.assign(Array.prototype,{
    removeAtIndex(index){
        if(index>=0 && index+1<=this.length){
            this.splice(index,1);
        }
        return this;
    }
});

const isArray          = value => Object.prototype.toString.call(value) == '[object Array]';
const getType          = obj   => ({}.toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase());
const keyValuesClone   = obj   => JSON.parse(JSON.stringify(obj));

const recoverJSON = (obj,bindContext = null) => {
    let type = typeof obj ;
    if (!bindContext) bindContext = obj;
    if (type == "object") {
        for (let key in obj) {
            let value = obj[key];
            if(typeof value == "string"){
                if(value.isTemplateString()){
                    value = "return "+value;
                    obj[key] = (new Function(value)).call(bindContext);
                }
            }
            recoverJSON(obj[key],bindContext);
        }
    }
}

class URLRequest{
    constructor(obj){
        this.requestObj = keyValuesClone(obj);
        //规定的字段 type,url,check,parameters,failure,success,extractData,itemToStyleTemplate,willRender,render
    }

    excute(){
        this.willSendRequest();

        //如果URL是模板字符串，还原为真实字符串
        //check if this.url is template string
        let url = this.requestObj.url;
        if(url.isTemplateString()){
            url = "return " + url;
            url = (new Function(url))();
        }

        let type = this.requestObj.type;
        type = type.toLocaleUpperCase();

        //处理POST参数
        let parameters = this.requestObj.parameters;
        if(parameters){ recoverJSON(parameters);}
        //开始调用OC的网络请求
        //start to send the Internet request
        oc_urlRequest(url,type,parameters,(json)=>{
            if(this.check(json)){
                //json检查通过
                this.success(json);
                //开始抽取需要的数据
                let dataExtracted = this.extractRenderData(json);
                //将数据进行转换
                let renderData    = this.mapRenderData(dataExtracted);
                //准备render
                this.willRender(renderData);
                //render
                this.render(renderData);
                this.didRender();
            }
            else{
                this.failure('状态码不正确');
            }
        },(desc)=>{
            this.failure(desc);
        });
    }

    willSendRequest(){
        if(this.requestObj.willSend){
            this.requestObj.willSend.runWithArgs();
        }
    }

    //检查JSON是否符合要求
    //check if the json meets your requirements
    check(json){
        if(this.requestObj.check){
            return this.requestObj.check.runWithArgs(json);
        }
        return false;
    }

    //JSON检查不通过
    //check the json failure
    failure(desc){
        if(this.requestObj.failure){
            this.requestObj.failure.runWithArgs(desc);
        }
    }

    //JSON检查通过
    //check the json success
    success(json){
        if(this.requestObj.success){
            this.requestObj.success.runWithArgs(json);
        }
    }

    //从网络请求的JSON中获取你需要的数组
    //extract the data array you need form the returned json
    extractRenderData(json){
        if(this.requestObj.extractData){
            return this.requestObj.extractData.runWithArgs(json);
        }
        return [];
    }

    /**
     * mapRenderData
     * 根据所给的originData，按模板生成新数组，方便给ListView赋值 更新视图
     * @param  originData   从extractRenderData返回的数组
     */
    /**
     * mapRenderData
     * generate the new data array from originData
     * the new array meets the data formatter that is the listView required
     * @param  originData   the array that returned from extractRenderData
     */
    mapRenderData(originData){
        if(getType(originData) != 'array') return;
        if(originData.length == 0)         return;
        if(!this.requestObj.itemToStyleTemplate) {
            UI.log('itemToStyleTemplate is not given');
            return;
        }
        let string = JSON.stringify(this.requestObj.itemToStyleTemplate).replace(/\${item/g, '${this');
        let result = [];
        originData.forEach((element, index) => {
            let newObj = JSON.parse(string);
            recoverJSON(newObj,element);
            result.push(newObj);
        });
        return result;
    }

    //即将刷新UI
    //will render the data to listView
    willRender(dataArray){
        if(this.requestObj.willRender){
            this.requestObj.willRender.runWithArgs(dataArray);
        }
    }

    //根据数组刷新UI
    //render the data to listView
    render(dataArray){
        if(this.requestObj.render){
            this.requestObj.render.runWithArgs(dataArray);
        }
    }

    didRender(){
        if (this.requestObj.didRender) {
            this.requestObj.didRender.runWithArgs();
        }
    }
}

class State{
    constructor(){
        this.valKey = null;
        this.value  = null;
    }
}

/**
 * 用于更新视图数据
 * dispatch a given action to the specific view whose is is the viewId with Style to update athe view
 * @param  type  json里面定义好的action
 * @param  type  the action defined in the given json
 */
let $dispatch = (type)=>{
    //取action
    let newAction = keyValuesClone($actions[type]);
    //action会请求网络
    if (newAction.URLRequest) {
        let request = new URLRequest(newAction.URLRequest);
        request.excute();
    }
    else{
        //恢复正常值
        recoverJSON(newAction);
        let view   = controller.viewStore.get(newAction.viewId);
        //取出旧值
        let oldVal = view[newAction.valKey];
        //取出视图
        let reduceScript = newAction.reduce;

        //检测是否引用了$props的属性，可能需要恢复真是数值
        let check = reduceScript.containSubStr('$props.');
        //备份一份
        let $propsCopy = $props.copy();

        if(reduceScript){
            let newVal    = reduceScript.runWithArgs(oldVal);
            if(check) {
                recoverJSON(newVal);
                $props=$propsCopy;
            }

            let newState    = new State();
            newState.valKey = newAction.valKey;
            newState.value  = newVal;
            view.setState(newState);
        }
    }
}