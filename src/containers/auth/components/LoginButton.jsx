import React from "react";
import { Button } from "antd";
import "../css/LoginButton.less";

const LoginButton = props => {
  const { isLoading, className, htmlType, children, onClick } = props;
  return (
    <Button
      className={`login-button ${className}`}
      htmlType={htmlType}
      loading={isLoading}
      disabled={isLoading}
      onClick={onClick}
      block
    >
      {children}
    </Button>
  );
};

export default React.memo(LoginButton);
