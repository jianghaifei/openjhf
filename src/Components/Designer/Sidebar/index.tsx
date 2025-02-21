// import DraggableComponent from "../components/DraggableComponent";
import { observer } from 'mobx-react-lite'
import { Layout, Collapse, TabPane, Tabs } from '@douyinfe/semi-ui'
import Layer from './Layer'
import { SidebarMenuList } from '@/Components/Designer/Sidebar/DragWrapper'
import { useEditor } from '@/Components/Designer/Layout/core'

const { Sider } = Layout

export const Sidebar = observer(() => {
  const { enabled } = useEditor((state) => {
    return { enabled: state.options.enabled }
  })

  return enabled ? (
    <Sider className="border-r w-[240px] flex-shrink-0 bg-white">
      <Tabs
        type="line"
        className="h-full w-full flex flex-col"
        tabBarStyle={{ padding: '0 20px' }}
        contentStyle={{ overflow: 'auto', flex: 1 }}>
        <TabPane tab="组件" itemKey="1">
          <Collapse defaultActiveKey={['1', '2', '3', '4']}>
            <Collapse.Panel header="布局" itemKey="1">
              <div className="flex flex-row flex-wrap">
                {/* {components.map((item, index) => {
                  return <DraggableComponent elementKey={item} key={index} />;
                })} */}
                <SidebarMenuList
                  prop={[
                    {
                      type: 'Container',
                      prop: {
                        layout: {
                          width: '500px',
                          height: '300px'
                        }
                      }
                    },
                    {
                      type: 'AbsoluteElement',
                      prop: {
                        layout: {
                          width: '500px',
                          height: '300px'
                        }
                      }
                    }
                  ]}></SidebarMenuList>
                {/* <div className="w-[100px] h-[100px] bg-blue-500" ref={(ref) => create(ref!,
                  <Element canvas is={Container} direction="row" style={{background: 'rgba(255, 0, 0, 0.3)', color: 'green'}} layout={{height: "500px", width: "100%"}}></Element>
                )}></div> */}
              </div>
            </Collapse.Panel>
            <Collapse.Panel header="标准组件" itemKey="2"></Collapse.Panel>
            <Collapse.Panel header="业务组件" itemKey="3">
              <div className="flex flex-row flex-wrap">
                <SidebarMenuList
                  prop={[
                    { type: 'OrderSidebar' },
                    { type: 'MenuGroup' },
                    { type: 'MenuList' },
                    { type: 'BottomButtons' },
                    { type: 'SideButtons' },
                    { type: 'TopMenu' },
                    { type: 'OrderMenu' },
                    { type: 'PaymentMethod' },
                    { type: 'Payment' },
                    { type: 'OrderListHeader' },
                    { type: 'OrderListSidebar' },
                    { type: 'OrderListContent' }
                  ]}></SidebarMenuList>
              </div>
            </Collapse.Panel>
            <Collapse.Panel header="功能键" itemKey="4">
              <div className="flex flex-row flex-wrap"></div>
            </Collapse.Panel>
          </Collapse>
        </TabPane>
        <TabPane tab="图层" itemKey="2">
          <Layer />
        </TabPane>
      </Tabs>
    </Sider>
  ) : (
    <></>
  )
})

export default Sidebar
