import React, { useEffect, useRef, useState } from "react";
import { useInView } from "react-intersection-observer";
import PartnerItem from "./HomePartnerItem";
import "../css/HomePartnerRow.less";

const HomePartnerRow = props => {
  const { items, index: rowIndex } = props;
  const [rowElement, inView] = useInView();
  const [isFirstLoad, updateIsFirstLoad] = useState(false);
  const containerElement = useRef();
  const speed = rowIndex % 2 ? 20 : 12;
  // const speed = 20;
  const step = 1;
  // const step = rowIndex % 2 ? 1 : 2;

  const timerRef = useRef();
  const clearTimer = () => {
    clearInterval(timerRef.current);
  };

  useEffect(() => {
    return () => {
      clearTimer();
    };
  }, []);

  useEffect(() => {
    if (isFirstLoad) {
      // 随机设置一个滚动数值
      const createTimer = () => {
        if (timerRef.current) {
          clearTimer();
        }
        const { current } = containerElement;
        current.scrollLeft = current.scrollWidth;
        timerRef.current = setInterval(() => {
          if (current.scrollLeft === 0) {
            current.scrollLeft = current.scrollWidth;
          }
          current.scrollLeft -= step;
        }, speed);
      };
      createTimer();
    }
    if (inView && !isFirstLoad) updateIsFirstLoad(true);
  }, [speed, inView, isFirstLoad]);

  return (
    <div className="partner-row" ref={rowElement}>
      <div className="row-container" ref={containerElement}>
        {items.map((item, index) => {
          return <PartnerItem key={index} urlKey={item} />;
        })}
      </div>
    </div>
  );
};

export default React.memo(HomePartnerRow);
