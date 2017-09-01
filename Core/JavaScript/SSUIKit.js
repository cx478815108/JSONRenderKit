
//模仿NSObject
//to imitate the NSObject
class NSObject{
    constructor(){
        //保存OC对象，相当于强引用了指针
        //save the Objective-C object which is the strong refrence
        this.ocPointer = null;
        //保存OC对象的类名，用于反射创建一个OC实例
        //save the Class name of Objective-C object to creat the instance
        this.ocClsName = 'NSObject';
    }

    setOCPointer(ocPointer){
        this.ocPointer = ocPointer;
    }

    //即将创建OC对象
    //will creat an Objective-C object
    willCreatNative(){}

    //创建OC对象
    //to creat an Objective-C Object
    creatNative(){
        this.willCreatNative();
        //调用OC方法，创建实例，并保存
        //call the method of Objective-C and save the returned value
        this.ocPointer = oc_creatObject(this.ocClsName.firstUpperCase());
        this.didCreatNative();
    }
    //已经创建完对象
    //did creat an Objective-C object
    didCreatNative(){}

    //将JS对象绑定到OC对象
    //bind the JS Object to the relevant Objective-C object
    bindJSValueToOC(){
        //把OC对象放进这个数组，等待JSContext死亡的时候释放，并解除this.ocPointer和JS对象的绑定，防止内存泄漏
        //if you do not this ,it will cause the memory leak
        //So,to break the link between the relevant Objective-C object and JS object
        jsValueObjs.push(this.ocPointer);
        //执行OC实例对象的相应方法
        //invoke the method of the relevant Objective-C object
        oc_invokeWithOneJSArg(this.ocPointer,'setJsValue:',this);
    }

    //调用OC
    //invoke a method of Objective-C object with given parameters
    invokeNative(method,...args){
        return oc_invokeWithArgs(this.ocPointer,method,args);
    }
}

//模仿 UIKit
//to imitate the UIKit
class View extends NSObject{
    constructor(){
        super();
        //保存OC对象，这个对象其实是一个指针
        //save the Objective-C object which is actually a pointer
        this.ocPointer    = null;
        //设置OC对象的类名称，用于OC反射创建对象
        //setup the Class name of Objective-C object
        this.ocClsName    = 'UIView';
        this.ocSubviews   = [];
        this.ocIdentify   = '';
        this.style        = null;
        this.components   = null;
        //加速查找子视图
        //quickly pick up a subview
        this.subviewStore = new Map();
    }

    //由子类自己实现
    initWithJSON(json){
        //生成OC实例并保存
        this.creatNative();
        //设置id
        this.setIdentify(json['id']);
        // 设置style
        this.setStyle(json['style']);
        //设置子组件视图
        this.setComponents(json['components']);
    }

    setStyle(style){
        this.style    = style;
        this.invokeNative("js_setStyle:",style);
        let subStyles = style.subStyles;
        if(getType(subStyles) == 'array'){
            subStyles.forEach((element, index) =>{
                let view  = this.getView(element.viewId);
                let style = element.style;
                view.setStyle(style);
            });
        }
    }

    setState(state){
        if(state.valKey == 'style'){
            this.setStyle(state.value);
        }
    }

    setIdentify(id){
        this.ocIdentify = id;
        this.invokeNative("setSs_identify:",id);
    }

    //设置组件，深度优先遍历
    //setup the subviews using depth-first traversal
    setComponents(components){
        this.components = components;
        //设置子视图
        //add subviews to this.subviews
        if(getType(this.components) == 'array'){
            this.components.forEach((item,index)=>{
                //你可以打印一下 item
                let view = eval(`new ${item.type}()`);
                view.initWithJSON(item);
                this.addSubview(view);
            });
        }
    }

    addSubview(view){
        if(!view) return;
        this.ocSubviews.push(view);
        this.subviewStore.set(view.ocIdentify,view);
        this.invokeNative("addSubview:",view.ocPointer);
    }

    getView(viewId){
        return this.subviewStore.get(viewId);
    }
}


//申明一个UIScrollView,在返回的json中 JS会反射创建这个实例
//declare the UIScrollView,in the response json ,it will creat the JS object throught the reflection
class ScrollView extends View {
    constructor() {
        super();
        this.ocClsName = 'UIScrollView';
    }
}

class Label extends View {
    constructor() {
        super();
        this.ocClsName = 'UILabel';
    }
}

class ImageView extends View {
    constructor() {
        super();
        this.ocClsName = 'UIImageView';
    }
}

class TextField extends View{
    constructor() {
        super();
        this.ocClsName = 'UITextField';
        this.text      = '';
    }

    didCreatNative(){
        this.bindJSValueToOC();
    }

    setText(text){
        this.text = text;
    }
}

class TextView extends TextField{
    constructor() {
        super();
        this.ocClsName = 'UITextView';
    }
}

class Button extends View {
    constructor() {
        super();
        this.ocClsName='UIButton';
    }

    initWithJSON(json){
        super.initWithJSON(json);
        this.clickFun = json['click'];
    }

    didCreatNative(){
        this.bindJSValueToOC();
    }

    didPressedButton(){
        this.clickFun.runWithArgs();
    }
}

