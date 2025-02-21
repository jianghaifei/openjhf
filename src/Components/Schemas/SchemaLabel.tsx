type IProps = {
  label: string;
};
const SchemaLabel = (props: IProps) => {
  const { label } = props;
  return (
    <div className="w-[70px] h-[30px] flex items-center shrink-0 mr-[15px]">
      {label}
    </div>
  );
};
export default SchemaLabel;
