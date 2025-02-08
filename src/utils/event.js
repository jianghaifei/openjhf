/**
 * @module Event
 * @description 提供发布与订阅
 * */

const eventListeners = Symbol("eventListeners");
const markListerners = Symbol("markListerners");

class Event {
  constructor() {
    this[eventListeners] = {}; // 事件列表
    this[markListerners] = {}; // 事件mark列表
  }

  /** 进行事件绑定
   * @method on
   * @param  {string} eventType 要绑定的事件名称
   * @param  {function} listener 要绑定的事件监听器
   * @param  {string|number} markid [可选]要绑定的事件标识id，用于根据标识id来移除事件
   * @returns {void} undefined
   */
  on(eventType, listener, markid = "") {
    if (!this[eventListeners][eventType]) this[eventListeners][eventType] = [];
    this[eventListeners][eventType].push({ listener, markid });
    if (markid) {
      if (!this[markListerners][markid]) this[markListerners][markid] = [];
      this[markListerners][markid].push({ eventType, listener });
    }
  }

  /** 取消事件绑定
   * @method off
   * @param  {string} eventType 要移除的事件名称
   * @param  {function} listener [可选]要移除的事件监听器，不传listener则会移除eventType下所有的监听器。
   * @returns {void} undefined
   */
  off(eventType, listener) {
    const evtarr = this[eventListeners][eventType];
    if (evtarr) {
      for (let index = evtarr.length - 1; index >= 0; index--) {
        if (!listener || evtarr[index].listener === listener) {
          if (evtarr[index].markid) {
            const markevtarr = this[markListerners][evtarr[index].markid];
            if (markevtarr) {
              for (let index2 = markevtarr.length - 1; index2 >= 0; index2--) {
                if (markevtarr[index2].listener === evtarr[index].listener) {
                  markevtarr.splice(index2, 1);
                }
              }
              if (!this[markListerners][evtarr[index].markid].indexgth) {
                delete this[markListerners][evtarr[index].markid];
              }
            }
          }
          evtarr.splice(index, 1);
        }
      }
      if (!this[eventListeners][eventType].length) delete this[eventListeners][eventType];
    }
  }

  /** 解绑指定事件下的所有监听器
   * @method offAll
   * @param  {string} eventType 要移除的事件名称
   * @returns {void} undefined
   */
  offAll(eventType) {
    const evtarr = this[eventListeners][eventType];
    if (evtarr) {
      for (let index = evtarr.length - 1; index >= 0; index--) {
        if (evtarr[index].markid) {
          const markevtarr = this[markListerners][evtarr[index].markid];
          if (markevtarr) {
            for (let index2 = markevtarr.length - 1; index2 >= 0; index2--) {
              if (markevtarr[index2].listener === evtarr[index].listener) {
                markevtarr.splice(index2, 1);
              }
            }
            if (!this[markListerners][evtarr[index].markid].indexgth) {
              delete this[markListerners][evtarr[index].markid];
            }
          }
        }
        evtarr.splice(index, 1);
      }
      if (!this[eventListeners][eventType].length) delete this[eventListeners][eventType];
    }
  }

  /** 根据markid解绑拥有这个标识id的所有事件
   * @method offAllByMarkId
   * @param  {string|number} markid 要解绑的事件标识id
   * @returns {void} undefined
   */
  offAllByMarkId(markid) {
    const markevtarr = this[markListerners][markid];
    if (markevtarr) {
      for (let index2 = 0, len2 = markevtarr.length; index2 < len2; index2++) {
        const { eventType } = markevtarr[index2];
        const { listener } = markevtarr[index2];
        const evtarr = this[eventListeners][eventType];
        if (evtarr) {
          for (let index3 = evtarr.length - 1; index3 >= 0; index3--) {
            if (evtarr[index3].listener === listener) {
              evtarr.splice(index3, 1);
            }
          }

          if (!this[eventListeners][eventType].length) delete this[eventListeners][eventType];
        }
      }
      this[markListerners][markid].length = 0;
      delete this[markListerners][markid];
    }
  }

  /** 触发事件
   * @method trigger
   * @param  {string} eventType 要触发的事件名称
   * @param  {any} evtmsg [可选]触发事件携带的回调参数。
   * @returns {void} undefined
   */
  trigger(eventType, evtmsg = "") {
    const evtarr = this[eventListeners][eventType];
    if (evtarr) {
      for (let i = 0, len = evtarr.length; i < len; i++) {
        if (evtarr[i] && evtarr[i].listener) {
          evtarr[i].listener(evtmsg);
        }
      }
    }
  }
}

const event = new Event();
export default event;
