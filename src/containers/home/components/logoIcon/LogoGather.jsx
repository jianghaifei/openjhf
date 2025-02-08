import React from "react";
import TweenOne from "rc-tween-one";
import Ticker from "rc-tween-one/lib/ticker";

class LogoGather extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      renderFrequency: true
    };
    this.domRef = React.createRef();
    this.interval = null;
    this.gather = true;
    this.intervalTime = 30000;
    this.domRef = React.createRef();
    this.sideBoxRef = React.createRef();
  }

  componentDidMount() {
    this.dom = this.domRef.current;
    this.createPointData();
  }

  componentWillUnmount() {
    if (this.interval) {
      Ticker.clear(this.interval);
      this.interval = null;
    }
  }

  onMouseEnter = () => {
    if (!this.gather) {
      this.updateTweenData();
    }
    this.componentWillUnmount();
  };

  onMouseLeave = () => {
    if (this.gather) {
      this.updateTweenData();
    }
    this.interval = Ticker.interval(this.updateTweenData, this.intervalTime);
  };

  setDataToDom(data, w, h) {
    this.pointArray = [];
    const number = this.props.pixSize;
    for (let i = 0; i < w; i += number) {
      for (let j = 0; j < h; j += number) {
        if (data[(i + j * w) * 4 + 3] > 150) {
          this.pointArray.push({ x: i, y: j });
        }
      }
    }
    const children = [];
    this.pointArray.forEach((item, i) => {
      const r = Math.random() * this.props.pointSizeMin + this.props.pointSizeMin;
      const b = Math.random() * 0.5 + 0.2;
      children.push(
        <TweenOne className="point-wrapper" key={i} style={{ left: item.x, top: item.y }}>
          <TweenOne
            className="point"
            style={{
              width: r,
              height: r,
              opacity: b,
              backgroundColor: `rgb(${Math.round(Math.random() * 62)},59,248)`
            }}
            animation={{
              // y: (Math.random() * 2 - 1) * 10 || 5,
              // x: (Math.random() * 2 - 1) * 5 || 2.5,
              delay: Math.random() * 1000,
              repeat: -1,
              duration: 2500,
              yoyo: true,
              ease: "easeInOutQuad"
            }}
          />
        </TweenOne>
      );
    });
    this.setState(
      {
        children,
        boxAnim: { opacity: 0, type: "from", duration: 2500 }
      },
      () => {
        this.interval = Ticker.interval(this.updateTweenData, this.intervalTime);
      }
    );
  }

  createPointData = () => {
    const { w, h } = this.props;
    const canvas = document.getElementById("canvas");
    const ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, w, h);
    canvas.width = this.props.w;
    canvas.height = h;
    const img = new Image();
    img.onload = () => {
      ctx.drawImage(img, 0, 0, img.width, img.height, 0, 0, w, h);
      const data = ctx.getImageData(0, 0, w, h);
      this.setDataToDom(data.data, w, h);
      if (this.dom) {
        this.dom.removeChild(canvas);
      }
    };
    img.crossOrigin = "anonymous";
    img.src = this.props.image;
  };

  gatherData = () => {
    const newstate = this.state;
    const children = newstate.children.map(item =>
      React.cloneElement(item, {
        animation: {
          x: 0,
          y: 0,
          opacity: 1,
          scale: 1,
          delay: Math.random() * 500,
          duration: 2500,
          ease: "easeInOutQuint"
        }
      })
    );
    this.setState({ children });
  };

  disperseData = () => {
    const rect = this.dom.getBoundingClientRect();
    const sideRect = this.sideBox.getBoundingClientRect();
    const sideTop = sideRect.top - rect.top;
    const sideLeft = sideRect.left - rect.left;
    const newChildren = this.state;
    const children = newChildren.children.map(item =>
      React.cloneElement(item, {
        animation: {
          x: Math.random() * rect.width - sideLeft - item.props.style.left,
          y: Math.random() * rect.height - sideTop - item.props.style.top,
          opacity: Math.random() * 0.4 + 0.1,
          scale: Math.random() * 2.4 + 0.1,
          duration: Math.random() * 500 + 1000,
          ease: "easeInOutQuint",
        }
      })
    );

    this.setState({
      children
    });
  };

  updateTweenData = () => {
    this.dom = this.domRef.current;
    this.sideBox = this.sideBoxRef.current;
    ((this.gather && this.disperseData) || this.gatherData)();
    this.gather = !this.gather;
  };

  render() {
    return (
      <div className="logo-gather-demo-wrapper" style={{ height: "600px" }} ref={this.domRef}>
        <canvas id="canvas" style={{ display: "none" }} />
        <div className="logo-gather-box">
          <div className="right-side" ref={this.sideBoxRef} onMouseEnter={this.onMouseEnter} onMouseLeave={this.onMouseLeave}>
            <TweenOne
              animation={this.state.boxAnim}
              className="blur right-side-box"
              ref={c => {
                this.sideBoxComp = c;
              }}
            >
              {this.state.children}
            </TweenOne>
          </div>
        </div>
      </div>
    );
  }
}
export default LogoGather;
