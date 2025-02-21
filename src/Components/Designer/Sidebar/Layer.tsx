import { Tree } from '@douyinfe/semi-ui'
import { observer } from 'mobx-react-lite'
import { useCallback, useContext, useMemo } from 'react'
import { DragTreeNode, TreeNodeData, Value } from '@douyinfe/semi-ui/lib/es/tree/interface'
import StoreContext from '@/Store/storeContext'
import { IPageMetadata } from '@/Model/IPageMetadata'
import { IComponent } from '@/Model/IComponent'
import ComponentHelper from '@/Utils/ComponentHelper'
import { Node, useEditor } from '@/Components/Designer/Layout/core'

type LoopCallback = (item: TreeNodeData, idx: number, arr: TreeNodeData[]) => void

const Layer = observer(() => {
  const { designerStore } = useContext(StoreContext)

  const { actions, query } = useEditor()

  const schemaMap = ComponentHelper.componentSchemas

  const transformData = useCallback(
    (data: IPageMetadata | IComponent): TreeNodeData => {
      const children = (data as IPageMetadata).componentsTree || (data as IComponent).children || []
      const childrenNodes: TreeNodeData[] = children.map((child: IComponent) => {
        return transformData(child)
      })

      const type = data.type
      const schema = schemaMap[type]

      const icon =
        typeof schema.basic.icon === 'string' ? (
          schema.basic.icon.startsWith('icon') ? (
            <i className={`iconfont ${schema.basic.icon} text-3xl mr-1`} />
          ) : (
            <div
              style={{ width: '18px', marginRight: '3px' }}
              dangerouslySetInnerHTML={{ __html: schema.basic.icon }}></div>
          )
        ) : (
          <div className="w-[18px] mr-1">{schema.basic.icon}</div>
        )

      if (data?.type === 'Page') {
        return {
          label: (data as IPageMetadata).title || 'Page',
          value: data.id,
          key: data.id,
          type: 'Page',
          children: childrenNodes
        }
      } else {
        return {
          label: (data as IComponent).name,
          value: data.id,
          key: data.id,
          type: data.type,
          children: childrenNodes,
          icon: icon
        }
      }
    },
    [schemaMap]
  )

  const treeData = useMemo(() => {
    if (!designerStore.pageData) {
      return []
    }
    return [transformData(designerStore.pageData)]
  }, [designerStore.pageData, transformData])

  const handleChange = (value?: Value) => {
    if (typeof value === 'object') {
      if ((value as TreeNodeData).type === 'Page') {
        actions.selectNode()
      } else {
        actions.selectNode((value as TreeNodeData).value as string)
      }
    }
  }
  if (!designerStore.pageData) {
    return <div></div>
  }

  function onDrop(info: {
    node: DragTreeNode
    dragNode: DragTreeNode
    dragNodesKeys: string[]
    dropPosition: number
    dropToGap: boolean
  }) {
    const { dropToGap, node, dragNode } = info
    const dropKey = node.key
    const dragKey = dragNode.key
    const dropPos = node.pos.split('-')
    const dropPosition = info.dropPosition - Number(dropPos[dropPos.length - 1])

    const data: TreeNodeData[] = [...treeData]
    const loop = (data: TreeNodeData[], key: string, callback: LoopCallback) => {
      data.forEach((item, ind, arr) => {
        if (item.key === key) return callback(item, ind, arr)
        if (item.children) return loop(item.children, key, callback)
      })
    }

    let dragObj: TreeNodeData
    loop(data, dragKey, (item) => {
      dragObj = item
      const nodes = query.getNodes()
      console.log(dragObj, dropToGap, node.pos, dropPosition)
      if (!dropToGap) {
        loop(data, dropKey, (item) => {
          item.children = item.children || []
          const parent = nodes[item.key]
          if (parent && parent.data.isCanvas) {
            actions.move(dragObj.key, item.key, item.children.length)
          }
        })
      } else if (dropPosition === 1 && node.children && node.expanded) {
        loop(data, dropKey, (item) => {
          item.children = item.children || []
          const parent = nodes[item.key]
          if (parent && parent.data.isCanvas) {
            actions.move(dragObj.key, item.key, 0)
          }
        })
      } else {
        let dropNodeInd
        const node: Node = nodes[dropKey]
        if (node) {
          const parentID = node.data.parent
          loop(data, dropKey, (item, ind) => {
            dropNodeInd = ind
            if (parentID) {
              actions.move(
                dragObj.key,
                parentID,
                dropPosition === -1 ? dropNodeInd : dropNodeInd + 1
              )
            }
          })
        }
      }
    })
  }

  return (
    <Tree
      treeData={[transformData(designerStore.pageData)]}
      value={{
        key: designerStore.activeComponent?.componentInfo.id || ''
      }}
      defaultExpandAll={true}
      expandAll={true}
      draggable
      onDrop={onDrop}
      labelEllipsis={true}
      onChangeWithObject={true}
      onChange={handleChange}
    />
  )
})

export default Layer
