import React from "react";
import { Button, DatePicker, Form, Input, Select } from "antd";

const { RangePicker } = DatePicker;

const ApplyFilterBar = props => {
  const [form] = Form.useForm();
  const initAuthorityStatus = 4;
  const selectOptions = [{ id: 4, text: "全部" }, { id: 1, text: "待授权" }, { id: 2, text: "授权失败" }, { id: 3, text: "授权成功" }];
  const { loading, onClick } = props;
  const handleBtnClick = values => {
    const { authorityStatus, date, mcUserName } = values;
    let startTime;
    let endTime;
    if (date) {
      // eslint-disable-next-line no-useless-escape
      startTime = date[0]
        .toJSON()
        // eslint-disable-next-line no-useless-escape
        .replace(/\-/g, "")
        .substring(0, 8);
      // eslint-disable-next-line no-useless-escape
      endTime = date[1]
        .toJSON()
        // eslint-disable-next-line no-useless-escape
        .replace(/\-/g, "")
        .substring(0, 8);
    }
    onClick({ authorityStatus, mcUserName, startTime, endTime });
  };
  return (
    <Form form={form} layout="inline" initialValues={{ authorityStatus: initAuthorityStatus }} onFinish={handleBtnClick}>
      <Form.Item name="authorityStatus" label="状态">
        <Select style={{ width: "150px" }} placeholder="请选择状态" disabled={loading}>
          {selectOptions.map(item => (
            <Select.Option key={item.id} value={item.id}>
              {item.text}
            </Select.Option>
          ))}
        </Select>
      </Form.Item>
      <Form.Item name="mcUserName" label="集团名称">
        <Input placeholder="请输入集团名称" allowClear disabled={loading} />
      </Form.Item>
      <Form.Item name="date" label="申请日期">
        <RangePicker disabled={loading} />
      </Form.Item>
      <Button type="primary" htmlType="submit" disabled={loading}>
        查询
      </Button>
    </Form>
  );
};
export default React.memo(ApplyFilterBar);
