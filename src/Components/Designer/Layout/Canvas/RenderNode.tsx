import { useNode, useEditor } from '@/Components/Designer/Layout/core'
import { ROOT_NODE } from '@/Components/Designer/Layout/utils'
import React, {
  useEffect,
  useRef,
  useCallback,
  ReactNode,
  PropsWithChildren,
  CSSProperties
} from 'react'
import ReactDOM from 'react-dom'

import { ReactComponent as ArrowUp } from '@/assets/actions/up.svg'
import { ReactComponent as Delete } from '@/assets/actions/trash.svg'
import { ReactComponent as Move } from '@/assets/actions/move.svg'

const Btn = ({
  children,
  className,
  style,
  ...props
}: PropsWithChildren<{
  className?: string
  style?: CSSProperties
  [k: string]: any
}>) => {
  return (
    <div className={className} style={style} {...props}>
      {children}
    </div>
  )
}

let containerDOM: Element | undefined | null

export const RenderNode = ({ render }: { render: ReactNode }) => {
  const { id } = useNode()

  const { actions, query, isActive, scale, enabled } = useEditor((state, query) => ({
    isActive: query.getEvent('selected').contains(id),
    scale: state.options.scale,
    enabled: state.options.enabled
  }))

  const {
    isHover,
    dom,
    name,
    moveable,
    deletable,
    connectors: { drag },
    parent
  } = useNode((node) => ({
    isHover: node.events.hovered,
    dom: node.dom,
    name: node.data.custom.displayName || node.data.displayName,
    moveable: query.node(node.id).isDraggable(),
    deletable: query.node(node.id).isDeletable(),
    parent: node.data.parent,
    props: node.data.props
  })) as any

  const currentRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (dom) {
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
  }, [dom, isActive, isHover])

  const getPos = useCallback(
    (dom: HTMLElement) => {
      if (!containerDOM) {
        containerDOM = document.querySelector('.page-container')
      }
      const offset = containerDOM?.getBoundingClientRect()
      let { top, left, bottom } = dom ? dom.getBoundingClientRect() : { top: 0, left: 0, bottom: 0 }
      if (offset) {
        top = (top - offset.top) / scale
        left = (left - offset.left) / scale
      }
      return {
        top: `${top > 0 ? top : bottom}px`,
        left: `${left}px`
      }
    },
    [scale]
  )

  const scroll = useCallback(() => {
    const { current: currentDOM } = currentRef

    if (!currentDOM) return
    const { top, left } = getPos(dom as HTMLElement)
    currentDOM.style.top = top
    currentDOM.style.left = left
  }, [dom, getPos])

  useEffect(() => {
    if (dom) {
      drag(dom)
    }
  }, [dom, drag])

  useEffect(() => {
    document.querySelector('.craftjs-renderer')?.addEventListener('scroll', scroll)

    return () => {
      document.querySelector('.craftjs-renderer')?.removeEventListener('scroll', scroll)
    }
  }, [scroll])
  return (
    <>
      {dom && enabled && (isHover || isActive)
        ? ReactDOM.createPortal(
            <div
              ref={currentRef}
              className="pb-[2px] absolute text-base -mt-[33px]"
              style={{
                left: getPos(dom).left,
                top: getPos(dom).top,
                zIndex: 10
              }}>
              <div
                className="bg-white -ml-[2px] px-2 py-1 text-gray-700 rounded-t border shadow-sm bg-primary flex items-center"
                onClick={() => {
                  actions.selectNode(id)
                }}>
                {moveable ? (
                  <div
                    className="flex cursor-move items-center"
                    ref={drag as unknown as React.RefObject<HTMLDivElement>}>
                    <h2 className="flex-1 mr-4">{name}</h2>
                    <Btn className="mr-2">
                      <Move width={16} />
                    </Btn>
                  </div>
                ) : (
                  <h2 className="flex-1 mr-4">{name}</h2>
                )}
                {id !== ROOT_NODE && (
                  <Btn
                    className="mr-2 cursor-pointer hover:text-blue-600"
                    onClick={(e: React.MouseEvent) => {
                      e.stopPropagation()
                      actions.selectNode(parent as string)
                    }}>
                    <ArrowUp width={16} />
                  </Btn>
                )}
                {deletable ? (
                  <Btn
                    className="cursor-pointer hover:text-red-600"
                    onClick={(e: React.MouseEvent) => {
                      e.stopPropagation()
                      actions.delete(id)
                    }}>
                    <Delete width={16} />
                  </Btn>
                ) : null}
              </div>
            </div>,
            document.querySelector('.page-container')!
          )
        : null}
      {render}
    </>
  )
}
