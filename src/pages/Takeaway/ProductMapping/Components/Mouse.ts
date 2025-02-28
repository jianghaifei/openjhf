export default class Mouse {
  constructor() {
    this.x = 0;
    this.y = 0;
    this.delta = {
      x: 0,
      y: 0,
    };
    this._down = (event: any) => {
      this.onMouseDown.bind(this)(event);
    };
    this._move = (event: any) => {
      this.onMouseMove.bind(this)(event);
    };
    window.addEventListener("mousedown", this._down);
    window.addEventListener("mousemove", this._move);
  }
  onMouseDown(evt: any) {
    this.x = evt.clientX;
    this.y = evt.clientY;
  }

  onMouseMove(evt: any): void {
    this.delta = {
      x: evt.clientX - this.x,
      y: evt.clientY - this.y,
    };
  }

  destory() {
    window.removeEventListener("mousedown", this._down);
    window.removeEventListener("mousemove", this._move);
  }

  _down;
  _move;
  delta = {};
  x = 0;
  y = 0;
}
