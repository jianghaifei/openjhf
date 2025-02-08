import React from "react";
// import { SearchOutlined } from "@ant-design/icons";
// import { Button, Form, Input } from "antd";
import imgUrl from "./images/banner.jpg";
import "./css/QuestionBanner.less";

const QuestionBanner = () => {
  // const { onSearch } = props;
  // const [form] = Form.useForm();

  // useEffect(() => {
  //   form.setFieldsValue({ keywords: defaultValue });
  // }, [form, defaultValue]);

  // const handleSearchClick = ({ keywords }) => {
  //   onSearch(keywords);
  // };

  return (
    <div className="question-banner">
      <img className="bg-img" src={imgUrl} alt="question-banner" />
      <div className="question-banner-container">
        <div className="title">常见问题</div>
        <div className="subtitle">快速搞定任何常见问题</div>
        {/* <Form form={form} onFinish={handleSearchClick}> */}
        {/*  <Form.Item name="keywords"> */}
        {/*    <Input */}
        {/*      prefix={<SearchOutlined />} */}
        {/*      placeholder="搜索" */}
        {/*      allowClear */}
        {/*      suffix={ */}
        {/*        <Button type="primary" htmlType="submit"> */}
        {/*          搜索 */}
        {/*        </Button> */}
        {/*      } */}
        {/*    /> */}
        {/*  </Form.Item> */}
        {/* </Form> */}
      </div>
    </div>
  );
};

export default React.memo(QuestionBanner);
