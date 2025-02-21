import ComponentType from '@/Constants/ComponentType'
import { IComponentSchema } from '@/Model/IScema'

export const LayoutProperties = [
  {
    group: '尺寸设置',
    properties: [
      {
        key: 'layout.direction',
        title: '容器方向',
        description: '设置容器方向，设定内部容器排列方式',
        setter: {
          type: ComponentType.Selection,
          config: {
            dataSource: [
              {
                label: '列',
                value: 'column'
              },
              {
                label: '行',
                value: 'row'
              }
            ]
          },
          defaultValue: 'column',
          editable: true
        },
        extensions: {
          placeholder: '请选择容器方向'
        },
        valueType: 'string'
      },
      {
        key: 'layout.width',
        title: 'Width',
        description: '宽度',
        setter: {
          type: ComponentType.Input,
          config: {},
          defaultValue: '500px',
          editable: true
        },
        extensions: {
          placeholder: '请输入容器宽度'
        },
        valueType: 'string'
      },
      {
        key: 'layout.height',
        title: 'Height',
        description: '高度',
        setter: {
          type: ComponentType.Input,
          config: {},
          defaultValue: '300px',
          editable: true
        },
        extensions: {
          placeholder: '请输入容器高度'
        },
        valueType: 'string'
      },
      {
        key: 'layout.grow',
        title: '自动填充',
        description: '自动填充',
        setter: {
          type: ComponentType.Switch,
          config: {},
          defaultValue: false,
          editable: true
        },
        extensions: {
          placeholder: '请输入容器高度'
        },
        valueType: 'bool'
      }
    ]
  },
  {
    group: '间距设置',
    properties: [
      {
        key: 'layout.padding',
        title: 'Padding',
        description: 'Padding',
        setter: {
          type: ComponentType.Input,
          config: {},
          defaultValue: '0',
          editable: true
        },
        extensions: {
          placeholder: '请输入 padding 值'
        },
        valueType: 'string'
      },
      {
        key: 'layout.margin',
        title: 'Margin',
        description: 'Margin',
        setter: {
          type: ComponentType.Input,
          config: {},
          defaultValue: '0',
          editable: true
        },
        extensions: {
          placeholder: '请输入 margin 值'
        },
        valueType: 'string'
      }
    ]
  }
]

export const ContainerSchema: IComponentSchema = {
  basic: {
    name: '基础容器',
    description: 'Flex Container',
    type: 'Container',
    package: '@cyrilis/flame',
    version: '0.0.20',
    icon: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 4H21C21.5523 4 22 4.44772 22 5V19C22 19.5523 21.5523 20 21 20H3C2.44772 20 2 19.5523 2 19V5C2 4.44772 2.44772 4 3 4ZM4 6V18H20V6H4Z"></path></svg>`
  },
  layout: {
    width: 4,
    height: 9,
    resizable: true,
    dropable: true,
    dragable: true,
    canvas: true
  },
  properties: []
}

export const PageSchema: IComponentSchema = {
  basic: {
    name: 'Page',
    description: 'Page',
    type: 'Page',
    package: 'built-in',
    version: '1.0.0',
    icon: 'icon-page'
  },
  layout: {
    width: 4,
    height: 9,
    canvas: true,
    resizable: false
  },
  properties: [
    {
      key: 'title',
      title: '标题',
      description: '设置标题',
      setter: {
        type: ComponentType.Input,
        editable: true
      },
      extensions: {
        placeholder: '请输入标题'
      },
      valueType: 'string'
    },
    {
      key: 'route',
      title: '页面路由',
      description: '请输入页面路由',
      setter: {
        type: ComponentType.Input,
        editable: true
      },
      extensions: {
        placeholder: '请输入路由'
      },
      valueType: 'string'
    }
  ]
}
