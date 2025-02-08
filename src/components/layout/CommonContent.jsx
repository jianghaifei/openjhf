import React, { useCallback, useEffect, useRef, useState } from "react";
import { getResidualHeight } from "../../utils/utils";
import "./css/CommonContent.less";

const CommonContent = props => {
  const { children, className, style = {}, extraHeight } = props;
  const contentRef = useRef();
  const timer = useRef();
  const [height, updateHeight] = useState("100%");

  const clearTimer = useCallback(() => {
    if (timer.current) {
      clearTimeout(timer.current);
      timer.current = null;
    }
  }, []);

  const resetHeight = useCallback(() => {
    updateHeight(getResidualHeight({ ref: contentRef, extraHeight }));
  }, [extraHeight]);

  const onresize = useCallback(() => {
    clearTimer();
    timer.current = setTimeout(() => {
      resetHeight();
    }, 100);
  }, [clearTimer, resetHeight]);

  useEffect(() => {
    window.addEventListener("resize", onresize);
    onresize();
    return () => {
      window.removeEventListener("resize", onresize);
      clearTimer();
    };
  }, [clearTimer, onresize]);

  return (
    <div className={`common-content ${className || ""}`} ref={contentRef} style={{ ...style }}>
      {children}
    </div>
  );
};

export default React.memo(CommonContent);
