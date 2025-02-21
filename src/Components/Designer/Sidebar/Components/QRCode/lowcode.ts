import { IComponentSchema } from '@/Model/IScema.ts'
import ComponentType from '@/Constants/ComponentType.ts'

const schema: IComponentSchema = {
  basic: {
    name: '二维码',
    description: '我是二维码',
    type: ComponentType.QRCode,
    version: '1.0.0',
    icon: 'icon-31erweima'
  },
  layout: {
    width: 6,
    height: 28,
    resizable: false
  },
  properties: [
    {
      key: 'value',
      title: 'url',
      description: '我是url',
      setter: {
        type: ComponentType.Input,
        config: {},
        defaultValue: '默认地址',
        editable: true
      },
      extensions: {
        placeholder: '请输入url'
      },
      valueType: 'string'
    },
    {
      key: 'color',
      title: '颜色',
      description: '我是颜色',
      setter: {
        type: ComponentType.ColorPicker,
        config: {},
        defaultValue: '#000',
        editable: true
      },
      extensions: {},
      valueType: 'string'
    },
    {
      key: 'size',
      title: '尺寸',
      description: '我是尺寸',
      setter: {
        type: ComponentType.InputNumber,
        config: {},
        defaultValue: 140,
        editable: true
      },
      extensions: {
        placeholder: '请输入尺寸'
      },
      valueType: 'string'
    }
  ]
}
export default schema
