//开关
import { ISchemaEditProps } from "@/Model/ISchemaEditProps";
import { Switch } from "@douyinfe/semi-ui";
import { useEffect, useState } from "react";

const SwitchSchema = (props: ISchemaEditProps) => {
  const [value, setValue] = useState(false);

  useEffect(() => {
    setValue(props.value || false);
  }, [props.value]);

  const onChange = (value: boolean) => {
    setValue(value);
    props.onChange?.(value);
  };

  return (
    <div className="flex-1 flex items-center">
      <Switch
        size="small"
        disabled={!props.editable}
        checked={value}
        onChange={onChange}
        {...props.schema.extensions}
      ></Switch>
    </div>
  );
};
export default SwitchSchema;
