import { SET_QUESTION_BREADCRUMBS, SET_QUESTION_MENU_KEY } from "../Constant";

export const setMenuKey = menuKey => ({
  type: SET_QUESTION_MENU_KEY,
  payload: menuKey
});
export const setBreadcrumbs = data => ({
  type: SET_QUESTION_BREADCRUMBS,
  payload: data
});
