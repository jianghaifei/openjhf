import { message } from "antd";
import {
  CHANGE_DEVELOPER_PROTOCOL_DIALOG_VISIBLE,
  CHANGE_IMAGE_CODE_DIALOG_VISIBLE,
  CHANGE_LOGIN_DIALOG_VISIBLE,
  CHANGE_PHONE_NUM,
  CHANGE_REAL_NAME_DIALOG_VISIBLE,
  CHANGE_REGISTER_DIALOG_VISIBLE,
  SAVE_LOGIN_INFO,
  CHANGE_ACTIVE_DIALOG_VISIBLE,
  CHANGE_RESTPASSWORD_DIALOG_VISIBLE
} from "../Constant";
import AuthService from "../../services/auth/AuthService";
import { changeRealNameInfo } from "./User";
import event from "../../utils/event";
// import UserService from "../../services/user/UserService";
import { saveLoginInfoToStorage } from "../../utils/utils";
import DeveloperService from "../../services/developer/DeveloperService";

// 商户管理(点击查询)
export const changeImageCodeDialogVisible = visible => ({
  type: CHANGE_IMAGE_CODE_DIALOG_VISIBLE,
  payload: visible
});
export const changeLoginDialogVisible = visible => ({
  type: CHANGE_LOGIN_DIALOG_VISIBLE,
  payload: visible
});
export const changeRegisterDialogVisible = visible => ({
  type: CHANGE_REGISTER_DIALOG_VISIBLE,
  payload: visible
});

export const changeRestPasswordDialogVisible = visible => ({
  type: CHANGE_RESTPASSWORD_DIALOG_VISIBLE,
  payload: visible
});
// 激活
export const changeActiveDialogVisible = visible => ({
  type: CHANGE_ACTIVE_DIALOG_VISIBLE,
  payload: visible
});
export const changeDeveloperProtocolDialogVisible = visible => ({
  type: CHANGE_DEVELOPER_PROTOCOL_DIALOG_VISIBLE,
  payload: visible
});
export const changeRealNameDialogVisible = visible => ({
  type: CHANGE_REAL_NAME_DIALOG_VISIBLE,
  payload: visible
});
export const saveLoginInfo = loginInfo => ({
  type: SAVE_LOGIN_INFO,
  payload: loginInfo
});
export const changePhoneNum = phoneNum => ({
  type: CHANGE_PHONE_NUM,
  payload: phoneNum
});
// 统一存储用户登录信息
export const setUserinfo = (info = {}, options = {}) => {
  const { saveSession = true, newDispatch = null } = options;
  const { showDeveloperProtocol = false } = info;
  changeDeveloperProtocolDialogVisible(showDeveloperProtocol);
  if (saveSession) {
    saveLoginInfoToStorage(info);
  }
  if (newDispatch) {
    newDispatch(saveLoginInfo(info));
    // newDispatch(changeDeveloperProtocolDialogVisible(showDeveloperProtocol));
  } else {
    return dispatch => {
      dispatch(saveLoginInfo(info));
      // dispatch(changeDeveloperProtocolDialogVisible(showDeveloperProtocol));
    };
  }
};

export function logout(dispatch) {
  // dispatch(changeRealNameInfo({ isRealName: false }));
  // dispatch(changeDeveloperProtocolDialogVisible(false));
  setUserinfo({}, { saveSession: false, newDispatch: dispatch });
  const removeArr = ["createTime", "contact", "company", "appKey", "secretKey", "email", "developerId", "isLogin"];
  removeArr.map(item => {
    sessionStorage.removeItem(item);
  });
}

event.on("logout", dispatch => {
  logout(dispatch);
});
export const setLogout = cb => {
  return dispatch => {
    // AuthService.loginOut({ isLogin: false }).then(res => {
    //   if (res.code !== "000") return false;
    //   logout(dispatch);
    //   if (cb) cb();
    // });
    logout(dispatch);
    if (cb) cb();
  };
};

export const getUserinfoByToken = () => {
  return () => {
    return true;
  };
};

export const protocolConfirm = cb => {
  return dispatch => {
    DeveloperService.confirmProtocol().then(res => {
      const { code, result } = res;
      if (code === "000") {
        dispatch(changeDeveloperProtocolDialogVisible(false));
        sessionStorage.setItem("showProtocol", `${!result}`);
        if (cb) cb(res);
      } else {
        message.error("发生错误，请稍后重试");
      }
    });
  };
};

export const isCookitTimeoutCheck = cb => {
  return dispatch => {
    // 获取所有 Cookie
    const cookies = document.cookie;
    console.log(cookies);

    // 解析 Cookie 字符串，获取特定的 Cookie 值
    function getCookie(name) {
      const value = `; ${document.cookie}`;
      const parts = value.split(`; ${name}=`);
      if (parts.length === 2)
        return parts
          .pop()
          .split(";")
          .shift();
    }

    // 获取特定的 Cookie 值
    const myCookie = getCookie("resto_developer_token");
    console.log(myCookie);
  };
};
