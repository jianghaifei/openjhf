import { Tag } from "antd";

const View = (props: any) => {
  const { label, value } = props;
  return <Tag color={`${value == 1 ? "#4340f4" : ""}`}>{label}</Tag>;
};
export default View;
