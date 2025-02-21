import { Button, ButtonGroup, Divider, Tooltip } from '@douyinfe/semi-ui'
import { ReactComponent as ZoomInSVG } from '@/assets/Toolbar/zoom-in.svg'
import { ReactComponent as ZoomOutSVG } from '@/assets/Toolbar/zoom-out.svg'
import { ReactComponent as AspectRatioSVG } from '@/assets/Toolbar/aspect-ratio.svg'
import { ReactComponent as SkewSVG } from '@/assets/Toolbar/stack.svg'
import { ReactComponent as SpaceSVG } from '@/assets/Toolbar/Space.svg'
import { ReactComponent as ArtboardSVG } from '@/assets/Toolbar/Artboard.svg'
import { useEditor } from '@/Components/Designer/Layout/core'

export const Zoom = () => {
  const {
    scale,
    skew,
    gap,
    outline,
    enabled,
    actions: { setOptions }
  } = useEditor((state) => {
    return {
      scale: state.options.scale,
      skew: state.options.skew,
      gap: state.options.gap,
      outline: state.options.outline,
      enabled: state.options.enabled
    }
  })

  const zoomBy = (rate: number) => {
    return function () {
      const newScale: number = scale * rate
      setOptions((options) => {
        options.scale = newScale
      })
    }
  }

  const toggleSkew = () => {
    setOptions((options) => {
      options.skew = !skew
    })
  }
  const toggleGap = () => {
    setOptions((options) => {
      options.gap = !gap
    })
  }

  const toggleOutline = () => {
    setOptions((options) => {
      options.outline = !outline
    })
  }

  const zoomToFit = () => {
    if (scale === 1) {
      return function () {
        window.dispatchEvent(new Event('resize'))
      }
    } else {
      return function () {
        const newScale = 1
        setOptions((optioins) => {
          optioins.scale = newScale
        })
      }
    }
  }

  return (
    <>
      <Tooltip content={'Layers Stack View'}>
        <Button
          className="text-white"
          onClick={toggleSkew}
          theme={skew ? 'solid' : 'borderless'}
          icon={<SkewSVG width={18}></SkewSVG>}></Button>
      </Tooltip>

      <Divider margin={'12px'} layout="vertical" />

      <ButtonGroup>
        <Tooltip content={'Zoom Out'}>
          <Button
            className="text-white mr-1"
            onClick={zoomBy(0.91)}
            icon={<ZoomOutSVG width={18}></ZoomOutSVG>}></Button>
        </Tooltip>
        <Tooltip content={'Zoom In'}>
          <Button
            className="text-white mr-1"
            onClick={zoomBy(1.1)}
            icon={<ZoomInSVG width={18}></ZoomInSVG>}></Button>
        </Tooltip>
        <Tooltip content={'Fit Container / Original'}>
          <Button
            className="text-white"
            onClick={zoomToFit()}
            icon={<AspectRatioSVG width={18}></AspectRatioSVG>}></Button>
        </Tooltip>
      </ButtonGroup>

      {enabled && (
        <>
          <Divider margin={'12px'} layout="vertical" />
          <Tooltip content={'Line indicator'}>
            <Button
              className="text-white"
              onClick={toggleOutline}
              theme={outline ? 'solid' : 'borderless'}
              type="primary"
              icon={<ArtboardSVG width={18}></ArtboardSVG>}></Button>
          </Tooltip>
          <Tooltip content={'Container Space Gap'}>
            <Button
              className="text-white ml-2"
              onClick={toggleGap}
              theme={gap ? 'solid' : 'borderless'}
              icon={<SpaceSVG width={18}></SpaceSVG>}></Button>
          </Tooltip>
        </>
      )}
    </>
  )
}
