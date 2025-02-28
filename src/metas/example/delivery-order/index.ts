const searchForm = {
  blockId: "searchForm",
  blockType: "form",
  blockName: "",
  bizObjectCode: 'DeliveryRequisitionOrder',
  maxColumns: 4,
  minColumns: 1,
  layout: 1,
  isRefWholeObject: false,
  fields: [
    { fieldType: "Text", title: "单号", fieldId: "docNo", },
  ]
}

const table = {
  blockId: "table",
  blockType: "table",
  bizObjectCode: 'DeliveryRequisitionOrder',
  blockName: " ",
  isRefWholeObject: false,
  fields: [
    { minWidth: 50, fieldType: "Text", title: "ID", fieldId: "id", },
    { minWidth: 150, fieldType: "Text", title: "单号", fieldId: "docNo", },
  ],
  tableConfig: {
    type: "table",
    selectable: true,
    columnConfig: [
      { id: 'id', minWidth: 60 },
      { id: "docNo", minWidth: 140 },
    ]
  }
}

const pageName = 'ExampleDeliveryOrder';

export default {
  pageName,
  pageId: 'Bo_' + pageName,
  pageBizObjectCodes: ['DeliveryRequisitionOrder'],
  children: [searchForm, table]
}


