import StoreBinding from "./StoreBinding/List.json";
import ProductMapping from "./ProductMapping/List.json";
import ProductMappingRecord from "./ProductMapping/Record.json";
import AggregateManagement from "./AggregateManagement/index.json";

export enum pageKeys {
  StoreBinding = "StoreBinding",
  ProductMapping = "ProductMapping",
  ProductMappingRecord = "ProductMappingRecord",
  AggregateManagement = "AggregateManagement",
}

export const pageMetas = {
  [pageKeys.StoreBinding]: StoreBinding,
  [pageKeys.ProductMapping]: ProductMapping,
  [pageKeys.ProductMappingRecord]: ProductMappingRecord,
  [pageKeys.AggregateManagement]: AggregateManagement,
};
