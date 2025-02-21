import {JSX} from "react";
import ComponentType from "../Constants/ComponentType.ts";
class SchemaComponentHelper {
    static instance: SchemaComponentHelper
    components: {
        [key: string]: JSX.ElementType
    }

    constructor() {
        this.components = require("../Components/Schemas")
    }

    static getInstance() {
        if (!this.instance) {
            this.instance = new SchemaComponentHelper()
        }
        return this.instance
    }

    /**
     * @description 根据 type 获取 schema 组件
     * */
    getComponentByType(type:ComponentType){
        if(!(type in this.components)){
            return null
        }
        return this.components[type]
    }
}

export default SchemaComponentHelper.getInstance()
