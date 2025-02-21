import { Frame, ROOT_NODE, useEditor } from '@/Components/Designer/Layout/core'
import { PropsWithChildren, useCallback, useContext, useEffect, useRef, useState } from 'react'
import StoreContext from '@/Store/storeContext.ts'

import '../canvas.css'
import classNames from 'classnames'

const CONTAINER_PADDING = 0 //16

interface CanvasSize {
  width: string | number
  height: string | number
}
interface Prop {
  className?: string
  size?: CanvasSize
}

export const CanvasFrame = (prop: PropsWithChildren<Prop>) => {
  const { designerStore } = useContext(StoreContext)
  const originElem = useRef<HTMLDivElement | null>()
  const {
    scale,
    active,
    query,
    store,
    skew,
    actions: { setOptions }
  } = useEditor((state, query) => {
    return {
      scale: state.options.scale,
      skew: state.options.skew,
      active: query.getEvent('selected').first()
    }
  })

  const [size, setSize] = useState<CanvasSize>({
    width: 1920,
    height: 1080
  })

  // const size =

  useEffect(() => {
    if (prop.size) {
      setSize(prop.size)
    }
  }, [prop.size])

  const skewStyle = skew
    ? {
        transform: 'rotate(-30deg) skew(25deg) scale(0.7)'
      }
    : {}

  const mouseLeaveHandler = useCallback(() => {
    const node = query.node(ROOT_NODE)
    if (node.isHovered()) {
      store.actions.setNodeEvent('hovered', null)
    }
  }, [query, store.actions])

  useEffect(() => {
    const pageContainer = window.document.querySelector('.page-container')
    pageContainer?.addEventListener('mouseleave', mouseLeaveHandler)
    return function () {
      pageContainer?.removeEventListener('mouseleave', mouseLeaveHandler)
    }
  }, [mouseLeaveHandler])

  // const [zoom, setZoom] = useState('1')
  const [transformOrigin, setTransformOrigin] = useState('center')
  const [alignJustifyCN, setAlignJustifyCN] = useState('')

  const updateTransform = useCallback(
    (scale: number) => {
      console.log('update transform!')
      const containerWrapper = document.querySelector('.page-container-wrapper')
      const overflowWrapper = containerWrapper?.parentElement
      let widthOverflow = false
      let heightOverflow = false
      const originClientWidth = originElem.current?.clientWidth
      const originClientHeight = originElem.current?.clientHeight
      if (originClientHeight && originClientWidth) {
        const contentWidth = Math.ceil(scale * originClientWidth) + CONTAINER_PADDING
        if (overflowWrapper && overflowWrapper?.offsetWidth < contentWidth) {
          widthOverflow = true
        }
        const contentHeight = Math.ceil(scale * originClientHeight) + CONTAINER_PADDING
        if (overflowWrapper && overflowWrapper.offsetHeight < contentHeight) {
          heightOverflow = true
        }
      }
      setTransformOrigin(
        `${widthOverflow ? 'left' : 'center'} ${heightOverflow ? 'top' : 'center'}`
      )
      setAlignJustifyCN(
        `${widthOverflow ? 'justify-start' : 'justify-center'} ${
          heightOverflow ? 'items-start' : 'items-center'
        }`
      )
      console.log('updateTransform:', scale)
    },
    [originElem]
  )

  const updateZoom = useCallback(() => {
    console.log('zoom!', originElem)
    const containerWrapper = document.querySelector('.page-container-wrapper')
    const rect = containerWrapper?.getBoundingClientRect()
    const originClientWidth = originElem.current?.clientWidth
    const originClientHeight = originElem.current?.clientHeight
    const width = rect?.width
    const height = rect?.height
    if (width && height && originClientHeight && originClientWidth) {
      const ratio = Math.min(width / originClientWidth, height / originClientHeight, 1)
      setOptions((options) => {
        options.scale = ratio
      })
    }

    console.log('updateZoom:', scale, originClientHeight, originClientWidth)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [originElem])

  useEffect(() => {
    updateTransform(scale)
  }, [scale, updateTransform])

  useEffect(() => {
    if (active) {
      const _activeModel = designerStore.pageModel?.getComponentByID(active)
      if (_activeModel) {
        designerStore.setActiveComponent(_activeModel)
      }
    }
  }, [active, designerStore])

  useEffect(() => {
    window.setTimeout(() => {
      updateZoom()
      updateTransform(scale)
    }, 10)
    window.addEventListener('resize', updateZoom)
    return function () {
      window.removeEventListener('resize', updateZoom)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  return (
    <div className={classNames('flex w-full h-full overflow-auto', prop.className)}>
      <div
        style={skewStyle}
        className={`flex w-full h-full page-container-wrapper relative transition ${alignJustifyCN}`}>
        <div
          ref={(ref) => {
            originElem.current = ref
          }}
          className="w-full flex-shrink-0 flex-grow-0 ease-linear flex transition page-container"
          style={{
            minWidth: '300px',
            minHeight: '300px',
            width: typeof size.width === 'number' ? `${size.width}px` : size.width,
            height: typeof size.height === 'number' ? `${size.height}px` : size.height,
            transform: `scale(${scale.toFixed(4)}, ${scale.toFixed(4)})`,
            transformOrigin
          }}>
          <div className="craftjs-renderer flex w-full h-auto border shadow-sm">
            <Frame>{prop.children}</Frame>
          </div>
        </div>
      </div>
    </div>
  )
}
