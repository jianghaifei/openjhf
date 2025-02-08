import React from "react";
import { Link } from "react-router-dom";
import Config from "../../../Config";

const QuestionTabItem = props => {
  const { item = {}, active } = props;
  const { id, path, menuName } = item;
  return (
    <Link className="question-tab-item" to={`/question/flat?id=${id}`}>
      <div className="icon-container">{path ? <img className="icon" src={Config.app.res + path} alt={menuName} /> : null}</div>
      <span className="text">{menuName}</span>
      {active ? <div className="line" /> : null}
    </Link>
  );
};
export default React.memo(QuestionTabItem);
