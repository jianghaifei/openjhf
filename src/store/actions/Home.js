// import { SET_OPEN_RAGE_ANIMATION_STATUS, SET_RESOURCE_ID } from "../Constant";
import { SET_OPEN_RAGE_ANIMATION_STATUS } from "../Constant";
// import IndexService from "../../services/IndexService";

// const setResourceIdData = payload => ({
//   type: SET_RESOURCE_ID,
//   payload
// });
export const setOpenRageAnimationStatus = payload => ({
  type: SET_OPEN_RAGE_ANIMATION_STATUS,
  payload
});
export const getResourceIdData = () => {
  // return dispatch => {
  //   IndexService.getIndexData().then(res => {
  //     const {
  //       result: { showDataList = [] }
  //     } = res;
  //     const resourceIdMap = {};
  //     showDataList.map(item => {
  //       resourceIdMap[item.name] = item.parentId;
  //     });
  //     dispatch(setResourceIdData(resourceIdMap));
  //   });
  // };
  return {};
};
