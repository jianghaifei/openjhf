import { useCallback, useContext, useEffect, useMemo, useState } from 'react'
import { Collapse } from '@douyinfe/semi-ui'
import { IconChevronDown, IconChevronRight } from '@douyinfe/semi-icons'
import { observer } from 'mobx-react-lite'
// import PropertyType from "@/Constants/PropertyType.ts";
import { ICommonConfig } from '@/Model/ICommonModel.ts'
import { IComponentProperties, IComponentPropsSchema } from '@/Model/IScema.ts'
import PropItem from './PropItem.tsx'
import StoreContext from '@/Store/storeContext.ts'
import { useEditor } from '@/Components/Designer/Layout/core/index.tsx'
import { merge } from 'lodash'

const PropPanel = observer(() => {
  const [activeKey, setActiveKey] = useState<string[]>([])
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

  const setCanvasProp = useCallback(
    (id: string, property: ICommonConfig) => {
      if (active !== id) return
      setProp(active, (prop) => {
        console.log('Canvas set property:', active, prop, property)
        merge(prop, property)
      })
    },
    [active, setProp]
  )

  const list = useMemo(() => {
    let data: IComponentPropsSchema[] | IComponentProperties[] = []
    const _data: IComponentProperties[] = []
    if (!activeComponent && pageModel) {
      data = pageModel?.propsSchema
    } else {
      data = activeComponent?.properties || []
    }
    if (!data) return _data
    const firstItem = data[0]
    if (!firstItem) return _data
    if ('group' in firstItem) {
      data = (data || []) as IComponentProperties[]
    } else {
      if (!data.length) {
        data = []
      }
      data = [
        {
          group: '组件设置',
          properties: data as IComponentPropsSchema[]
        }
      ]
    }
    return _data.concat(data) || []
  }, [activeComponent, pageModel])

  useEffect(() => {
    const keys = list.map((item) => item.group!)
    setActiveKey(keys)
  }, [list])

  return (
    <Collapse
      expandIconPosition="left"
      collapseIcon={<IconChevronDown />}
      expandIcon={<IconChevronRight />}
      onChange={(v) => {
        if (!v) {
          v = []
        }
        if (typeof v === 'string') {
          v = [v]
        }
        setActiveKey(v)
      }}
      activeKey={activeKey}
      defaultActiveKey={list.map((item) => item.group!)}>
      {list.map((item) => {
        return (
          <Collapse.Panel header={item.group} itemKey={item.group!} key={item.group}>
            {item.properties.map((item, idx) => {
              return (
                <PropItem
                  key={idx}
                  item={item}
                  activeComponent={activeComponent}
                  pageModel={pageModel}
                  setProperty={(id: string, property: ICommonConfig) => {
                    setCanvasProp(id, property)
                  }}
                />
              )
            })}
          </Collapse.Panel>
        )
      })}
    </Collapse>
  )
})
export default PropPanel
