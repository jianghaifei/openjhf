import { makeAutoObservable } from "mobx";
import _ from "lodash";

class FinanceStore {
  // 认证主体各个步骤的值
  collectionPayeeStepData: any = {};
  // 要copy的认主体数据
  copySourceData: any = {};
  // 禁用的表单项，一般复核的时候会用到
  disableInputList: string[] = [];
  // 列表展示类型 list 或者card
  listRenderType = "list";
  constructor() {
    makeAutoObservable(this);
  }
  /**
   * 
   */
  setDisableInputList(keys: string[]) {
    this.disableInputList = keys;
  }

  /**
   * 保存认证主体数据
   * @param type 类型 01小微  02个体工商户 03企业
   * @param index 步骤 0-4，根据类型有不同步骤
   * @param data  数据
   */
  savePayeeData(type: string, index: number, data: any) {
    const newObj = { ...this.collectionPayeeStepData };
    if (!newObj[type]) {
      newObj[type] = {};
    }
    if (!newObj[type][index]) {
      newObj[type][index] = {};
    }
    newObj[type][index] = data;
    this.collectionPayeeStepData = newObj;
  }
  clearPayeeData() {
    this.collectionPayeeStepData = {};
    this.copySourceData = {};
  }

  // 拷贝数据
  setCopyData(data: any) {
    this.copySourceData = { ...data };
  }
  // 修改展示类型
  setListRenderType(type: string) {
    this.listRenderType = type || "list";
  }
}

export default FinanceStore;
