import { useCallback, useContext } from 'react'
import { Collapse } from '@douyinfe/semi-ui'
import { IconChevronDown, IconChevronRight } from '@douyinfe/semi-icons'
import { IComponentPropsSchema } from '@/Model/IScema.ts'
import ComponentType from '@/Constants/ComponentType.ts'
import StyleItem from './StyleItem.tsx'
// import PropertyType from "@/Constants/PropertyType.ts";
import { ICommonConfig } from '@/Model/ICommonModel.ts'
import { observer } from 'mobx-react-lite'
import StyleType from '@/Constants/StyleType.ts'
import StoreContext from '@/Store/storeContext.ts'
import { useEditor } from '@/Components/Designer/Layout/core/index.tsx'
import { merge } from 'lodash'
import { LayoutStyle } from '@/Components/Designer/PropertyPanel/StylePanel/LayoutStyle.tsx'

type IItem = {
  title: string
  key: string
  children: IComponentPropsSchema[]
}

const StylePanel = observer(() => {
  const { designerStore } = useContext(StoreContext)
  const { activeComponent, pageModel } = designerStore

  const {
    actions: { setProp },
    active
  } = useEditor((state, query) => {
    return {
      active: query.getEvent('selected').first()
    }
  })

  const setCanvasStyle = useCallback(
    (id: string, property: ICommonConfig) => {
      if (active !== id) return
      setProp(active, (prop) => {
        console.log('Canvas set property:', active, prop, property)
        prop.style = merge({}, prop.style, property)
      })
    },
    [active, setProp]
  )

  const list: IItem[] = [
    {
      title: '布局',
      key: 'layout',
      children: [
        {
          title: '宽度',
          key: 'width',
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        },
        {
          title: '高度',
          key: 'height',
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        },
        {
          title: '内边距',
          key: 'padding',
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        },
        {
          title: '外边距',
          key: 'margin',
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        }
      ]
    },
    {
      title: '文字',
      key: 'font',
      children: [
        {
          title: '字号',
          key: StyleType.fontSize,
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        },
        {
          title: '行高',
          key: StyleType.lineHeight,
          setter: {
            type: ComponentType.Input,
            config: {
              unit: 'px'
            },
            defaultValue: '',
            editable: true
          },
          extensions: {}
        },
        {
          title: '字体颜色',
          key: StyleType.color,
          setter: {
            type: ComponentType.ColorPicker,
            config: {},
            defaultValue: '',
            editable: true
          },
          extensions: {}
        }
      ]
    },
    {
      title: '背景',
      key: 'background',
      children: [
        {
          title: '背景颜色',
          key: StyleType.backgroundColor,
          setter: {
            type: ComponentType.ColorPicker,
            config: {},
            defaultValue: '',
            editable: true
          },
          extensions: {}
        }
      ]
    }
  ]
  return (
    <>
      <LayoutStyle></LayoutStyle>
      <Collapse
        keepDOM
        expandIconPosition="left"
        collapseIcon={<IconChevronDown />}
        expandIcon={<IconChevronRight />}
        defaultActiveKey={list.map((v) => v.key)}>
        {list.map((item) => {
          return (
            <Collapse.Panel header={item.title} itemKey={item.key} key={item.key}>
              {item.children.map((subItem) => {
                return (
                  <StyleItem
                    key={subItem.key}
                    item={subItem}
                    activeComponent={activeComponent}
                    pageModel={pageModel}
                    setProperty={(property: ICommonConfig) => {
                      if (!activeComponent) return
                      designerStore.setStyle(property)
                      setCanvasStyle(activeComponent.componentInfo.id, property)
                    }}
                  />
                )
              })}
            </Collapse.Panel>
          )
        })}
      </Collapse>
    </>
  )
})
export default StylePanel
