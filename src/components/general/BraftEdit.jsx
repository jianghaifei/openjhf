import React, { useEffect } from "react";
import { Markup } from "interweave";
import CommonBackTop from "./CommonBackTop";
// import "braft-editor/dist/output.css";
import "./css/BraftEdit.less";

const BraftEdit = props => {
  const { content } = props;

  useEffect(() => {
    document.getElementById("braftEdit").scrollTo(0, 0);
  }, [content]);

  return (
    <div className="braft-edit" id="braftEdit">
      <CommonBackTop target={() => document.getElementById("braftEdit")} />
      <Markup className="common-mark-up braft-output-content" content={content} />
    </div>
  );
};

export default React.memo(BraftEdit);
