module.exports = {
  extends: ["airbnb", "airbnb/hooks", "plugin:prettier/recommended"],
  plugins: ["prettier"],
  parser: "babel-eslint",
  rules: {
    "no-alert": 0,
    "react/no-adjacent-inline-elements": 0,
    // 0禁止规则 1警告 2错误
    "no-unused-vars": 0,
    "no-nested-ternary": 0, // 禁止嵌套三元表达式
    "consistent-return": 0, // 函数必须有返回值
    "array-callback-return": 0, // 箭头函数必须有返回值
    "no-use-before-define": 0, // 使用的函数必须在之前创建
    "func-names": 0, // 函数需要有名称
    "no-debugger": process.env.REACT_APP_ENV === "production" ? 2 : 1,
    "no-return-assign": 0,
    "no-plusplus": 0, // 禁止使用一元操作符 ++ 和 --
    "no-unused-vars": 2, // 禁止未使用的变量
    "prefer-template": 2, // 建议使用模板文字而不是字符串连接
    "react/prop-types": 0, // props需要定义类型
    "react/state-in-constructor": 0, // state必须在constructor内
    "react/destructuring-assignment": 0, // props的值使用时必须结构赋值 不能直接this.props.xxx使用
    "react/no-array-index-key": 0, // 不能使用数组下标作为循环的key
    "react/jsx-filename-extension": 0, // js中不允许使用jsx语句
    "react/jsx-uses-vars": 2,
    "react/jsx-props-no-spreading": 0, // 不允许使用{...props}传值
    "react/jsx-one-expression-per-line": 0,
    "react/jsx-wrap-multilines": 0,
    "react-hooks/rules-of-hooks": 2,
    "react-hooks/exhaustive-deps": 1,
    "jsx-a11y/click-events-have-key-events": 0, // 强制可单击的非交互式元素至少具有一个键盘事件侦听器。
    "jsx-a11y/no-static-element-interactions": 0, // 强制具有单击处理程序的非交互式、可见元素(如<div>)使用role属性。
    "jsx-a11y/no-noninteractive-element-interactions": 0 // 不应该为非交互式元素分配鼠标或键盘事件侦听器。
  },
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 12,
    sourceType: "module"
  },
  env: {
    browser: true,
    es2021: true,
    node: true
  },
  globals: {
    JSX: "readonly",
    React: "readonly",
    NodeJS: "readonly"
  }
};
