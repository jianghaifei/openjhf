/* eslint-disable @typescript-eslint/restrict-plus-operands */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { AnyFunc, IEmitter } from "../Model/IEmitter";

interface ListenerConfig {
  id: string;
  listener: AnyFunc;
  once: boolean;
  thisObj?: any;
  extraArgs?: any[];
}

function genEmitterID() {
  return 'e' + Date.now() + Math.random() * 1000;
}


export default class Emitter implements IEmitter {
  private map: { [event: string]: ListenerConfig[] } = {};

  private listenerConfigsForEvent(event: string) {
    let listeners = this.map[event];
    if (!listeners) {
      listeners = [];
      this.map[event] = listeners;
    }
    return listeners;
  }

  /**
   * @return An string that can pass to `off` later to remove related listener
   */
  public on(event: string, listener: AnyFunc, thisObj?: any, ...extraArgs: any[]) {
    const lscfgs = this.listenerConfigsForEvent(event);
    const eId = genEmitterID();
    lscfgs.push({
      id: eId,
      listener,
      once: false,
      thisObj,
      extraArgs,
    });
    return eId;
  }

  /**
   * @return An string that can pass to `off` later to remove related listener
   */
  public once(event: string, listener: AnyFunc, thisObj?: any, ...extraArgs: any[]) {
    const lscfgs = this.listenerConfigsForEvent(event);
    const eId = genEmitterID();
    lscfgs.push({
      id: eId,
      listener,
      once: true,
      thisObj,
      extraArgs,
    });
    return eId;
  }

  /**
   * @param listenerOrId A listener function, or the string that previously retured from `on/once`
   */
  public off(event: string, listenerOrId: AnyFunc | string) {
    const lscfgs = this.listenerConfigsForEvent(event);
    let foundIdx = -1;
    const found = lscfgs.some((lscfg, idx) => {
      if (listenerOrId === lscfg.listener || listenerOrId === lscfg.id) {
        foundIdx = idx;
        return true;
      }
      return false;
    });
    if (found) {
      lscfgs.splice(foundIdx, 1);
    }
  }

  public offAll(event: string) {
    const lscfgs = this.listenerConfigsForEvent(event);
    lscfgs.splice(0, lscfgs.length);
  }

  public emit(event: string, ...args: any[]) {
    const lscfgs = this.listenerConfigsForEvent(event);
    const toRemoveIdxes: number[] = [];
    lscfgs.forEach((lscfg, idx) => {
      const allArgs = (args || []).concat(lscfg.extraArgs || []);
      try {
        lscfg.listener.apply(lscfg.thisObj || null, allArgs);
      } catch (ex) {
        console.error(ex);
      }
      if (lscfg.once) {
        toRemoveIdxes.push(idx);
      }
    });
    for (let i = toRemoveIdxes.length - 1; i >= 0; i--) {
      const toRemoveIdx = toRemoveIdxes[i];
      lscfgs.splice(toRemoveIdx, 1);
    }
  }
}
