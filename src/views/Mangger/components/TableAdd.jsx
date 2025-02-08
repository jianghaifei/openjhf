import { Tree, Input, Modal, Button, Form, message } from "antd";
import React, { forwardRef, useState, useImperativeHandle } from "react";
import Tinymce from "./RichText/Tinymce";
import { apiSave, apiQuery, apiSort } from "../../../services/operation/index";

const AddModel = forwardRef((props, ref) => {
  const [form] = Form.useForm();
  const [info, setInfo] = useState({});
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  // 用于存储编辑器内容
  const [content, setContent] = useState("");
  useImperativeHandle(ref, () => ({
    open(params = {}) {
      form.resetFields();
      setInfo(params);
      setOpen(true);
      if (params.type == "edit") {
        queryAppiFn(params);
      }
    },
    destroy() {
      setOpen(false);
    }
  }));

  const getHtml = data => {
    let apiDocParams = {};

    if (data.apiDocType == "HTML") {
      return data.apiDocHtml;
    } else {
      if (data.apiDocParams) {
        apiDocParams = JSON.parse(data.apiDocParams);
      }
    }

    console.log("aaaa", apiDocParams);
    let html = `<p><span class="post">POST</span><span>${data.requestUri}</span></p>`;
    if (apiDocParams.requestParamsDoc) {
      html += `<h2>Request</h2>`;
      apiDocParams.requestParamsDoc.forEach(a => {
        html += `<h3>${a.name}</h3>`;
        a.notes.forEach(b => {
          html += `<p>${b}</p>`;
        });

        html += `<table class="mtable" border="0">
      <tbody>
        <tr>
          <th style="width: 10%;" class="center">#</th>
          <th style="width: 19.7015%;">Name</th>
          <th style="width: 19.7015%;">Type</th>
          <th style="width: 19.7015%;">Required</th>
          <th style="width: 29.7044%;">Description</th>
        </tr>`;
        a.fields.forEach((c, index) => {
          html += `<tr>
          <td style="width: 10%;" class="center">${index + 1}</td>
          <td style="width: 19.7015%;">${c.name}</td>
          <td style="width: 19.7015%;">${c.type}</td>
          <td style="width: 19.7015%;">${c.required}</td>
          <td style="width: 29.7044%;">`;
          if (c.notes) {
            c.notes.forEach(d => {
              html += `<p>${d}</p>`;
            });
          }
          html += `</td></tr>`;
        });
        html += `</tbody>
     </table>`;
      });
    }
    if (apiDocParams.responseParamsDoc) {
      html += `<h2>Response</h2>`;
      apiDocParams.responseParamsDoc.forEach(a => {
        html += `<h3>${a.name}</h3>`;
        a.notes.forEach(b => {
          html += `<p>${b}</p>`;
        });

        html += `<table class="mtable" border="0">
      <tbody>
        <tr>
          <th style="width: 10.7015%;" class="center">#</th>
          <th style="width: 19.7015%;">Name</th>
          <th style="width: 19.7015%;">Type</th>
          <th style="width: 19.7015%;">Required</th>
          <th style="width: 29.7044%;">Description</th>
        </tr>`;
        a.fields.forEach((c, index) => {
          html += `<tr>
          <td style="width: 10.7015%;" class="center">${index + 1}</td>
          <td style="width: 19.7015%;">${c.name}</td>
          <td style="width: 19.7015%;">${c.type}</td>
          <td style="width: 19.7015%;">${c.required}</td>
          <td style="width: 29.7044%;">`;
          if (c.notes) {
            c.notes.forEach(d => {
              html += `<p>${d}</p>`;
            });
          }
          html += `</td></tr>`;
        });
        html += `</tbody>
     </table>`;
      });
    }
    console.log("bbbb", html);
    return html;
  };

  const queryAppiFn = data => {
    apiQuery({ apiUid: data.apiUid }).then(res => {
      if (res.code !== "000") {
        return message.warning(res.msg);
      }
      const resData = {
        apiName: data.record.apiName,
        htmlContent: getHtml(res.data)
      };

      form.setFieldsValue(resData);
      setContent(resData.htmlContent || "");
    });
  };

  const handleCancel = () => {
    setOpen(false);
  };

  const submitFn = async () => {
    await form.validateFields();
    const value = form.getFieldsValue();
    const params = {
      ...value,
      nodeUid: info.nodeUid,
      apiUid: info.type === "edit" ? info.apiUid : ""
    };
    setLoading(true);
    apiSave(params).then(res => {
      setLoading(false);
      if (res.code !== "000") {
        return message.warning(res.msg);
      }
      setOpen(false);
      props.onChange && props.onChange();
      message.success(res.msg);
    });
  };

  return (
    <Modal
      title={info.title}
      open={open}
      onCancel={handleCancel}
      width={"90%"}
      footer={[
        <Button key="cancel" onClick={handleCancel}>
          取消
        </Button>,
        <Button key="submit" type="primary" onClick={submitFn} loading={loading}>
          确认
        </Button>
      ]}
    >
      <Form form={form} name="basic" labelCol={{ span: 2 }} wrapperCol={{ span: 23 }} autoComplete="off">
        <Form.Item label="文档标题" name="apiName" rules={[{ required: true, message: "请输入文档标题!" }]}>
          <Input />
        </Form.Item>
        <Form.Item label="文档html" name="htmlContent" rules={[{ required: true, message: "请输入htmlContent!" }]}>
          <Tinymce />
        </Form.Item>
      </Form>
    </Modal>
  );
});

export default AddModel;
