/**
 * @name ImageCode
 * @desc 滑动拼图验证
 * @author darcrand
 * @version 2019-02-26
 *
 * @param {String} bigImgUrl 图片的路径
 * @param {Number} imageWidth 展示图片的宽带
 * @param {Number} imageHeight 展示图片的高带
 * @param {Number} fragmentSize 滑动图片的尺寸
 * @param {Function} onReload 当点击'重新验证'时执行的函数
 * @param {Function} onMath 匹配成功时执行的函数
 * @param {Function} onError 匹配失败时执行的函数
 */
import React, { PureComponent } from "react";
import "../css/ImageCode.less";
import AuthService from "../../../services/auth/AuthService";

const icoSuccess = require("../../../assets/images/img-code/success-icon.png").default;
const icoError = require("../../../assets/images/img-code/error-icon.png").default;
const icoReload = require("../../../assets/images/img-code/reload-icon.png").default;
const icoSlider = require("../../../assets/images/img-code/slider-icon.png").default;

const STATUS_LOADING = 0; // 还没有图片
const STATUS_READY = 1; // 图片渲染完成,可以开始滑动
const STATUS_MATCH = 2; // 图片位置匹配成功
const STATUS_ERROR = 3; // 图片位置匹配失败

const arrTips = [{ ico: icoSuccess, text: "匹配成功" }, { ico: icoError, text: "匹配失败" }];

class ImageCode extends PureComponent {
  // eslint-disable-next-line react/static-property-placement
  static defaultProps = {
    bigImgUrl: "",
    smallImgUrl: "",
    yHeight: 0,
    xWidth: 0,
    imageWidth: 260,
    imageHeight: 160,
    fragmentSize: 50,
    onReload: () => {},
    onMatch: () => {},
    onError: () => {}
  };

  state = {
    isMovable: false,
    offsetX: 0, // 图片截取的x
    offsetY: 0, // 图片截ß取的y
    startX: 0, // 开始滑动的 x
    oldX: 0,
    currX: 0, // 滑块当前 x,
    status: STATUS_LOADING,
    showTips: false,
    tipsIndex: 0,
    bigImgUrl: "",
    smallImgUrl: ""
  };

  componentDidMount() {
    this.renderImage();
  }

  renderImage = () => {
    // 初始化状态
    this.setState({ status: STATUS_LOADING });
    AuthService.getCheckCodeImg({}).then(res => {
      if (res.code !== "000") return false;
      const { bigImage, smallImage, yHeight } = res.result;
      this.setState({
        bigImgUrl: `data:image/jpeg;base64,${bigImage}`,
        smallImgUrl: `data:image/jpeg;base64,${smallImage}`,
        offsetX: 0,
        offsetY: yHeight
      });
    });
    this.setState({ status: STATUS_READY });
  };

  checkImgFun = cb => {
    const param = { width: this.state.currX };
    AuthService.checkImg(param).then(res => {
      const { code, result } = res;
      this.setState({ status: code === "000" ? STATUS_MATCH : STATUS_ERROR });
      cb(result);
    });
  };

  onMoveStart = e => {
    // ------------可能有用，不该注释
    if (this.state.status !== STATUS_READY) {
      return;
    }

    // 记录滑动开始时的绝对坐标x
    this.setState({ isMovable: true, startX: e.clientX });
  };

  onMoving = e => {
    const { status, isMovable, startX, oldX } = this.state;
    if (status !== STATUS_READY || !isMovable) {
      return;
    }
    const distance = e.clientX - startX;
    let currX = oldX + distance;

    const minX = 0;
    const maxX = this.props.imageWidth - this.props.fragmentSize;
    currX = currX < minX ? 0 : currX > maxX ? maxX : currX;
    this.setState({ currX, offsetX: currX });
  };

  onMoveEnd = () => {
    if (this.state.status !== STATUS_READY || !this.state.isMovable) {
      return;
    }
    // 将旧的固定坐标x更新
    this.setState(pre => ({ isMovable: false, oldX: pre.currX }));
    this.checkImgFun(data => {
      const { status } = this.state;
      if (status === STATUS_MATCH) {
        this.props.onMatch(data);
        this.onReset();
      } else this.onReset();
      this.onShowTips();
    });
  };

  onReset = () => {
    const timer = setTimeout(() => {
      this.setState({
        isMovable: false,
        offsetX: 0,
        // offsetY: 0,
        startX: 0, // 开始滑动的 x
        oldX: 0,
        currX: 0, // 滑块当前 x,
        status: STATUS_LOADING
      });
      this.renderImage();
      clearTimeout(timer);
    }, 1);
  };

  onShowTips = () => {
    const { showTips, status } = this.state;
    if (showTips) {
      return;
    }

    const tipsIndex = status === STATUS_MATCH ? 0 : 1;
    this.setState({ showTips: true, tipsIndex });
    const timer = setTimeout(() => {
      this.setState({ showTips: false });
      clearTimeout(timer);
    }, 2000);
  };

  render() {
    const { bigImgUrl, smallImgUrl } = this.state;
    const { imageWidth, imageHeight } = this.props;
    const { offsetX, offsetY, currX, showTips, tipsIndex } = this.state;
    const tips = arrTips[tipsIndex];

    return (
      <div className="image-code" style={{ width: imageWidth }}>
        <div
          className="image-container"
          style={{
            height: imageHeight,
            backgroundImage: `url("${bigImgUrl}")`
          }}
        >
          <img src={smallImgUrl} alt="" style={{ position: "absolute", left: `${offsetX}px`, top: `${offsetY}px` }} />
          <div className={showTips ? "tips-container--active" : "tips-container"}>
            <i className="tips-ico" style={{ backgroundImage: `url("${tips.ico}")` }} />
            <span className="tips-text">{tips.text}</span>
          </div>
        </div>

        <div className="reload-container">
          <div className="reload-wrapper" onClick={this.onReset}>
            <i className="reload-ico" style={{ backgroundImage: `url("${icoReload}")` }} />
            <span className="reload-tips">刷新验证</span>
          </div>
        </div>

        <div className="slider-wrpper" onMouseMove={this.onMoving} onMouseLeave={this.onMoveEnd}>
          <div className="slider-bar">按住滑块，拖动完成拼图</div>
          <div
            className="slider-button"
            onMouseDown={this.onMoveStart}
            onMouseUp={this.onMoveEnd}
            style={{ left: `${currX}px`, backgroundImage: `url("${icoSlider}")` }}
          />
        </div>
      </div>
    );
  }
}

export default ImageCode;
