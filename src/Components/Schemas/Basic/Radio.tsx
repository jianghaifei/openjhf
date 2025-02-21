import { ISchemaEditProps } from "@/Model/ISchemaEditProps";
import { Radio, RadioGroup } from "@douyinfe/semi-ui";
import { SetStateAction, useState } from "react";

interface Option {
  label: string;
  value: string;
  disabled?: boolean;
}

const Radios = (props: ISchemaEditProps) => {
  const { schema } = props;
  const [value, setValue] = useState<string>(props.value || "");
  const options = schema.setter.config?.options || [];

  const onChange = (e: { target: { value: SetStateAction<string> } }) => {
    setValue(e.target.value);
    props.onChange?.(e.target.value);
  };

  return (
    <div className="flex-1 pt-[6px]">
      <RadioGroup onChange={onChange} value={value} {...schema.extensions}>
        {options.map((item: Option) => {
          return (
            <Radio key={item.value} value={item.value}>
              {item.label}
            </Radio>
          );
        })}
      </RadioGroup>
    </div>
  );
};
export default Radios;
