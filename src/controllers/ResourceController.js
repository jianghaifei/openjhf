import React from "react";

export default class ResourceController {
  // todo 有内容时 和标题一起展示
  static renderStringTitle(title) {
    if (title) {
      return `<p style='font-size:20px;font-weight: bold;color: #333;margin-bottom: 20px;'>${title}</p>`;
    }
    return "";
  }

  // todo 用于没有内容时 只展示标题
  static renderElementTitle(title) {
    if (title) {
      return <p style={{ fontSize: 20, fontWeight: "bold", color: "#333", marginBottom: 20 }}>{title}</p>;
    }
    return "";
  }

  static renderUpdateTime(time) {
    if (time) {
      return <div className="update-time">更新时间:{time}</div>;
    }
    return null;
  }
}
