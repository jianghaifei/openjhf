import { useEditor } from '@/Components/Designer/Layout/core'
import { Button } from '@douyinfe/semi-ui'

import { ReactComponent as RedoSvg } from '@/assets/Toolbar/redo.svg'
import { ReactComponent as UndoSvg } from '@/assets/Toolbar/undo.svg'

export const UndoRedo = () => {
  const { canUndo, canRedo, actions } = useEditor((state, query) => ({
    enabled: state.options.enabled,
    canUndo: query.history.canUndo(),
    canRedo: query.history.canRedo()
  }))
  return (
    <div className="flex space-x-1">
      <Button
        icon={<UndoSvg width={16} />}
        disabled={!canUndo}
        onClick={() => actions.history.undo()}></Button>
      <Button
        icon={<RedoSvg width={16} />}
        disabled={!canRedo}
        onClick={() => actions.history.redo()}></Button>
    </div>
  )
}

export default UndoRedo
