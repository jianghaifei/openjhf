import React from "react";
import { Link } from "react-router-dom";
import "../css/QuestionSearchItem.less";

const QuestionSearchItem = props => {
  const { contentTitle = "", content = "", id, naviId } = props;
  return (
    <Link className="question-search-item" to={`/question/detail/${id}?m=${naviId}`}>
      <div className="title">{contentTitle}</div>
      <div className="desc">{content}</div>
    </Link>
  );
};

export default React.memo(QuestionSearchItem);
