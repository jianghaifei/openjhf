import React, { useEffect, useRef } from "react";
import { Button, DatePicker, Form, Input, Select } from "antd";

const { RangePicker } = DatePicker;
const { Option } = Select;

/**
 * @description options需要传入的字段
 * @param type string 搜索项的类型
 * 	[input,select,rangePicker] 文字框 下拉框 范围日期选择框
 * @param label string 搜索项左侧显示的文字
 * @param placeholder string 提示
 * @param props object 其他的标签属性 原封不动传到标签上
 * @param key string 返回的关键字
 * @param value? any 默认显示的内容
 * @param rules? array antd form的校验规则
 * @param options? array<object> 目前是select独有的字段 下拉框的数组
 * @param labelAlias? string select label的别名
 * @param valueAlias? string select value的别名
 * 	{label,value} label 下拉框显示的文字 value 选中后返回的值
 * */
/***/
const SearchBar = props => {
  const { options = [], getInstance, onSubmit } = props;
  const formRef = useRef();
  useEffect(() => {
    if (getInstance) getInstance(formRef.current);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [getInstance]);
  const renderSelect = item => {
    const { placeholder = `请选择${item.label}`, options: itemOptions = [], props: searchProps, labelAlias, valueAlias } = item;
    const getValue = optionItem => {
      if (Array.isArray(valueAlias)) {
        let multipleValue = "";
        valueAlias.map(i => {
          if (multipleValue !== "") multipleValue += `,`;
          multipleValue += `${optionItem[i]}`;
        });
        return multipleValue;
      }
      return optionItem[valueAlias || "value"];
    };
    const newLabel = labelAlias || "label";
    return (
      <Select allowClear {...searchProps} placeholder={placeholder}>
        {itemOptions.map((optionItem, optionIndex) => {
          return (
            <Option value={getValue(optionItem)} key={optionIndex}>
              {optionItem[newLabel]}
            </Option>
          );
        })}
      </Select>
    );
  };
  const renderFormItem = item => {
    const { type, key, label, rules = [], placeholder, props: searchProps = {} } = item;
    let formItemType;
    switch (type) {
      case "input":
        formItemType = <Input allowClear {...searchProps} placeholder={placeholder || `请输入${label}`} />;
        break;
      case "rangePicker":
        formItemType = <RangePicker />;
        break;
      case "select":
        formItemType = renderSelect(item);
        break;
      default:
    }
    if (!formItemType) {
      return "";
    }
    return (
      <Form.Item name={key} key={key} label={label} rules={rules}>
        {formItemType}
      </Form.Item>
    );
  };
  const renderInitValues = () => {
    const obj = {};
    options.map(item => {
      if (item.value) obj[item.key] = item.value;
    });
    return obj;
  };
  const handleOnSubmit = values => {
    onSubmit({ ...values });
  };
  return (
    <div className="search-bar" id="searchbar">
      {options && options.length ? (
        <Form ref={formRef} layout="inline" initialValues={renderInitValues()} onFinish={handleOnSubmit}>
          {options.map(item => {
            return renderFormItem(item);
          })}
          <Button htmlType="submit" type="primary">
            查询
          </Button>
        </Form>
      ) : null}
    </div>
  );
};
export default React.memo(SearchBar);
