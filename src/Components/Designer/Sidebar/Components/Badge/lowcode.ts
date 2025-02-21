import { IComponentSchema } from '@/Model/IScema.ts'
import ComponentType from '@/Constants/ComponentType.ts'

const schema: IComponentSchema = {
  basic: {
    name: '通知',
    description: '我是通知',
    type: ComponentType.Badge,
    version: '1.0.0',
    icon: 'icon-xiaoxi1'
  },
  layout: {
    width: 2,
    height: 9,
    resizable: false
  },
  properties: [
    {
      key: 'count',
      title: '条数',
      description: '我是条数',
      setter: {
        type: ComponentType.InputNumber,
        config: {},
        defaultValue: '1',
        editable: true
      },
      extensions: {},
      valueType: 'string'
    },
    {
      key: 'color',
      title: '条数颜色',
      description: '我是颜色',
      setter: {
        type: ComponentType.ColorPicker,
        config: {},
        defaultValue: 'skyblue',
        editable: true
      },
      extensions: {},
      valueType: 'string'
    }
  ]
}
export default schema
