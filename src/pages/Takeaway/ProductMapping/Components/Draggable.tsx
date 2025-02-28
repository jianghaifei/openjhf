import React from "react";
import { useDraggable } from "@dnd-kit/core";

export function Draggable(props: any) {
  const { attributes, listeners, setNodeRef, transform } = useDraggable({
    id: props.id,
  });
  const style: any = transform
    ? {
        // transform: `translate3d(${transform.x}px, ${transform.y}px, 9999px)`,
        // left: `${transform.x}px`,
        // top: `${transform.y}px`,
        // "position": "absolute",
        // zIndex: 9999,
        opacity: 0.1,
      }
    : {
        cursor: "move",
      };
  return (
    <div
      ref={setNodeRef}
      id={`drag${props.id}`}
      data-x={transform?.x}
      data-y={transform?.y}
      style={style}
      {...listeners}
      {...attributes}
    >
      <div>{props.children}</div>
    </div>
  );
}
