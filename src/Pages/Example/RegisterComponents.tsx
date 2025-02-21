import { ComponentHelper } from '@/Library'

import { QRCode, Button, Input, Tag, Badge } from '@/Components/Designer/Sidebar/Components/index'
import {
  QRCode as QRCodeSchema,
  Button as ButtonSchema,
  Input as InputSchema,
  Tag as TagSchema,
  Badge as BadgeSchema
} from '@/Components/Designer/Sidebar/Components/SchemaIndex'
import { AbsoluteElement, AbsoluteElementSchema } from './AbsoluteElement'
import { Container, ContainerSchema, ContainerCraft } from './Container'

export const registerBasicComponents = (ch: typeof ComponentHelper) => {
  ch.register(Container, ContainerSchema, ContainerCraft)
  ch.register(
    Container,
    Object.assign({}, ContainerSchema, { basic: { type: 'Page' } }),
    ContainerCraft
  )
  ch.register(AbsoluteElement, AbsoluteElementSchema)
  ch.register(QRCode, QRCodeSchema)
  ch.register(Button, ButtonSchema)
  ch.register(Input, InputSchema)
  ch.register(Tag, TagSchema)
  ch.register(Badge, BadgeSchema)
}
