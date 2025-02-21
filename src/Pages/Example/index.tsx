import {
  EditorProvider,
  CanvasFrame,
  useActions,
  Element,
  useEditor,
  PropertyPanel,
  SidebarMenuList,
  Layer,
  Zoom,
  ComponentHelper,
  UndoRedo
} from '@/Library'

import { RenderNode } from './RenderNode'
import { ComponentWrapper } from './ComponentWrapper'

import { Button } from '@douyinfe/semi-ui'
import { registerBasicComponents } from './RegisterComponents'

export const ExamplePage = () => {
  ComponentHelper.setComponentWrapper(ComponentWrapper)
  registerBasicComponents(ComponentHelper)

  return (
    <div className="flex w-full h-full flex-col">
      <EditorProvider
        defaultEnabled
        RenderNode={RenderNode}
        componentWrapper={ComponentWrapper}
        resolver={ComponentHelper.getComponents()}>
        <PageContent></PageContent>
      </EditorProvider>
    </div>
  )
}

const Header = () => {
  const { togglePreview } = useActions()
  const { enabled } = useEditor((state) => ({ enabled: state.options.enabled }))
  return (
    <div className="flex border-b p-2">
      <div className="flex-grow">
        <div className="pl-5 text-2xl font-bold font-mono">[LOGO]</div>
      </div>
      <div className="flex space-x-2">
        {enabled ? <UndoRedo></UndoRedo> : <></>}
        <Button onClick={togglePreview}>Toggle Preview</Button>
      </div>
    </div>
  )
}

const Sidebar = () => {
  const { enabled } = useEditor((state) => ({ enabled: state.options.enabled }))
  return (
    <>
      {enabled ? (
        <div className="w-[300px] shrink-0 h-full bg-green-100">
          <SidebarMenuList
            prop={[
              {
                type: 'Container',
                prop: {
                  layout: {
                    width: '100%',
                    height: '300px'
                  }
                }
              },
              {
                type: 'AbsoluteElement',
                prop: {
                  layout: {
                    width: '200px',
                    height: '200px'
                  }
                }
              }
            ]}></SidebarMenuList>
          <SidebarMenuList
            prop={[
              { type: 'QRCode' },
              { type: 'Button' },
              { type: 'Input' },
              { type: 'Tag' },
              { type: 'Badge' }
            ]}></SidebarMenuList>
          <Layer></Layer>
        </div>
      ) : (
        <></>
      )}
    </>
  )
}

const RightPanel = () => {
  const { enabled } = useEditor((state) => ({ enabled: state.options.enabled }))
  return <>{enabled ? <PropertyPanel></PropertyPanel> : <></>}</>
}

const CenterCanvas = () => {
  return (
    <div className="flex-grow w-full h-full overflow-hidden group/canvas bg-blue-100 border-l border-blue-300 relative">
      <div className="absolute top-2 left-2 flex bg-white border rounded p-1 z-10 items-center transition-opacity opacity-0 group-hover/canvas:opacity-100">
        <Zoom></Zoom>
      </div>
      <CanvasFrame className="p-4" size={{ width: 800, height: 800 }}>
        <Element
          canvas
          is={ComponentHelper.components['Container']}
          layout={{ width: '100%', height: '100%', direction: 'column' }}
          style={{ background: 'transparent' }}
          custom={{ displayName: 'Page' }}></Element>
      </CanvasFrame>
    </div>
  )
}

const PageContent = () => {
  return (
    <>
      <Header></Header>
      <div className="flex w-full h-full overflow-hidden">
        <Sidebar></Sidebar>
        <CenterCanvas></CenterCanvas>
        <RightPanel></RightPanel>
      </div>
    </>
  )
}

export default ExamplePage
