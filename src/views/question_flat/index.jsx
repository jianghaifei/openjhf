import React, { useCallback, useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import { Spin } from "antd";
import QuestionBanner from "../../containers/question_flat/QuestionBanner";
import QuestionContent from "../../containers/question_flat/QuestionContent";
import QuestionSearchList from "../../containers/question_flat/components/QuestionSearchList";
import { filterUrlQuery } from "../../utils/utils";
import QuestionTab from "../../containers/question_flat/components/QuestionTab";
import ResourceMenuService from "../../services/resource/ResourceMenuService";
import "./index.less";

const QuestionFlat = () => {
  const location = useLocation();
  const [activeId, updateActiveId] = useState(null);
  const [categoryItems, updateCategoryItems] = useState([]);
  const [keywords] = useState(null);
  const [loading, updateLoading] = useState(false);

  const setActiveTab = useCallback(() => {
    const { id } = filterUrlQuery({ location });
    updateActiveId(Number(id));
  }, [location]);

  useEffect(() => {
    setActiveTab();
  }, [setActiveTab]);

  const getItems = useCallback(() => {
    updateLoading(true);
    ResourceMenuService.index(3)
      .then(res => {
        const { code, result } = res;
        if (code !== "000") return false;
        updateCategoryItems(result);
        updateActiveId(result[0]?.id);
      })
      .finally(() => {
        updateLoading(false);
      });
  }, []);

  useEffect(() => {
    getItems();
  }, [getItems]);

  // const handleOnSearch = searchValue => {
  //   updateKeywords(searchValue);
  // };
  return (
    <div className="question-flat">
      <QuestionBanner />
      <div className="question-container">
        <Spin spinning={loading}>
          <QuestionTab items={categoryItems} id={activeId} />
          {keywords ? <QuestionSearchList keywords={keywords} /> : <QuestionContent tabId={activeId} />}
        </Spin>
      </div>
    </div>
  );
};

export default React.memo(QuestionFlat);
