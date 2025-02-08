// 拖拽排序
import React, { ReactNode } from "react";
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragEndEvent,
  MouseSensor,
} from "@dnd-kit/core";
import { AppstoreOutlined } from "@ant-design/icons";
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { ReactComponent as SortSvg } from "../../assets/Sort.svg";

export const SortListDndKit = ({
  list = [],
  idKey = "id",
  children,
  onDragEnd,
  disabled = false,
}) => {
  // 指定传感器，默认是全部
  const sensors = useSensors(
    // useSensor(PointerSensor),
    useSensor(MouseSensor, {
      activationConstraint: {
        distance: 5,
      },
    })
  );
  // 拖拽结束
  const handleDragEnd = (event) => {
    const { active, over } = event;
    if (active.id !== over?.id) {
      const oldIndex = list.findIndex((item) => item[idKey] === active.id);
      const newIndex = list.findIndex((item) => item[idKey] === over?.id);
      const ids = list.map((item) => item[idKey]);
      [ids[newIndex], ids[oldIndex]] = [ids[oldIndex], ids[newIndex]];
      const _val = arrayMove(list, oldIndex, newIndex);
      onDragEnd(_val, ids);
    }
  };

  return (
    <DndContext
      sensors={sensors}
      autoScroll={false}
      collisionDetection={closestCenter}
      onDragEnd={handleDragEnd}
    >
      <SortableContext disabled={disabled} items={list.map((item) => item[idKey])}>
        {children}
      </SortableContext>
    </DndContext>
  );
};

/**
 * 列表排序的子项
 * - 函数式组件作为children，需要用html元素包裹住
 * - 例：
 * - \<SortItemDndKit>
 * -   \<div>\<Text title='测试组件' />\</div>
 * - \</SortItemDndKit>
 */
export const SortItemDndKit = ({ id, children }) => {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    setActivatorNodeRef,
  } = useSortable({ id });
  const style = {
    transform: CSS.Transform.toString(transform),
    zIndex: 2,
    transition,
  };

  const newChild = React.Children.map(children, (child) => {
    if (!React.isValidElement(child)) {
      return null;
    }
    const childProps = {
      ...child.props,
      ref: setNodeRef,
      style,
      ...attributes,
      className: "dnd-drag-item relative",
    };
    return (
      <div {...childProps}>
        <div
          style={{
            cursor: "pointer",
            position: "absolute",
            left: -8,
            top: "50%",
            marginTop: -16,
          }}
          ref={setActivatorNodeRef}
          {...listeners}
        >
          <SortSvg />
        </div>

        <div className="pl-[25px]">{child}</div>
      </div>
    );
    // return React.cloneElement(child, childProps);
  });
  return <>{newChild}</>;
};
