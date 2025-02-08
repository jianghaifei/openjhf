import React, { useEffect, useState } from "react";
import { Carousel } from "react-responsive-carousel";
import QuestionTabItem from "./QuestionTabItem";
import "react-responsive-carousel/lib/styles/carousel.min.css";
import "../css/QustionTab.less";

const QuestionTab = props => {
  const { items: originItems, id: activeId } = props;
  const [items, updateItems] = useState([]);

  useEffect(() => {
    if (originItems.length) {
      const step = 6;
      const page = Math.ceil(originItems.length / step);
      const newArr = [];
      for (let i = 0; i < page; i++) {
        newArr.push(originItems.slice(i * step, i * step + step));
      }
      updateItems(newArr);
    }
  }, [originItems]);

  return (
    <div className="question-tab">
      <Carousel axis="horizontal" showStatus={false} showThumbs={false} showArrows showIndicators={false}>
        {items.map((subItems, index) => {
          return (
            <div className="question-row-container" key={index}>
              {subItems.map((item, subIndex) => {
                return <QuestionTabItem active={item.id === activeId} item={item} key={subIndex} />;
              })}
            </div>
          );
        })}
      </Carousel>
    </div>
  );
};

export default React.memo(QuestionTab);
