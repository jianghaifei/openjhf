import DesignerStore from "./designer";
import SchemeStore from "./scheme";
import ThemeStore from "./theme";

class RootStore {
  designerStore: DesignerStore;
  themeStore: ThemeStore;
  schemeStore: SchemeStore;

  constructor() {
    this.schemeStore = new SchemeStore(this);
    this.designerStore = new DesignerStore(this);
    this.themeStore = new ThemeStore(this);
  }
}

export default RootStore;
