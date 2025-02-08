/**
 * @description 解析接口返回的时间
 * */

export function timeFormat(time) {
  if (!time) return "";
  const tempTime = String(time);
  const year = tempTime.substring(0, 4);
  const mouth = tempTime.substring(4, 6);
  const day = tempTime.substring(6, 8);
  const hour = tempTime.substring(8, 10);
  const minutes = tempTime.substring(10, 12);
  const second = tempTime.substring(12, 14);
  return `${year}-${mouth}-${day} ${hour}:${minutes}:${second}`;
}

/**
 * @description 转换集团详情的状态
 * */
export function checkStatusFormat(checkStatus) {
  switch (checkStatus) {
    case 1:
      return "待审核";
    case 2:
      return "审核不通过";
    case 3:
      return "审核通过";
    default:
      return "状态异常";
  }
}

/**
 * @description 存储登录数据到本地
 * */
export function saveLoginInfoToStorage({ createTime, contact, company, appKey, secretKey, email, developerId }) {
  sessionStorage.setItem("isLogin", "true");
  sessionStorage.setItem("createTime", createTime);
  sessionStorage.setItem("contact", contact);
  sessionStorage.setItem("company", company);
  sessionStorage.setItem("appKey", appKey);
  sessionStorage.setItem("secretKey", secretKey);
  sessionStorage.setItem("email", email);
  sessionStorage.setItem("developerId", developerId);
}

// 60秒倒计时
export function getCountdown() {
  return Date.now() + 1000 * 60;
}

// 字符串格式化为json
export function jsonFormat(format) {
  let msg = "";
  let pos = 0;
  let prevChar = "";
  let outOfQuotes = true;
  for (let i = 0; i < format.length; i++) {
    // 循环每一个字符
    const char = format.substring(i, i + 1); // 获取到该字符
    if (char === '"' && prevChar !== "\\") {
      // 如果转移
      outOfQuotes = !outOfQuotes;
    } else if ((char === "}" || char === "]") && outOfQuotes) {
      // 如果是关闭
      msg += "<br/>";
      pos -= 1;
      for (let j = 0; j < pos; j++) msg += "    ";
    }
    msg += char;
    if ((char === "," || char === "{" || char === "[") && outOfQuotes) {
      msg += "<br/>";
      if (char === "{" || char === "[") pos += 1;
      for (let k = 0; k < pos; k++) msg += "    ";
    }
    prevChar = char;
  }
  return msg;
}

export function deepJson(data) {
  try {
    return JSON.parse(JSON.stringify(data));
  } catch (error) {
    return data;
  }
}

export function parseJson(data) {
  try {
    if (typeof data === "string") {
      // eslint-disable-next-line no-new-func
      return new Function(`return ${data}`)();
    }
    return data;
  } catch (error) {
    return data;
  }
}

export function sliceMenuId(menuId) {
  const index = menuId.indexOf("/");
  return menuId.slice(0, index);
}

/** *
 * @description 筛选query传参的值
 * @param props
 * @return queryObject
 */

export function filterUrlQuery({ location = {} }) {
  const { search } = location;
  const queryArr = search ? search.split("?")[1].split("&") : [];
  const queryObject = {};
  queryArr.map(item => {
    const tempItem = item.split("=");
    // eslint-disable-next-line prefer-destructuring
    queryObject[tempItem[0]] = tempItem[1];
  });
  return queryObject;
}

/** *
 * @description 筛选params传参的值
 * @param props
 */

export function filterUrlParams({ match = {} }) {
  if ("params" in match) {
    return match.params;
  }
  return {};
}

/** *
 * @description 校验手机号规则 目前支持大陆 + 港澳台
 * 大陆：区号86 开头1 3-9号段，后边跟9位数字
 * 香港	区号852	9或6开头后面跟7位数字	^([6|9])\d{7}$
 * 澳门	区号853	66或68开头后面跟5位数字	^[6]([8|6])\d{5}$
 * 台湾	区号886	09开头后面跟8位数字	^[0][9]\d{8}$
 * 美国	区号1
 * 英国	区号44
 * 法国	区号33
 * 澳大利亚	区号61
 * 俄罗斯	区号7
 */

export function getVerifyTelephoneRule(operation = "86") {
  switch (operation) {
    case "852":
      return /^([6|9])\d{7}$/;
    case "853":
      return /^[6]([8|6])\d{5}$/;
    case "886":
      return /^[0][9]\d{8}$/;
    case "86":
      return /^[1][3-9]\d{9}$/;
    default:
      return "";
  }
}
/** *
 * @description 校验手机号
 * @param telephone
 * @param operation 默认中国大陆
 * @return boolean
 */

export function verifyTelephone(telephone, operation = "86") {
  const reg = getVerifyTelephoneRule(operation);
  if (!reg) return true;
  return getVerifyTelephoneRule(operation).test(telephone);
}

export function verifyEmail(emali) {
  const reg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
  return reg.test(emali);
}

export function removeUrlParams(url, key) {
  const baseUrl = `${url.split("?")[0]}?`;
  const query = url.split("?")[1];
  if (query.indexOf(key) > -1) {
    const obj = {};
    const arr = query.split("&");
    for (let i = 0; i < arr.length; i++) {
      arr[i] = arr[i].split("=");
      // eslint-disable-next-line prefer-destructuring
      obj[arr[i][0]] = arr[i][1];
    }
    delete obj[key];
    return (
      baseUrl +
      JSON.stringify(obj)
        .replace(/["{}]/g, "")
        .replace(/:/g, "=")
        .replace(/,/g, "&")
    );
  }
  return url;
}

/**
 * @description 使用reduce去重一维数组的重复项
 * @param data:Array<any>
 * @return any[]
 * */
export function removeDuplicates(data) {
  return data.reduce((arr, next) => {
    return arr.includes(next) ? arr : arr.concat(next);
  }, []);
}

/**
 * @description 获取页面剩余高度
 * body高度 - (当前元素到顶端的距离) - extra
 * */
export function getResidualHeight({ ref, dom, extraHeight = 0 }) {
  const bodyHeight = document.body.clientHeight;
  let top = 0;
  if (ref && ref.current) {
    top = ref.current.getBoundingClientRect().top;
  }
  if (dom) {
    top = dom.getBoundingClientRect().top;
  }
  return bodyHeight - top - extraHeight;
}

// todo 给item增加index
export function arrAddIndex(arr = []) {
  return arr.map((item, index) => {
    return { ...item, index: index + 1 };
  });
}
