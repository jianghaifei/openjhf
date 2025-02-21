import { IPageMetadata } from '@/Model/IPageMetadata'
import StoreContext from '@/Store/storeContext'
import { Button, Divider } from '@douyinfe/semi-ui'
import { useContext } from 'react'

import { IconChevronDown } from '@douyinfe/semi-icons'
import { Dropdown } from '@douyinfe/semi-ui'
import orderData from './example.json'
import orderListData from './orderList.json'
import paymentData from './payment.json'
import { IComponent } from '@/Model/IComponent'
import { useEditor } from '@/Components/Designer/Layout/core'

enum ExampleType {
  order = 'order',
  payment = 'payment',
  orderList = 'orderList'
}

const exampleMap: Record<ExampleType, any> = {
  order: orderData,
  payment: paymentData,
  orderList: orderListData
}

const modelToCraft = (tree: IComponent[]) => {
  const canvasSchema: Record<string, any> = {}

  function stepOver(children: IComponent[], parent: string | null) {
    console.log() // a
    ;(children || []).forEach((child: IComponent) => {
      canvasSchema[child.id] = {
        id: child.id,
        type: {
          resolvedName: child.type === 'Page' ? 'Container' : child.type
        },
        isCanvas: child.layout.canvas || false,
        hidden: false,
        name: (child as any).title || child.name,
        displayName: (child as any).title || child.name,
        props: {
          style: child.style,
          layout: child.layout,
          ...child.props
        },
        nodes: (child.children || []).map((node) => node.id),
        parent
      }
      if (child.children?.length) {
        stepOver(child.children, child.id)
      }
    })
  }

  stepOver(tree, null)
  console.log('CANVAS SCHEMA: ', canvasSchema)
  return canvasSchema
}

export const LoadExample = () => {
  const { designerStore } = useContext(StoreContext)
  const { actions } = useEditor()
  const clickHandler = (key: ExampleType) => {
    const exampleData = exampleMap[key]
    const pageData: IPageMetadata = {
      id: exampleData.id,
      type: exampleData.type,
      props: {
        route: exampleData.props.route,
        title: exampleData.props.title
      },
      style: {},
      componentsTree: exampleData.componentsTree as unknown as IComponent[]
    }
    designerStore.setPageData(pageData)
    const craftData = modelToCraft(exampleData.componentsTree as unknown as IComponent[])
    actions.deserialize(JSON.stringify(craftData))
  }
  return (
    <>
      <Dropdown
        position={'bottomLeft'}
        render={
          <Dropdown.Menu>
            <Dropdown.Item
              onClick={() => {
                clickHandler(ExampleType.order)
              }}>
              点餐页 (Order Page)
            </Dropdown.Item>
            <Dropdown.Item
              onClick={() => {
                clickHandler(ExampleType.payment)
              }}>
              支付页面 (Payment)
            </Dropdown.Item>
            <Dropdown.Item
              onClick={() => {
                clickHandler(ExampleType.orderList)
              }}>
              订单列表 (Order List)
            </Dropdown.Item>
          </Dropdown.Menu>
        }>
        <Button icon={<IconChevronDown />} iconPosition="right">
          Load Example
        </Button>
      </Dropdown>

      {/* <Button onClick={clickHandler}></Button> */}
      <Divider margin={'12px'} className="!h-auto" layout="vertical" />
    </>
  )
}
