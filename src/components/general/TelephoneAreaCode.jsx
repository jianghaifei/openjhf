import React, { useEffect } from "react";
import { Select } from "antd";
import "./css/TelephoneAreaCode.less";

const { Option } = Select;
const TelephoneAreaCode = props => {
  const { onChange } = props;
  const defaultAreaCode = "86";
  useEffect(() => {
    onChange(defaultAreaCode);
    // eslint-disable-next-line
	}, []);
  return (
    <Select defaultValue={defaultAreaCode} className="select-box" onSelect={onChange}>
      <Option value="86">中国大陆+86</Option>
      <Option value="852">中国香港+852</Option>
      <Option value="853">中国澳门+853</Option>
      <Option value="886">中国台湾+886</Option>
      <Option value="1">美国+1</Option>
      <Option value="44">英国+44</Option>
      <Option value="33">法国+33</Option>
      <Option value="61">澳大利亚+61</Option>
      <Option value="7">俄罗斯+7</Option>
    </Select>
  );
};
export default React.memo(TelephoneAreaCode);
