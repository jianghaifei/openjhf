import { useEditor } from '@/Components/Designer/Layout/core'
import StoreContext from '@/Store/storeContext'
import { useContext, useEffect, useRef, useState } from 'react'
import { merge } from 'lodash'

// eslint-disable-next-line react-refresh/only-export-components
export enum CrossMetric {
  Top = 'Top',
  Right = 'Right',
  Bottom = 'Bottom',
  Left = 'Left'
}

export type CrossArc = Record<CrossMetric, string | undefined>

export const LayoutStyle = () => {
  const { designerStore } = useContext(StoreContext) // useContext(StoreContext)
  const activeComponent = designerStore.getActiveComponent()

  const {
    actions: { setProp }
  } = useEditor()

  const [padding, setPadding] = useState<string | undefined>()
  const [margin, setMargin] = useState<string | undefined>()
  const [width, setWidth] = useState<string | undefined>()
  const [height, setHeight] = useState<string | undefined>()
  const [paddingArc, setPaddingArc] = useState<CrossArc>({
    Top: undefined,
    Right: undefined,
    Bottom: undefined,
    Left: undefined
  })
  const [marginArc, setMarginArc] = useState<CrossArc>({
    Top: undefined,
    Right: undefined,
    Bottom: undefined,
    Left: undefined
  })

  useEffect(() => {
    if (!activeComponent) return
    const layout = activeComponent.componentInfo.layout
    setPadding(layout.padding)
    setMargin(layout.margin)
    setWidth(layout.width)
    setHeight(layout.height)
  }, [activeComponent])

  const stringToArc: (str: string | undefined) => CrossArc = (str: string | undefined) => {
    const splitList = (str || '').trimStart().split(' ')
    const length = splitList.length
    if (length === 0) {
      return {
        Top: undefined,
        Right: undefined,
        Bottom: undefined,
        Left: undefined
      }
    } else if (length === 1) {
      return {
        Top: splitList[0],
        Right: splitList[0],
        Bottom: splitList[0],
        Left: splitList[0]
      }
    } else if (length === 2) {
      return {
        Top: splitList[0],
        Right: splitList[1],
        Bottom: splitList[0],
        Left: splitList[1]
      }
    } else if (length === 3) {
      return {
        Top: splitList[0],
        Right: splitList[1],
        Bottom: splitList[2],
        Left: splitList[1]
      }
    } else {
      return {
        Top: splitList[0],
        Right: splitList[1],
        Bottom: splitList[2],
        Left: splitList[3]
      }
    }
  }

  useEffect(() => {
    const arc = stringToArc(padding)
    setPaddingArc(arc)
  }, [padding])

  useEffect(() => {
    const arc = stringToArc(margin)
    setMarginArc(arc)
  }, [margin])

  const updatePaddingValue = (metric: CrossMetric, value: string | undefined) => {
    const newArc = Object.assign({}, { ...paddingArc })
    newArc[metric] = value
    setPaddingArc(newArc)
    updateCraftValue(newArc, 'padding')
  }
  const updateMarginValue = (metric: CrossMetric, value: string | undefined) => {
    const newArc = Object.assign({}, { ...marginArc })
    newArc[metric] = value
    setMarginArc(newArc)
    updateCraftValue(newArc, 'margin')
  }

  const updateCraftValue = (arc: CrossArc, key: string) => {
    const activeId = activeComponent?.componentInfo.id
    if (activeId) {
      const arcToValue = `${arc.Top || 0} ${arc.Right || 0} ${arc.Bottom || 0} ${arc.Left || 0}`
      setProp(activeId, (prop) => {
        merge(prop, {
          layout: {
            [key]: arcToValue
          }
        })
      })
    }
  }

  return (
    <div className="flex w-full p-1">
      <div className="margin-rect flex flex-col w-full border border-dashed border-gray-800 p-1 bg-[#e4c482]">
        <div className="margin-top flex justify-center relative">
          <div className="absolute top-0 left-0 text-sm uppercase text-yellow-900">Margin</div>
          <SizeInput
            value={marginArc.Top}
            onChange={(value) => {
              updateMarginValue(CrossMetric.Top, value)
            }}></SizeInput>
        </div>
        <div className="flex margin-horizontal w-full">
          <div className="shrink-0 flex items-center">
            <SizeInput
              value={marginArc.Left}
              onChange={(value) => {
                updateMarginValue(CrossMetric.Left, value)
              }}></SizeInput>
          </div>
          <div className="flex-grow border border-gray-800 padding-rect p-1 m-1 bg-[#b8c480]">
            <div className="padding-top flex justify-center relative">
              <div className="absolute top-0 left-0 text-sm uppercase text-yellow-900">Padding</div>
              <SizeInput
                value={paddingArc.Top}
                onChange={(value) => {
                  updatePaddingValue(CrossMetric.Top, value)
                }}
                min={0}></SizeInput>
            </div>
            <div className="flex padding-horizontal w-full">
              <div className="shrink-0 flex items-center">
                <SizeInput
                  value={paddingArc.Left}
                  onChange={(value) => {
                    updatePaddingValue(CrossMetric.Left, value)
                  }}
                  min={0}></SizeInput>
              </div>
              <div className="flex-grow border border-gray-800 size-rect font-mono items-center justify-center flex p-2 m-1 text-sm flex-wrap bg-[#88b2bd]">
                <div className="whitespace-nowrap text-gray-800">{width || '-'}</div>
                <div className="whitespace-nowrap text-green-600">×</div>
                <div className="whitespace-nowrap text-gray-800">{height || '-'} </div>
              </div>
              <div className=" shrink-0 flex items-center">
                <SizeInput
                  value={paddingArc.Right}
                  onChange={(value) => {
                    updatePaddingValue(CrossMetric.Right, value)
                  }}
                  min={0}></SizeInput>
              </div>
            </div>
            <div className="padding-bottom flex justify-center">
              <SizeInput
                value={paddingArc.Bottom}
                onChange={(value) => {
                  updatePaddingValue(CrossMetric.Bottom, value)
                }}
                min={0}></SizeInput>
            </div>
          </div>
          <div className=" shrink-0 flex items-center">
            <SizeInput
              value={marginArc.Right}
              onChange={(value) => {
                updateMarginValue(CrossMetric.Right, value)
              }}></SizeInput>
          </div>
        </div>
        <div className="margin-bottom flex justify-center">
          <SizeInput
            value={marginArc.Bottom}
            onChange={(value) => {
              updateMarginValue(CrossMetric.Bottom, value)
            }}></SizeInput>
        </div>
      </div>
    </div>
  )
}

