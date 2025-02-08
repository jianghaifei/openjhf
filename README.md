# 项目启动
`npm run start`

# 项目发版
本地build完后 将build文件一起传至git提交后在island发版即可

# 修改接口环境
> 修改根目录.env.*文件的REACT_APP_API_URL
> 修改之后需要重新运行
1. 本地运行修改development
2. 打包后运行修改production

# env如何新增变量
> 新增后需要重新运行 变量才生效
1. key需要以"REACT_APP_"开头并全部大写
3. value固定类型为字符串 不需要加引号
4. 例如REACT_APP_NAME=Resto 
5. 新增后需要在/src/Config.js里添加变量

# env变量如何在页面使用
1. 确保要使用的变量在/src/Config.js里被声明
2. 在页面引入Config.js 调用相关变量即可

# 接口统一存放位置
> /src/services
