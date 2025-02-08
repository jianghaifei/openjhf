import { CHANGE_REAL_NAME_INFO } from "../Constant";
import UserService from "../../services/user/UserService";

export const changeRealNameInfo = info => ({
  type: CHANGE_REAL_NAME_INFO,
  info
});

export const queryRealNameInfo = (params, cb) => {
  return dispatch => {
    UserService.show1(params).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      if (result.id) {
        result.isRealName = result.checkStatus === 3;
        localStorage.setItem("id", result.id);
        dispatch(changeRealNameInfo(result));
        if (cb) cb(result);
      } else {
        dispatch(changeRealNameInfo({ isRealName: false }));
        if (cb) cb({ isRealName: false });
      }
    });
  };
};
