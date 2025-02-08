import React, { useCallback, useEffect, useState } from "react";
import QuestionSearchItem from "./QuestionSearchItem";
import ResourceService from "../../../services/resource/ResourceService";
import "../css/QuestionSearchList.less";

const QuestionSearchList = props => {
  const { keywords } = props;
  const [params] = useState({
    pageNum: 1,
    pageSize: 10
  });
  const [items, updateItems] = useState([]);
  // const [pagination, updatePagination] = useState({});

  const getItems = useCallback(() => {
    if (!keywords) return false;
    ResourceService.search({ ...params, keywords }).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      const { list } = result;
      updateItems(list);
      // updatePagination(page);
    });
  }, [keywords, params]);

  useEffect(() => {
    getItems();
  }, [getItems]);

  return (
    <div className="question-search-list">
      {items.map((item, index) => {
        return <QuestionSearchItem key={index} {...item} />;
      })}
    </div>
  );
};

export default React.memo(QuestionSearchList);
