import { createContext } from "react";
import RootStore from "./root";

const StoreContext = createContext<RootStore>(new RootStore());

export default StoreContext;
