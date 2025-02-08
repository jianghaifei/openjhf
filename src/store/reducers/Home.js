import { SET_OPEN_RAGE_ANIMATION_STATUS, SET_RESOURCE_ID } from "../Constant";

const defaultState = {
  resourceIds: {},
  openRageAnimationStatus: false
};
export default (state = defaultState, action) => {
  const { type, payload } = action;
  switch (type) {
    case SET_RESOURCE_ID:
      return {
        ...state,
        resourceIds: payload
      };
    case SET_OPEN_RAGE_ANIMATION_STATUS:
      return {
        ...state,
        openRageAnimationStatus: payload
      };
    default:
      return state;
  }
};
