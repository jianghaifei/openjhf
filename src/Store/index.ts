import { makeAutoObservable } from "mobx";
import { rsRootStore } from "@restosuite/fe-skeleton";
import { merge } from "lodash";
import { createContext, useContext } from "react";
import FinanceStore from "./FinanceStore";
import BizStore from "./BizStore";

// 全局可观察状态
export class RootStore {
  financeStore: FinanceStore;
  loginStore: any;
  bizStore: BizStore;
  constructor() {
    makeAutoObservable(this);
    this.financeStore = new FinanceStore();
    this.bizStore = new BizStore();
  }
}

const rootStore = merge(rsRootStore, new RootStore()) as RootStore;
const StoreContext = createContext(rootStore);

const useStore = () => useContext(StoreContext);

const { financeStore, bizStore } = rootStore;

export { useStore, StoreContext, rootStore, financeStore, bizStore };
