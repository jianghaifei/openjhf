import React, { useCallback, useEffect, useState } from "react";
import { Modal, Tag } from "antd";
import DeveloperService from "../../../services/developer/DeveloperService";

const ShopDetailModal = props => {
  const { id, onCancel, visible } = props;
  const [items, updateItems] = useState([]);
  const getItems = useCallback(() => {
    if (!id) return false;
    DeveloperService.queryAuthShops({ authId: id }).then(res => {
      const { code, result } = res;
      if (code !== "000") return false;
      updateItems(result);
    });
  }, [id]);

  useEffect(() => {
    getItems();
  }, [getItems]);

  return (
    <Modal visible={visible} getContainer={false} width={800} title="店铺详情" footer={null} onCancel={onCancel}>
      <p style={{ maxHeight: 400, overflowY: "auto" }}>
        {items.map((item, index) => (
          <Tag color="#108ee9" key={index}>
            {item.shopName}
          </Tag>
        ))}
      </p>
    </Modal>
  );
};

export default React.memo(ShopDetailModal);
