import React from "react";
import { Form } from "antd";
import "../css/DeveloperFormItem.less";

const DeveloperFormItem = props => {
  const { label, children, type = "formItem", initialValue, formName, rules = [] } = props;

  return (
    <div className="developer-form-item">
      <div className="label">{label ? `${label}:` : null}</div>
      {type === "formItem" ? (
        <Form.Item name={formName} rules={rules} initialValue={initialValue}>
          {children}
        </Form.Item>
      ) : (
        <div style={{ width: "450px" }}>{children}</div>
      )}
    </div>
  );
};
export default React.memo(DeveloperFormItem);
