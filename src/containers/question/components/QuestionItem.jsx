import React from "react";
import { Link } from "react-router-dom";
import { timeFormat } from "../../../utils/utils";
import "../css/QuestionItem.less";

const QuestionItem = props => {
  const { id, contentTitle, modifyTime, naviId } = props;
  return (
    <Link className="question-item" to={`/question/detail/${id}?m=${naviId}`}>
      <div className="title">{contentTitle}</div>
      <div className="time">{modifyTime ? timeFormat(modifyTime) : null}</div>
    </Link>
  );
};

export default React.memo(QuestionItem);