interface Prop {
  value?: string
  min?: number
  onChange?: (val?: string) => void
}

const SizeInput = (prop: Prop) => {
  const [value, setValue] = useState(0)
  const [text, setText] = useState('')
  const [unit, setUnit] = useState('px')
  const [editing, setEditing] = useState(false)

  const dragging = useRef<boolean>(false)
  const initialX = useRef<number>(0)
  const min = useRef<number | undefined>(undefined)

  useEffect(() => {
    min.current = prop.min
  }, [prop.min])

  useEffect(() => {
    if (typeof prop.value === 'undefined') return
    updateValue(prop.value)
  }, [prop.value])

  const updateValue = (val: string) => {
    const percentageRegex = /[0-9.]+%$/gi
    const pixelRegex = /[0-9.]+px?$/gi
    const numericRegex = /[0-9.]+$/gi
    let unit = ''
    if (percentageRegex.test(val)) {
      unit = '%'
    } else if (pixelRegex.test(val)) {
      unit = 'px'
    } else if (numericRegex.test(val)) {
      unit = ''
    } else {
      unit = ''
    }
    setUnit(unit)
    if (unit) {
      const value = parseInt(val)
      if (!isNaN(value)) {
        setValue(value)
      } else {
        setValue(0)
      }
    }
    setText(val)
  }

  const mouseMoveHandler = (e: MouseEvent) => {
    if (!dragging.current) return
    const delta = e.clientX - initialX.current
    console.log(delta, unit)
    if (!unit) {
      setUnit('px')
    }
    const newValue = value + delta
    if (typeof min.current === 'number') {
      if (min.current > newValue) return
    }
    setValue(newValue)
    setText(`${newValue}${unit}`)
  }

  const mouseUpHandler = () => {
    if (dragging.current) {
      dragging.current = false
    }
  }

  useEffect(() => {
    document.addEventListener('mousemove', mouseMoveHandler)
    document.addEventListener('mouseup', mouseUpHandler)

    return () => {
      document.removeEventListener('mousemove', mouseMoveHandler)
      document.removeEventListener('mouseup', mouseUpHandler)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const onMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
    dragging.current = true
    initialX.current = e.clientX
  }

  useEffect(() => {
    prop.onChange?.(text)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [text])

  return (
    <div
      className="inline-flex cursor-ew-resize px-1 text-gray-500 font-mono text-sm "
      onMouseDown={onMouseDown}>
      {editing ? (
        <div className="relative">
          <div className="opacity-0 px-[2px] min-w-[30px]" aria-hidden="true">
            {text || '-'}
          </div>
          <input
            value={text}
            onBlur={() => {
              setEditing(false)
            }}
            onKeyDown={(e) => {
              e.key === 'Enter' && setEditing(false)
            }}
            onChange={(e) => {
              updateValue(e.target.value)
            }}
            className="absolute left-0 top-0 block min-w-0 w-full appearance-none px-[2px]"
            type="text"
          />
        </div>
      ) : (
        <div
          className="select-none"
          onDoubleClick={() => {
            setEditing(true)
          }}>
          {text || '-'}
        </div>
      )}
    </div>
  )
}
