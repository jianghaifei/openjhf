//checkbox 复选框
import { ISchemaEditProps } from "@/Model/ISchemaEditProps";
import { CheckboxGroup } from "@douyinfe/semi-ui";
import { useState } from "react";

const CheckBox = (props: ISchemaEditProps) => {
  const { schema } = props;
  const [value, setValue] = useState<string[]>(props.value || []);

  const options = schema.setter.config?.options || [];

  const onChange = (value: string[]) => {
    setValue(value);
    props.onChange?.(value);
  };

  return (
    <div className="flex-1 pt-[6px]">
      <CheckboxGroup
        direction="horizontal"
        options={options}
        value={value}
        onChange={onChange}
        {...schema.extensions}
      />
    </div>
  );
};
export default CheckBox;
