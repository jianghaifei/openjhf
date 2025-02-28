/* elnt-disable no-debugger */
import { Select } from "antd";

const SelectCustom = (props: any) => {
  const { onChange, readPretty, value, options } = props;
  // console.log("kkkkk", props);
  return readPretty ? (
    <span>{((options && options.find((el: any) => el.value == value)) || {}).label || value}</span>
  ) : (
    <Select
      onChange={onChange}
      options={options}
      style={{ width: "100%" }}
      value={value}
      allowClear
    ></Select>
  );
};
export default SelectCustom;
