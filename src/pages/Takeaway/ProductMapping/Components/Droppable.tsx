import React from "react";
import { useDroppable } from "@dnd-kit/core";

export function Droppable(props: any) {
  const { isOver, setNodeRef } = useDroppable({
    id: props.id,
  });
  const style = {
    backgroundColor: isOver ? "#999999" : undefined,
  };

  return (
    <div ref={setNodeRef} className={`${isOver ? "drop-active" : ""}`}>
      {props.children}
    </div>
  );
}