class ListView extends View {
    constructor(){
        super();
        this.ocClsName = 'SSListView';
        this.dataArray = [];
        this.clickItem = null;
        this.itemStyle = null;
    }

    initWithJSON(json){
        super.initWithJSON(json);
        this.clickItem = json.clickItem;
        this.itemStyle = json.itemStyle;
        this.invokeNative('js_setTemplateComponents:',json.item);
        if (this.itemStyle) {this.invokeNative('setItemStyle:',this.itemStyle);}
        if(json.dataArray){
            this.setDataArray(json.dataArray);
            this.reloadData();
        }
    }

    setDataArray(array){
        this.dataArray = array;
        return this;
    }

    addDatas(array){
        this.dataArray = this.dataArray.concat(array);
        return this;
    }

    removeItemAtIndex(index){
        this.invokeNative('deleteItemAtIndexString:',''+index);
        this.dataArray = this.invokeNative('dataArray');
    }

    addItemAtIndex(index,data){
        this.invokeNative('addItem:atIndexString:',data,''+index);
        this.dataArray = this.invokeNative('dataArray');
    }

    pushItem(data){
        this.invokeNative('addItemToTrail:',data,''+index);
        this.dataArray = this.invokeNative('dataArray');
    }

    popItem(){
        this.invokeNative('deleteItemAtIndexString:',''+this.dataArray.length);
        this.dataArray = this.invokeNative('dataArray');
    }

    setState(state){
        if(state.valKey == 'itemStyle'){
            this.itemStyle = state.value;
            this.invokeNative('setItemStyle:',this.itemStyle);
            this.reloadData();
        }
        else if(state.valKey == 'dataArray'){
            this.dataArray = state.value;
            this.reloadData();
        }
    }

    goNextPage(){
        this.invokeNative('js_goNextPage');
    }

    goPreviousPage(){
        this.invokeNative('js_goPreviousPage');
    }

    didCreatNative(){
        this.bindJSValueToOC();
    }

    didSelectItemAtIndex(index){
        if(this.clickItem){
            this.clickItem.runWithArgs(index);
            this.invokeNative('js_setDataArrays:',this.dataArray);
        }
    }

    reloadData(){
        this.invokeNative('js_setDataArrays:',this.dataArray);
        this.invokeNative('js_reloadData');
        return this;
    }
}

//不是模仿Controller ,只是声明一个辅助类，帮助运行JSON
//declare a JS Class to help running
class Controller {
    constructor(){
        this.wrapperView = new View();
        this.viewStore   = new Map();
        this.lifeCircle  = null;
        this.config      = null;
    }

    initWithJSON(json){
        this.components = json['components'];
    }

    viewDidMount(){
        if(this.lifeCircle && this.lifeCircle.viewDidMount){
            this.lifeCircle.viewDidMount.runWithArgs();
        }
    }

    viewDidUnmount(){
        if(this.lifeCircle && this.lifeCircle.viewDidUnmount){
            this.lifeCircle.viewDidUnmount.runWithArgs();
        }
    }

    rightButtonClick(){
        if(this.config && this.config.rightButton){
            this.config.rightButton.click.runWithArgs();
        }
    }

    produceSubviews(){
        if(!this.components) return;
        this.components.forEach((item,index)=>{
            let view = eval(`new ${item.type}()`);
            view.initWithJSON(item);
            this.wrapperView.addSubview(view);
            this.viewStore.set(view.ocIdentify,view);
        });
    }
}

/**
 * the AppProps ,represent the props in the given json
 */
class AppProps{
    constructor(props){
        for(let key in props){
            this[key] = props[key];
        }
    }

    copy(){
        let _copy = new AppProps(this);
        return _copy;
    }

    getCopy(valueKey){
        return keyValuesClone(this[valueKey]);
    }

    runFuncs(index,...args){
        let funcs = this['$runFunctions'];
        if(isArray(funcs)){
            let funcString = funcs[index];
            funcString.runWithArgs(...args);
        }
    }
}

let controller  = new Controller();
let jsValueObjs = [];
let $props      = null;
let $actions    = null;

const $getView    = (viewId) => {return controller.viewStore.get(viewId)};

/**
 * 开始处理 Objective-C 从网络请求并返回的JSON
 * start to handle the JSON which is Objective-C requested from the Internet
 * @param  JSON json                   从网络请求并返回的JSON
 * @param  ocWrapperViewPointer        一个父视图，用于添加生成的子视图
 * @return UIView                      ocWrapperViewPointer
 */
const renderWithJSON = (json,ocWrapperViewPointer) =>{
    let newJSON           = keyValuesClone(json);
    $props                = new AppProps(newJSON.props);
    $actions              = newJSON.actions;
    controller.lifeCircle = json.lifeCircle;
    controller.config     = json.controller;
    //清空,加速recoverJSON
    json.actions          = null;
    json.props            = null;
    json.lifeCircle       = null;
    json.controller       = null;
    // 恢复正常的JSON,将字符串中的变量还原为真是数值
    // recover the json ,replace the variable value with real value
    recoverJSON(json);
    controller.wrapperView.setOCPointer(ocWrapperViewPointer);
    // 进行配置
    controller.initWithJSON(json);
    controller.produceSubviews();
    // 渲染完毕
    oc_renderFinish();
}
