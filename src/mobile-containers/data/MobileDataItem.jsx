import React, { useEffect, useState } from "react";
import "../css/MobileDataItem.less";
import DataController from "../../controllers/DataController";

const MobileDataItem = props => {
  const { text, count, unit, inView } = props;
  const [isFirstLoad, updateIsFirstLoad] = useState(false);
  const [newCount, updateNewCount] = useState(0);
  const dataController = new DataController({ count });

  useEffect(() => {
    if (inView && !isFirstLoad) updateIsFirstLoad(true);
  }, [inView, isFirstLoad]);

  useEffect(() => {
    if (isFirstLoad) {
      dataController.createTimer(res => {
        updateNewCount(res);
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isFirstLoad, count]);

  return (
    <div className="mobile-data-item">
      <div className="left">{text}</div>
      <div className="right">
        <span className="count">{newCount}</span>
        <span className="unit">{unit}</span>
      </div>
    </div>
  );
};

export default React.memo(MobileDataItem);
