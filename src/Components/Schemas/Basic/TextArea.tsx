//指标释议 输入框
import { ISchemaEditProps } from "../../../Model/ISchemaEditProps.ts";
import { useEffect, useState } from "react";
import { TextArea as SemiTextArea } from "@douyinfe/semi-ui";

const TextArea = (props: ISchemaEditProps) => {
  const [value, setValue] = useState<string>("");
  const { schema } = props;

  useEffect(() => {
    setValue(props.value || []);
  }, [props.value]);

  const onChange = (value: string) => {
    setValue(value);
    props.onChange?.(value);
  };

  return (
    <SemiTextArea
      className="w-full flex-1"
      rows={4}
      value={value}
      onChange={onChange}
      {...schema.extensions}
    />
  );
};
export default TextArea;
