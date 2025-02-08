import React from "react";
import { useInView } from "react-intersection-observer";
import CommonTitleBar from "../mobile-components/CommonTitleBar";
import MobileDataItem from "./data/MobileDataItem";
import "./css/MobileData.less";

const MobileData = () => {
  const title = "赋能餐饮企业";
  const items = [
    {
      count: 600,
      unit: "w+",
      text: "日接口调用量"
    },
    {
      count: 500,
      unit: "+",
      text: "开放API接口数"
    },
    {
      count: 2500,
      unit: "+",
      text: "活跃商户数量"
    },
    {
      count: 1000,
      unit: "+",
      text: "活跃开发者数量"
    }
  ];
  const [containerRef, inView] = useInView();

  return (
    <div className="mobile-data" ref={containerRef}>
      <CommonTitleBar title={title} />
      {items.map((item, index) => {
        return <MobileDataItem key={index} {...item} inView={inView} />;
      })}
    </div>
  );
};

export default React.memo(MobileData);
