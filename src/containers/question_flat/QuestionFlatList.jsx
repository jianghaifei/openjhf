import React from "react";
import QuestionItem from "../question/components/QuestionItem";
import CommonContent from "../../components/layout/CommonContent";
import NoData from "../../components/general/NoData";

const QuestionFlatList = props => {
  const { items } = props;

  return (
    <CommonContent extraHeight={20} style={{ overflowY: "auto" }}>
      {items.length ? (
        items.map((item, index) => {
          return <QuestionItem {...item} key={index} />;
        })
      ) : (
        <NoData />
      )}
    </CommonContent>
  );
};

export default React.memo(QuestionFlatList);
