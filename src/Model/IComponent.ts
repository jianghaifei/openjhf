import { ICommonConfig } from './ICommonModel'

export interface IComponentLayout {
  i?: string
  x: number
  y: number
  w: number
  h: number
  width?: string
  height?: string
  resizable?: boolean
  static?: boolean
  canvas?: boolean
  padding?: string
  margin?: string
}

export interface IComponent<IPropType = ICommonConfig, IStyleType = ICommonConfig> {
  id: string
  type: string //bi, page, container
  name: string
  children: IComponent[] | null
  props: IPropType //{"label":"haha", "format":"horizontal"}
  layout: IComponentLayout
  style: IStyleType // {"fontSize": 12px}
}
