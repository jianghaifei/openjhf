// eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
const { createProxyMiddleware } = require("http-proxy-middleware");
 
module.exports = function (app) {
    app.use(
        createProxyMiddleware(
          "/test", //遇见/api-elm前缀的请求,就会触发该代理配置
          {
            target: "http://192.168.10.171:8080/", //请求转发给谁（能返回数据的服务器地址）
            pathRewrite: { "^/test": "" },
            changeOrigin: true, //控制服务器收到的响应头中Host字段的值
            secure: false,
          }
        )
      );
};