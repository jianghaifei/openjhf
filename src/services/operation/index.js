import Api from "../Api";

export function queryTree(data) {
  return Api.post("/bomenu/cms/api/tree/doc", data);
}

export function nodeSave(data) {
  return Api.post("/bomenu/cms/api/tree/node/save", data);
}

export function nodeSort(data) {
  return Api.post("/bomenu/cms/api/tree/node/sort", data);
}

export function apiSave(data) {
  return Api.post("/bomenu/cms/api/tree/node/api/saveHtml", data);
}

export function apiDelete(data) {
  return Api.post("/bomenu/cms/api/tree/node/api/link", data);
}

export function apiSort(data) {
  return Api.post("/bomenu/cms/api/tree/node/api/sort", data);
}

export function apiQuery(data) {
  return Api.post("/bomenu/cms/api/query", data);
}

export function apiList(data) {
  return Api.post("/bomenu/cms/api/list", data);
}

export function apiUpload(data) {
  return Api.post("/boshop/resource/management/file/upload", data);
}

