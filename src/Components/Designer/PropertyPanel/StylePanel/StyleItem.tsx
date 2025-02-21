import SchemaLabel from "@/Components/Schemas/SchemaLabel";
// import PropertyType from "@/Constants/PropertyType";
import { ICommonConfig } from "@/Model/ICommonModel";
import { IComponentPropsSchema } from "@/Model/IScema";
import { ISchemaEditProps } from "@/Model/ISchemaEditProps";
import SchemaComponentHelper from "@/Utils/SchemaComponentHelper";
import BasicComponentModel from "@/ViewModel/BasicComponentModel";
import PageModel from "@/ViewModel/PageModel";
import { useMemo } from "react";

type IProps = {
  item: IComponentPropsSchema;
  setProperty: (property: ICommonConfig) => void;
  activeComponent?: BasicComponentModel | null;
  pageModel?: PageModel | null;
};
const StyleItem = (props: IProps) => {
  const { item, activeComponent, pageModel } = props;
  const { key, setter, title } = item;
  const { editable, config = {}, type } = setter;
  const editProps: ISchemaEditProps = useMemo(() => {
    const targetValue =
      activeComponent?.componentInfo.style[key] || pageModel?.defaultStyle[key];
    return {
      value: targetValue,
      editable: editable,
      schema: item,
      currentModel: activeComponent || undefined,
      onChange: (value: typeof targetValue) => {
        const { unit = "" } = config;
        let newValue = value;
        if (typeof value === "number" || typeof value === "string") {
          // eslint-disable-next-line @typescript-eslint/restrict-plus-operands
          newValue = (newValue as number | string) + (unit as string);
        }
        props.setProperty({ [key]: newValue });
      },
    };
  }, [
    activeComponent,
    config,
    editable,
    item,
    key,
    pageModel?.defaultStyle,
    props,
  ]);

  const renderSchemaItem = useMemo(() => {
    const Component = SchemaComponentHelper.getComponentByType(type);
    if (!Component) return null;
    return (
      <div className="flex items-center text-sm mb-3">
        {title && <SchemaLabel label={title} />}
        <Component {...editProps} />
      </div>
    );
  }, [editProps, title, type]);
  return <>{renderSchemaItem}</>;
};
export default StyleItem;
