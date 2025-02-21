/* eslint-disable @typescript-eslint/restrict-template-expressions */
/* eslint-disable @typescript-eslint/no-floating-promises */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
//Input
import { Image, message, Upload, Button } from "antd";
import { ISchemaEditProps } from "../../../Model/ISchemaEditProps.ts";
import { useEffect, useState } from "react";
import { UploadOutlined } from "@ant-design/icons";
import { RcFile } from "antd/lib/upload";

const ImageUpload = (props: ISchemaEditProps) => {
  const [value, setValue] = useState(props.value || "");
  const { schema } = props;
  const config = schema.setter.config;

  const beforeUpload = (file: RcFile) => {
    const isJpgOrPng = file.type === "image/jpeg" || file.type === "image/png";
    if (!isJpgOrPng) {
      message.error("只能上传JPG/PNG格式文件!");
    }
    const maxSize = config?.size || 10;
    const isLt2M = file.size / 1024 / 1024 < maxSize;
    if (!isLt2M) {
      message.error(`图片大于 ${maxSize}MB，请重新选择！`);
    }
    return isJpgOrPng && isLt2M;
  };
  const uploadProps = {
    name: "file",
    action: "/biApis/upload/uploadFile",
    showUploadList: false,
    accept: ".png,.PNG,.JPG,.jpg,.JPEG,.jpeg",
    beforeUpload: beforeUpload,
    onChange(info: any) {
      if (info.file.status === "done") {
        if (info.file.xhr.responseText) {
          const response = JSON.parse(info.file.xhr.responseText);
          if (response.code == "000" && response.data?.url) {
            setValue(response.data.url);
            props.onChange?.(response.data.url);
            return;
          }
          void message.error(
            response.data?.message || "上传失败，请检查大小和格式或者网络。"
          );
          return;
        }
      } else if (info.file.status === "error") {
        void message.error("上传失败，请检查大小和格式或者网络。");
      }
    },
  };

  useEffect(() => {
    setValue(props.value || "");
  }, [props.value]);

  return (
    <div>
      <Upload {...uploadProps}>
        {value ? (
          <Image
            src={value}
            width={config?.width || 100}
            preview={false}
          ></Image>
        ) : (
          <Button icon={<UploadOutlined />}>点击上传</Button>
        )}
      </Upload>
    </div>
  );
};
export default ImageUpload;
