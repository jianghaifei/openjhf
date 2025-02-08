import { CHANGE_HEADER_MENU_INDEX, CHANGE_NAVIGATION_VISIBLE } from "../Constant";

const defaultState = {
  currentMenuIndex: null,
  navigationContentVisible: false
};
export default (state = defaultState, action) => {
  const { type, payload } = action;
  switch (type) {
    case CHANGE_HEADER_MENU_INDEX:
      return {
        ...state,
        currentMenuIndex: payload
      };
    case CHANGE_NAVIGATION_VISIBLE:
      return {
        ...state,
        navigationContentVisible: payload
      };
    default:
      return state;
  }
};
