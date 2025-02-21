import ComponentType from '../Constants/ComponentType'
import { IComponentProperties, IComponentPropsSchema, IComponentSchema } from '../Model/IScema.ts'
import { ICommonConfig } from '@/Model/ICommonModel.ts'
import { set } from 'lodash'

//在这里加载组件的schema
export const getComponentSchema = (type: string): IComponentSchema => {
  console.log(type)
  return {
    basic: {
      name: 'demo',
      version: '1.0.0',
      description: 'hahahahah',
      type: 'ColorPicker',
      icon: ''
    },
    layout: {
      width: 3,
      height: 4,
      resizable: true
    },
    properties: [
      {
        key: 'propsKey1',
        title: 'set key1 value',
        description: 'hhhhhhh',
        setter: {
          type: ComponentType.Select,
          config: {
            datasource: [
              {
                label: '柱状',
                value: 'column'
              },
              {
                label: '折线',
                value: 'spline'
              }
            ]
          },
          defaultValue: 'column',
          editable: true
        },
        extensions: {},
        valueType: 'string'
      },
      {
        key: 'propsKey2',
        title: 'set key2 value',
        description: 'hhhhhhh',
        setter: {
          type: ComponentType.Input,
          defaultValue: 'test',
          editable: true
        },
        extensions: {},
        valueType: 'string'
      }
    ]
  }
}

/**
 * @description 解析 properties Schema 为 键值对
 * */
export const parseProperty2Object = (
  properties: IComponentProperties[] | IComponentPropsSchema[]
): ICommonConfig => {
  const newProps: ICommonConfig = {}
  properties.map((item) => {
    if ('group' in item) {
      item.properties.map((subItem) => {
        set(newProps, subItem.key, subItem.setter.defaultValue)
      })
    } else {
      set(
        newProps,
        (item as IComponentPropsSchema).key,
        (item as IComponentPropsSchema).setter.defaultValue
      )
    }
  })
  return newProps
}
