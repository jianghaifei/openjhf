import { IComponentSchema } from '../Model/IScema.ts'
import { JSX } from 'react'
import { parseProperty2Object } from '@/Utils/Utils.ts'
import { toJS } from 'mobx'
import { UserComponentConfig } from '@/Components/Designer/Layout/core/index.tsx'

export type IComponentWrapper = (
  Component: JSX.ElementType,
  Schema?: IComponentSchema
) => JSX.ElementType

class ComponentHelper {
  componentWrapper?: IComponentWrapper
  componentSchemas: {
    [key: string]: IComponentSchema
  } = {}
  components: {
    [key: string]: JSX.ElementType
  } = {}

  static instance: ComponentHelper

  constructor() {
    this.components = {}
  }

  static getInstance() {
    if (!this.instance) {
      this.instance = new ComponentHelper()
    }
    return this.instance
  }

  // Setup component wrapper, such as a resizer
  setComponentWrapper(cw: IComponentWrapper) {
    this.componentWrapper = cw
  }

  register(
    component: JSX.ElementType,
    schema: IComponentSchema,
    craft?: Partial<UserComponentConfig<any>>
  ) {
    if (this.components[schema.basic.type]) return
    const defaultProps = parseProperty2Object(schema.properties)
    craft = craft || {
      displayName: schema.basic.name,
      props: defaultProps,
      custom: {
        absolute: schema.layout.absolute === true
      },
      rules: {
        canDrag: () => {
          return schema.layout.dragable !== false
        },
        canDrop: () => {
          return schema.layout.dropable !== false
        }
      }
    }
    const _component = this.componentWrapper ? this.componentWrapper(component, schema) : component
    Object.defineProperty(_component, 'name', { value: schema.basic.type })
    Object.defineProperty(_component, 'craft', { value: craft })
    this.components[schema.basic.type] = _component
    this.componentSchemas[schema.basic.type] = schema
  }

  use(schema: IComponentSchema, component: JSX.ElementType) {
    if (this.components[schema.basic.type]) return
    this.register(component, schema)
  }

  getComponents() {
    return this.components
  }

  getSchemas() {
    return this.componentSchemas
  }

  getComponentMap() {
    return Object.values(toJS(this.getSchemas()))
      .map((schema) => {
        console.log(schema)
        return schema
      })
      .filter((schema) => {
        return !['Page'].includes(schema.basic.type)
      })
      .map((schema: IComponentSchema) => {
        console.log('---:', schema)
        return {
          componentName: schema.basic.type,
          package: schema.basic.package,
          version: schema.basic.version,
          destructuring: true
        }
      })
  }

  /**
   * @description 获取Sidebar 暴露出的所有组件 key
   * */
  get getAllComponentKeys() {
    return Object.keys(this.componentSchemas)
  }

  getElementByType(type: string) {
    if (!(type in this.components)) return null
    return this.components[type]
  }

  /**
   * @description 根据组件类型和字段类型,获取组件的单个字段
   * @params {string} type
   * @params {string} fieldType
   * */
  getFieldByType(
    type: string,
    fieldType: keyof IComponentSchema
  ): IComponentSchema[keyof IComponentSchema] {
    return this.componentSchemas[type][fieldType]
  }
}

export default ComponentHelper.getInstance()
