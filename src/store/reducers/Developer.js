import { fromJS } from "immutable";
import { SET_DEVELOPER_MENU_KEY } from "../Constant";

const defaultState = fromJS({
  menuKey: ""
});
export default (state = defaultState, action) => {
  const { type, payload } = action;
  switch (type) {
    case SET_DEVELOPER_MENU_KEY:
      return state.set("menuKey", payload);
    default:
      return state;
  }
};
