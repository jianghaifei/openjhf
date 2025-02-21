import { Select } from "@douyinfe/semi-ui";
import { useState } from "react";
import { ISchemaEditProps } from "../../../Model/ISchemaEditProps.ts";
import { SelectProps } from "@douyinfe/semi-ui/lib/es/select/index";

const { Option } = Select;

const fontFamilyList: string[] = [
  "默认",
  "微软雅黑",
  "宋体",
  "黑体",
  "华文细黑",
  "Verdana",
  "Arial",
  "Times",
  "MS Sans Serif",
];

const FontFamily = (props: ISchemaEditProps) => {
  const [value, setValue] = useState<SelectProps["value"]>("默认");

  const onChange = (value: SelectProps["value"]) => {
    setValue(value);
    props.onChange?.(value);
  };
  return (
    <div className="w-full">
      <Select
        style={{ width: "100%" }}
        disabled={!props.editable}
        value={value}
        onChange={onChange}
        {...props.schema.setter.config}
      >
        {fontFamilyList.map((item: string, index: number) => {
          return (
            <Option key={index} value={item}>
              {item}
            </Option>
          );
        })}
      </Select>
    </div>
  );
};
export default FontFamily;
