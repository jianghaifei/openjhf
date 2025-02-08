import React, { useMemo } from "react";
import { parseJson } from "../../../utils/utils";
import SpecialResource from "./DocumentSpecial";
import NoData from "../../../components/general/NoData";
import TinymceEditor from "../../../components/general/TinymceEditor";
import BraftEdit from "../../../components/general/BraftEdit";
import ResourceController from "../../../controllers/ResourceController";
import "../css/DocumentDetail.less";

const DocumentDetail = props => {
  const { content, contentTitle, type } = props;

  const renderStringTitle = useMemo(() => ResourceController.renderStringTitle(contentTitle), [contentTitle]);
  const renderElementTitle = useMemo(() => ResourceController.renderElementTitle(contentTitle), [contentTitle]);
  const renderContent = useMemo(() => renderStringTitle + content, [content, renderStringTitle]);

  return (
    <div className="document-detail">
      {type === 2 && typeof parseJson(content) === "object" ? (
        <SpecialResource {...parseJson(content)} />
      ) : content ? (
        type === 3 ? (
          <TinymceEditor content={renderContent} />
        ) : (
          <BraftEdit content={renderContent} />
        )
      ) : contentTitle ? (
        <>
          {renderElementTitle}
          <NoData />
        </>
      ) : (
        <NoData />
      )}
    </div>
  );
};
export default React.memo(DocumentDetail);
