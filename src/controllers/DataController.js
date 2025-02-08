export default class DataController {
  constructor(config = {}) {
    this.timer = null;
    this.speed = 1000; // 累加速度
    this.isInteger = Number.isInteger(config.count);
    this.step = this.isInteger ? 1 : 0.1; // 每次增加的步长
    this.count = config.count;
    this.setTimerSpeed();
  }

  // 计算传入的数字需要的速度和步长
  setTimerSpeed() {
    const minSpeed = 20;
    const maxTime = 2000;
    // 总共需要累加的次数
    const countTimes = this.isInteger ? this.count : this.count / 0.1;
    // 当前累加次数在指定时间内需要的累加速度
    const currentSpeed = maxTime / countTimes;
    // 能否在最快速度内完成
    const canIEnd = currentSpeed >= minSpeed;
    // 如果能完成直接赋值速度即可
    if (canIEnd) this.speed = currentSpeed;
    // 如果完不成的话速度设置为最快 增加每次累加的步长来保证在指定时间内完成 默认步长为1
    else {
      this.speed = minSpeed;
      // 默认计算出来的值是以步长为1的情况下 如果是小数类的需要*0.1 以0.1步来执行
      const integerStep = countTimes / (maxTime / minSpeed);
      this.step = this.isInteger ? integerStep : integerStep * 0.1;
    }
  }

  createTimer(cb) {
    // 一个实例只能创建一个timer 如果创建过就不执行
    if (this.timer) {
      return false;
    }
    let countTemp = 0;
    this.timer = setInterval(() => {
      countTemp += this.step;
      // 整数返回整数 小数返回2位小数
      cb(this.isInteger ? Math.ceil(countTemp) : Number(countTemp.toFixed(1)));
      if (countTemp >= this.count) {
        cb(this.count);
        this.clearTimer();
      }
    }, this.speed);
  }

  clearTimer() {
    clearInterval(this.timer);
  }
}
