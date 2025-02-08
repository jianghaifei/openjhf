import React from "react";
import DownloadItem from "./components/DownloadItem";
import DownloadTips from "./components/DownloadTips";
import DeveloperTitle from "./components/DeveloperTitle";
import "./css/DownloadSDK.less";

const DeveloperDownLoadSDK = () => {
  return (
    <div className="developer-download-sdk">
      <DeveloperTitle title="SDK下载" />
      <DownloadItem title="Java SDK" link="https://github.com/Hualala-OpenAPI/OpenAPI-SDK" />
      <DownloadItem title="Java SDK业务场景演示" link="https://github.com/Hualala-OpenAPI/OpenAPI-SDK-Sample" />
      <DownloadItem title="Python SDK" link="https://github.com/Hualala-OpenAPI/OpenAPI-SDK-python" />
      <DownloadItem title="PHP SDK" link="https://github.com/Hualala-OpenAPI/OpenAPI-SDK/blob/master/doc/HuaLaLa.php" />
      <DownloadItem title="C#签名参考" link="https://github.com/Hualala-OpenAPI/OpenAPI-SDK/blob/master/doc/C%23%E7%AD%BE%E5%90%8D.md" />
      <DownloadTips />
    </div>
  );
};
export default React.memo(DeveloperDownLoadSDK);
