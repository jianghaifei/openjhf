import { useMemo } from 'react'
import { IComponentPropsSchema } from '@/Model/IScema.ts'
import SchemaLabel from '../../../Schemas/SchemaLabel.tsx'
import SchemaComponentHelper from '@/Utils/SchemaComponentHelper.ts'
import { ISchemaEditProps } from '@/Model/ISchemaEditProps.ts'
// import PropertyType from "@/Constants/PropertyType.ts";
import BasicComponentModel from '@/ViewModel/BasicComponentModel.ts'
import { ICommonConfig } from '@/Model/ICommonModel.ts'
import PageModel from '@/ViewModel/PageModel.ts'
import { set, get } from 'lodash'
import { useContext } from 'react'
import StoreContext from '@/Store/storeContext.ts'

type IProps = {
  item: IComponentPropsSchema
  setProperty: (id: string, property: ICommonConfig) => void
  activeComponent?: BasicComponentModel | null
  pageModel?: PageModel | null
}
const PropItem = (props: IProps) => {
  const { item } = props
  const { key, title, setter } = item
  const { editable, type } = setter
  // const designerStore = useContext(DesignerStoreContext);
  const { designerStore } = useContext(StoreContext)
  const activeComponent = designerStore.getActiveComponent()
  const editProps: ISchemaEditProps = useMemo(() => {
    let targetValue = get(activeComponent?.componentInfo.props, key)
    // HIJACK!
    if (key.startsWith('layout')) {
      targetValue = get(activeComponent?.componentInfo, key)
    }
    return {
      value: targetValue,
      editable: editable,
      schema: item,
      currentModel: activeComponent || undefined,
      onChange: (value: typeof targetValue) => {
        if (!activeComponent) return
        console.log(activeComponent.componentInfo.id)
        props.setProperty(activeComponent.componentInfo.id, set({}, key, value))
      }
    }
  }, [activeComponent, key, editable, item, props])

  const renderSchemaItem = useMemo(() => {
    const Component = SchemaComponentHelper.getComponentByType(type)
    if (!Component) return null
    return (
      <div className="flex text-sm m-3">
        {title && <SchemaLabel label={title} />}
        <Component {...editProps} />
      </div>
    )
  }, [editProps, title, type])

  return <>{renderSchemaItem}</>
}
export default PropItem
