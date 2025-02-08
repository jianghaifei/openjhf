import { fromJS } from "immutable";
import { SET_QUESTION_MENU_KEY, SET_QUESTION_BREADCRUMBS } from "../Constant";

const defaultState = fromJS({
  menuKey: "",
  breadcrumbs: []
});
export default (state = defaultState, action) => {
  const { type, payload } = action;
  switch (type) {
    case SET_QUESTION_MENU_KEY:
      return state.set("menuKey", payload);
    case SET_QUESTION_BREADCRUMBS:
      return state.set("breadcrumbs", fromJS(payload));
    default:
      return state;
  }
};
