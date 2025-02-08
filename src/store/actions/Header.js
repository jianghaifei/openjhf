import { CHANGE_HEADER_MENU_INDEX, CHANGE_NAVIGATION_VISIBLE } from "../Constant";

export const changeCurrentMenuIndex = index => ({
  type: CHANGE_HEADER_MENU_INDEX,
  payload: index
});

export const changeNavigationVisible = index => ({
  type: CHANGE_NAVIGATION_VISIBLE,
  payload: index
});
