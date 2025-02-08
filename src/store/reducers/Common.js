import {
  CHANGE_DEVELOPER_PROTOCOL_DIALOG_VISIBLE,
  CHANGE_IMAGE_CODE_DIALOG_VISIBLE,
  CHANGE_LOGIN_DIALOG_VISIBLE,
  CHANGE_REAL_NAME_DIALOG_VISIBLE,
  CHANGE_REGISTER_DIALOG_VISIBLE,
  CHANGE_PHONE_NUM,
  SAVE_LOGIN_INFO,
  CHANGE_ACTIVE_DIALOG_VISIBLE,
  CHANGE_RESTPASSWORD_DIALOG_VISIBLE
} from "../Constant";

const defaultState = {
  imageCodeDialogVisible: false,
  loginDialogVisible: false,
  registerDialogVisible: false,
  activeDialogVisible: 0,
  developerProtocolDialogVisible: false,
  realNameDialogVisible: false,
  restPasswordDialogVisible: false,
  isLogin: sessionStorage.getItem("isLogin"),
  createTime: sessionStorage.getItem("createTime"),
  contact: sessionStorage.getItem("contact"),
  company: sessionStorage.getItem("company"),
  appKey: sessionStorage.getItem("appKey"),
  secretKey: sessionStorage.getItem("secretKey"),
  email: sessionStorage.getItem("email"),
  developerId: sessionStorage.getItem("developerId")
};
export default (state = defaultState, action) => {
  const { type, payload } = action;
  switch (type) {
    case CHANGE_RESTPASSWORD_DIALOG_VISIBLE:
      return {
        ...state,
        restPasswordDialogVisible: payload
      };
    case CHANGE_ACTIVE_DIALOG_VISIBLE:
      return {
        ...state,
        activeDialogVisible: payload
      };
    case CHANGE_IMAGE_CODE_DIALOG_VISIBLE:
      return {
        ...state,
        imageCodeDialogVisible: payload
      };
    case CHANGE_LOGIN_DIALOG_VISIBLE:
      return {
        ...state,
        loginDialogVisible: payload
      };
    case CHANGE_REGISTER_DIALOG_VISIBLE:
      return {
        ...state,
        registerDialogVisible: payload
      };
    case CHANGE_DEVELOPER_PROTOCOL_DIALOG_VISIBLE:
      return {
        ...state,
        developerProtocolDialogVisible: payload
      };
    case CHANGE_REAL_NAME_DIALOG_VISIBLE:
      return {
        ...state,
        realNameDialogVisible: payload
      };
    case SAVE_LOGIN_INFO:
      return {
        ...state,
        isLogin: payload.isLogin,
        createTime: payload.createTime,
        contact: payload.contact,
        company: payload.company,
        appKey: payload.appKey,
        secretKey: payload.secretKey,
        email: payload.email,
        developerId: payload.developerId
      };
    case CHANGE_PHONE_NUM:
      return {
        ...state,
        phone: payload
      };
    default:
      return state;
  }
};
