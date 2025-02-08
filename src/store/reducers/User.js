import { CHANGE_REAL_NAME_INFO } from "../Constant";

const defaultState = {
  isRealName: false,
  checkStatus: 0,
  id: localStorage.getItem("id") - 0 || -1
};

export default (state = defaultState, action) => {
  switch (action.type) {
    case CHANGE_REAL_NAME_INFO:
      return {
        ...state,
        isRealName: action.info.isRealName,
        checkStatus: action.info.checkStatus,
        id: action.info.id
      };
    default:
      return state;
  }
};
