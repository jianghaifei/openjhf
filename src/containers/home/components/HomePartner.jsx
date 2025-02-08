import React, { useEffect, useState } from "react";
import HomePartnerRow from "./HomePartnerRow";
// import HomePartnerMask from "./HomePartnerMask";
import "../css/HomePartner.less";

const HomePartner = props => {
  const { scrollPosition } = props;
  const maxLength = 12; // 商家最大数108
  const singleRowLength = 6; // 每行最大数 18
  const [items, updateItems] = useState([]); // 默认展示的数组

  useEffect(() => {
    const setItems = () => {
      const maxRow = Math.ceil(maxLength / singleRowLength);
      const arr = [];
      for (let i = 0; i < maxRow; i++) {
        let arrTemp = [];
        for (let j = 0; j < singleRowLength; j++) {
          arrTemp.push(j + i * singleRowLength);
        }
        const arrTemp1 = [];
        // 可视区域有8个 实现滚动条无限滚动需要复制8个追加到数组中
        for (let j = singleRowLength - 8; j < singleRowLength; j++) {
          arrTemp1.push(j + i * singleRowLength);
        }
        arrTemp = arrTemp1.concat(arrTemp);
        arr.push(arrTemp);
      }
      updateItems(arr);
    };
    setItems();
  }, []);

  return (
    <div className="home-partner">
      <div
        className="title"
        style={{
          marginBottom: "80px"
        }}
      >
        合作商户
      </div>
      <div className="partner-container">
        {items.map((item, index) => {
          return <HomePartnerRow scrollPosition={scrollPosition} items={item} index={index} key={index} />;
        })}
        {/* <HomePartnerMask /> */}
      </div>
    </div>
  );
};

export default React.memo(HomePartner);
