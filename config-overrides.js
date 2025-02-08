const { override, fixBabelImports, addLessLoader, adjustStyleLoaders } = require("customize-cra");
const path = require("path");

module.exports = override(
  // antd 按需加载
  fixBabelImports("import", {
    libraryName: "antd",
    style: true
  }),
  addLessLoader({
    javascriptEnabled: true,
    modifyVars: {
      "@primary-color": "#4340f4", // 设置主要按钮文本颜色
      // ...其他需要自定义的颜色变量
    }
  }),
  // 修改 less 配置
  adjustStyleLoaders(item => {
    if (item.test.toString().includes("less")) {
      item.use.push({
        loader: "style-resources-loader",
        options: {
          patterns: path.resolve(__dirname, "src/assets/global.less")
        }
      });
    }
  }),
  // 添加 Source Map 配置
  (config, context) => {
    const env = process.env;
    const isProd = env === "production";
    config.devtool = isProd ? "source-map" : "eval-source-map";

    return config;
  }
);
