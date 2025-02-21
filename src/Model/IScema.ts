import ComponentType from '@/Constants/ComponentType'
import { ICommonConfig } from './ICommonModel'

export interface IComponentPropsSetter<T = any> {
  type: ComponentType
  config?: ICommonConfig
  defaultValue?: T
  editable?: boolean
}

export interface IComponentPropsSchema<T = any> {
  key: string
  title?: string
  description?: string
  setter: IComponentPropsSetter
  extensions: T
  valueType?: string
}

export interface IComponentBasicInfo {
  name: string
  version?: string
  description?: string
  package?: string
  type: string
  icon: string | JSX.Element
}

export interface IComponentLayoutSchema {
  width: number | string
  height: number | string
  direction?: string
  grow?: boolean
  shrink?: boolean
  padding?: string
  margin?: string
  resizable?: boolean
  absolute?: boolean
  dragable?: boolean
  dropable?: boolean
  canvas?: boolean
}

export interface IComponentProperties {
  group?: string //属性设置分组
  properties: IComponentPropsSchema[]
}

export interface IComponentSchema {
  basic: IComponentBasicInfo
  layout: IComponentLayoutSchema
  properties: IComponentProperties[] | IComponentPropsSchema[]
  propsSchemas?: any;
  stylesSchemas?: any;
  eventsSchemas?: any;
  pageSchemas?: any;
  defaultData?: any;
}
