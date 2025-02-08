import Api from "../Api";

// 注册
export function registryApply(data) {
  return Api.post("/bomenu/developer/registry/apply", data);
}

// 激活
export function registryActive(data) {
  return Api.post("/bomenu/developer/registry/active", data);
}

// 激活初始化密码
export function passwordInit(data) {
  return Api.post("/bomenu/developer/password/init", data);
}

// 获取邮箱验证码
export function getVerificationCode(data) {
  return Api.post("/bomenu/developer/password/reset/get_verification_code", data);
}

// 设置密码
export function setNewPassword(data) {
  return Api.post("/bomenu/developer/password/reset/set_new_password", data);
}

// 校验登录邮箱
export function loginCheckUser(data) {
  return Api.post("/bomenu/developer/login/check_user", data);
}

// 登录
export function loginPasswordfn(data) {
  return Api.post("/bomenu/developer/login/check_password", data);
}

// 获取用户信息
export function infoDetail(data) {
  return Api.get("/bomenu/developer/info/detail", data);
}

// 获取用户信息
export function activeSendmail(data) {
  return Api.get("/bomenu/developer/registry/active/send_mail", data);
}

// 更新用户信息
export function infoUpdate(data) {
  return Api.post("/bomenu/developer/info/update", data);
}

// 获取授权列表
export function authCorpList(data) {
  return Api.get("/bomenu/developer/auth/corp/list", data);
}

// 授权申请
export function authCorpApply(data) {
  return Api.post("/bomenu/developer/auth/corp/apply", data);
}

