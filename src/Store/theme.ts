import { makeAutoObservable } from "mobx";
import RootStore from "./root";

class ThemeStore {
  rootStore: RootStore;

  constructor(rootStore: RootStore) {
    makeAutoObservable(this);
    this.rootStore = rootStore;
  }
}

export default ThemeStore;
