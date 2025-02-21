import { useEditor, useNode } from '@/Components/Designer/Layout/core'
import { ReactNode, useEffect } from 'react'

export const RenderNode = ({ render }: { render: ReactNode }) => {
  const { id } = useNode()

  const { isActive } = useEditor((state, query) => ({
    isActive: query.getEvent('selected').contains(id)
  }))

  const {
    isHover,
    dom,
    connectors: { drag },
    absolute
  } = useNode((node) => ({
    isHover: node.events.hovered,
    dom: node.dom,
    absolute: (node.data.custom || {}).absolute
  })) as any

  useEffect(() => {
    if (dom && !absolute) {
      if (isHover && !isActive) {
        dom.classList.add('component-hovered')
      } else if (isActive) {
        dom.classList.add('component-selected')
        dom.classList.remove('component-hovered')
      } else {
        dom.classList.remove('component-selected')
        dom.classList.remove('component-hovered')
      }
    }
  }, [absolute, dom, isActive, isHover])

  // Bind Dragging
  useEffect(() => {
    if (dom) {
      drag(dom)
    }
  }, [dom, drag])

  return <>{render}</>
}
