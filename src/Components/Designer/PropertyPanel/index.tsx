import { Layout, Tabs, TabPane } from '@douyinfe/semi-ui'
import { useMemo } from 'react'
import PropPanel from './PropPanel'
import LayoutPanel from './LayoutPanel.tsx'
import StylePanel from './StylePanel'
import PropertyType from '../../../Constants/PropertyType.ts'
import { useEditor } from '../Layout/core/index.tsx'

const { Sider } = Layout

export const PropertyPanel = () => {
  const tabOptions = useMemo(
    () => [
      {
        text: '布局',
        type: PropertyType.PropertyType_Layout,
        component: <LayoutPanel />
      },
      {
        text: '属性',
        type: PropertyType.PropertyType_Props,
        component: <PropPanel />
      },
      {
        text: '样式',
        type: PropertyType.PropertyType_Style,
        component: <StylePanel />
      }
    ],
    []
  )
  const { enabled } = useEditor((state) => {
    return { enabled: state.options.enabled }
  })

  return enabled ? (
    <Sider className="border-l w-[300px] bg-white flex-shrink-0">
      <div className="flex h-full w-full break-all">
        <Tabs
          className="flex flex-col w-full overflow-hidden"
          lazyRender
          tabBarStyle={{ padding: '0 20px' }}
          contentStyle={{ flex: 1, overflowX: 'hidden', overflowY: 'auto' }}>
          {tabOptions.map((item) => {
            return (
              <TabPane tab={item.text} key={item.type} itemKey={item.type.toString()}>
                <div className="w-full h-full">{item.component}</div>
              </TabPane>
            )
          })}
        </Tabs>
      </div>
    </Sider>
  ) : (
    <></>
  )
}

export default PropertyPanel
