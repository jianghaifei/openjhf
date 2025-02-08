const { createProxyMiddleware } = require("http-proxy-middleware");

module.exports = function(app) {
  app.use(
    "/bomenu", // 这里 '/api' 是你想要代理的路径
    createProxyMiddleware({
      target: "http://openapi-platform.dev.restosuite.ai", // 这里是你后端服务的地址
      changeOrigin: true, // 用于改变请求头中的 Origin
      pathRewrite: {
        "^/bomenu": "" // 重写路径，去掉 '/api' 前缀
      }
    })
  );
  app.use(
    "/boshop", // 这里 '/api' 是你想要代理的路径
    createProxyMiddleware({
      target: "https://bo.test.restosuite.ai", // 这里是你后端服务的地址
      changeOrigin: true, // 用于改变请求头中的 Origin
      pathRewrite: {
        "^/boshop": "" // 重写路径，去掉 '/api' 前缀
      }
    })
  );
};
