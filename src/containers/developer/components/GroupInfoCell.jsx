import React from "react";
import { Col, Row } from "antd";

const GroupInfoCell = props => {
  const { groupName, groupId } = props;
  return (
    <>
      <h3 className="mb-20">集团信息</h3>
      <Row className="mb-40">
        <Col span={8}>
          集团名称:
          {groupName}
        </Col>
        <Col span={8}>
          集团ID:
          {groupId}
        </Col>
      </Row>
    </>
  );
};
export default React.memo(GroupInfoCell);
