import React, { PureComponent } from "react";
import { connect } from "react-redux";
import { Prompt, withRouter } from "react-router-dom";
import { CheckCircleFilled } from "@ant-design/icons";
import { Form, Alert, Button, Checkbox, Col, DatePicker, Input, Modal, Radio, Row, Select } from "antd";
import moment from "moment";
import { queryRealNameInfo } from "../../store/actions/User";
import UserService from "../../services/user/UserService";
import { deepJson } from "../../utils/utils";
import ImgUpload from "../../components/general/ImgUpload";
import { setLogout, changeLoginDialogVisible } from "../../store/actions/Common";
import "./css/UserRealName.less";
import Config from "../../Config";

const { Option } = Select;
const formLayout = {
  labelCol: {
    xs: { span: 4, offset: 2 },
    sm: { span: 4, offset: 2 }
  },
  wrapperCol: {
    xs: { span: 8 },
    sm: { span: 8 }
  }
};

function endDisabledDate(current) {
  return current && current < moment().endOf("day");
}

class UserRealName extends PureComponent {
  formRef = React.createRef();

  state = {
    identityType: 1,
    promptShow: true,
    regBtnDisabled: false,
    appKey: undefined,
    modalVisible: false,
    refreshUpload: true, // 切换证件类型，调用子组件的handleRemove()后，图片还显示，需要强制rendery一下,
    isLicLongTerm: false, // 主题信息 证件有效期是否是长期，1：长期，0：普通
    isIdLongTerm: false // 法人信息 证件有效期是否是长期，1：长期，0：普通
  };

  componentDidMount() {
    const { loginId } = this.props;
    // 查询用户信息
    this.props.queryRealNameInfo({ loginId, isEncrypt: 0 }, (result = {}) => {
      const { checkStatus } = result;
      const tempResult = deepJson(result);
      if (checkStatus === 2) {
        window.addEventListener("beforeunload", this.beforeUploadGuard);
        const {
          businessLicenseStartTime,
          businessLicenseEndTime,
          idStartTime,
          idEndTime,
          businessLicensePath,
          supplyPath,
          idPhotoFrontPath,
          idPhotoBackPath,
          id,
          appKey,
          identityType,
          idBirthday
        } = tempResult;
        // 处理identityType。初始化表单显示
        this.setState(() => ({ identityType }));
        // 处理日期为moment格式
        if (businessLicenseStartTime) {
          this.setDate("businessLicenseStartTime", businessLicenseStartTime.toString());
          delete tempResult.businessLicenseStartTime;
        }
        if (businessLicenseEndTime) {
          this.setDate("businessLicenseEndTime", businessLicenseEndTime.toString());
          delete tempResult.businessLicenseEndTime;
        }
        if (idStartTime) {
          this.setDate("idStartTime", idStartTime.toString());
          delete tempResult.idStartTime;
        }
        if (idEndTime) {
          this.setDate("idEndTime", idEndTime.toString());
          delete tempResult.idEndTime;
        }
        if (idBirthday) {
          this.setDate("idBirthday", idBirthday.toString());
          delete tempResult.idBirthday;
        }
        // 处理图片地址
        this.setState({
          businessLicensePath: businessLicensePath ? Config.app.res + businessLicensePath : undefined,
          supplyPath: supplyPath ? Config.app.res + supplyPath : undefined,
          idPhotoFrontPath: idPhotoFrontPath ? Config.app.res + idPhotoFrontPath : undefined,
          idPhotoBackPath: idPhotoBackPath ? Config.app.res + idPhotoBackPath : undefined
        });
        // 处理originalId，appKey，驳回重新提交需要这两个字段
        this.setState({ originalId: id, appKey });
        this.formRef.current.setFieldsValue({ ...tempResult });
      } else if (result.checkStatus) {
        const { history } = this.props;
        history.push(`/user`);
      }
    });
  }

  componentWillUnmount() {
    window.removeEventListener("beforeunload", this.beforeUploadGuard);
  }

  beforeUploadGuard = e => {
    e.preventDefault();
    e.returnValue = "确定离开吗？";
  };

  // 表单验证相关-start
  compareToName = (rule, value, callback) => {
    const legalPersonNameVal = this.formRef.current.getFieldValue("legalPersonName");
    const { identityType } = this.state;
    if (value && legalPersonNameVal && value !== legalPersonNameVal && identityType !== 3) {
      callback("法人身份证姓名与营业执照的法人姓名不一致");
    } else {
      callback();
    }
  };

  validaToIdPhotoFrontPath = (rule, value, callback) => {
    const { identityType } = this.state;
    if (!value) {
      callback(identityType === 1 ? "请上传法人身份证正面照片!" : "请上传代理人证件正面照片!");
    } else {
      callback();
    }
  };

  validaToIdPhotoBackPath = (rule, value, callback) => {
    const { identityType } = this.state;
    if (!value) {
      callback(identityType === 1 ? "请上传法人身份证反面照片!" : "请上传代理人证件反面照片!");
    } else {
      callback();
    }
  };

  // 营业执照上传回调
  businessLicenseCallback = info => {
    const { address, person, reg_num: regNum, name, licensePath } = info;
    this.formRef.current.setFieldsValue({
      companyAddr: address,
      legalPersonName: person,
      businessLicenseRegisterNo: regNum,
      companyName: name,
      businessLicensePath: licensePath
    });
    this.setTrem("businessLicense", undefined, undefined);
  };

  // 证件正面上传回调
  idPhotoFrontCallback = info => {
    const { name, sex, address, num, facePath } = info;
    this.formRef.current.setFieldsValue({
      idName: name,
      idSex: sex === "女" ? 2 : sex === "男" ? 1 : undefined,
      idAddr: address,
      idNo: num,
      idPhotoFrontPath: facePath
    });
  };

  // 证件反面上传回调
  idPhotoBackCallback = info => {
    const { backPath } = info;
    this.formRef.current.setFieldsValue({
      idPhotoBackPath: backPath
    });
    this.setTrem("id", undefined, undefined);
  };

  // 护照上传回调
  passportCallback = info => {
    const { name, name_cn: nameCn, sex, country, birth_place: birthPlace, passport_no: passportNo, passportPath } = info;
    this.formRef.current.setFieldsValue({
      idEngName: name,
      idName: nameCn,
      idSex: sex === "女" ? 2 : sex === "男" ? 1 : undefined,
      idNationality: country,
      idNo: passportNo,
      idAddr: birthPlace,
      idPhotoFrontPath: passportPath
    });
    this.setTrem("id", undefined, undefined);
    this.setDate("idBirthday", undefined);
  };

  // 法人授权委托书回调
  supplyCallback = info => {
    this.formRef.current.setFieldsValue({
      supplyPath: info
    });
  };

  // 证件类型选择
  identityTypeChange = value => {
    this.setState({ identityType: value });
    this.identityFormItem();
  };

  // 点击下载模板，
  downClick = () => {
    // e.preventDefault();
    // downLoadMould();
    // this.setState((state, props)=>({promptShow:false}))
  };

  pickerChange = (date, dateString) => {
    const stateObj = {};
    const { activePicker } = this.state;
    stateObj[activePicker] = dateString.replace(/-/g, "");
    this.setState(stateObj);
  };

  // 处理有效期工具函数
  setTrem = (prefix, startDate, endDate) => {
    const momentObj = {};
    const stateObj = {};
    if (/^\d{8}$/.test(startDate) && /^\d{8}$/.test(endDate)) {
      momentObj[`${prefix}StartTime`] = moment(`${startDate.substring(0, 4)}/${startDate.substring(4, 6)}/${startDate.substring(4, 6)}`);
      momentObj[`${prefix}EndTime`] = moment(`${endDate.substring(0, 4)}/${endDate.substring(4, 6)}/${endDate.substring(4, 6)}`);
      stateObj[`${prefix}StartTime`] = startDate;
      stateObj[`${prefix}EndTime`] = endDate;
    } else {
      momentObj[`${prefix}StartTime`] = undefined;
      momentObj[`${prefix}EndTime`] = undefined;
      stateObj[`${prefix}StartTime`] = undefined;
      stateObj[`${prefix}EndTime`] = undefined;
    }
    this.formRef.current.setFieldsValue(momentObj);
    this.setState(stateObj);
  };

  // 处理日期工具函数
  setDate = (name, date) => {
    const momentObj = {};
    const stateObj = {};
    if (/^\d{8}$/.test(date)) {
      momentObj[name] = moment(`${date.substring(0, 4)}/${date.substring(4, 6)}/${date.substring(6, 8)}`);
      stateObj[name] = date;
    } else {
      momentObj[name] = undefined;
      stateObj[name] = undefined;
    }
    this.formRef.current.setFieldsValue(momentObj);
    this.setState(stateObj);
  };

  // 切换证件类型 清空输入框
  identityFormItem = () => {
    this.setState(
      {
        idBirthday: undefined,
        idStartTime: undefined,
        idEndTime: undefined,
        refreshUpload: false
      },
      () => {
        // 切换证件类型，调用子组件的handleRemove()后，图片还显示，需要强制rendery一下,
        this.setState({ refreshUpload: true });
      }
    );
    // 驳回返显信息的情况下，切换证件类型，图片要清掉
    this.setState({
      supplyPath: undefined,
      idPhotoFrontPath: undefined,
      idPhotoBackPath: undefined
    });
  };

  handleSubmit = values => {
    const { loginId } = this.props;
    const { originalId, appKey } = this.state;
    const {
      businessLicenseStartTime,
      businessLicenseEndTime,
      idStartTime,
      idEndTime,
      idBirthday,
      isLicLongTerm,
      isIdLongTerm
    } = this.state;
    const parmas = {
      ...values,
      businessLicenseStartTime,
      businessLicenseEndTime,
      idStartTime,
      idEndTime,
      idBirthday
    };
    if (isLicLongTerm) {
      parmas.isLicLongTerm = 1;
      parmas.businessLicenseEndTime = null;
    } else {
      parmas.isLicLongTerm = 0;
    }
    if (isIdLongTerm) {
      parmas.isIdLongTerm = 1;
      parmas.idEndTime = null;
    } else {
      parmas.isIdLongTerm = 0;
    }
    parmas.loginId = loginId;
    // 驳回重新提交传originalId，appKey
    parmas.originalId = originalId;
    parmas.appKey = appKey;
    delete parmas.agreement;
    this.setState({ regBtnDisabled: true });
    UserService.sendUserInfo(parmas).then(res => {
      this.setState({ regBtnDisabled: false });
      if (res.code !== "000") return false;
      this.setState(() => ({ promptShow: false, modalVisible: true }));
    });
  };

  handleCancel = () => {
    this.props.history.push(`/user`);
    this.setState({ modalVisible: false });
  };

  // 是否长期
  onChangeIdLongTerm = e => {
    this.setState({
      isIdLongTerm: e.target.checked
    });
  };

  onChangeLicLongTerm = e => {
    this.setState({
      isLicLongTerm: e.target.checked
    });
  };

  // 手动选择日期的2个处理函数
  pickerOpen(name) {
    this.setState({ activePicker: name });
  }

  render() {
    const {
      promptShow,
      regBtnDisabled,
      identityType,
      businessLicensePath,
      supplyPath,
      idPhotoFrontPath,
      idPhotoBackPath,
      modalVisible,
      refreshUpload,
      isLicLongTerm,
      isIdLongTerm
    } = this.state;
    let businessFile;
    let supplyFile;
    let idPhotoFrontFile;
    let idPhotoBackFile;
    if (businessLicensePath) {
      businessFile = [
        {
          uid: "-1",
          name: "资质.png",
          status: "done",
          url: businessLicensePath
        }
      ];
    }
    if (supplyPath) {
      supplyFile = [
        {
          uid: "-2",
          name: "补充.png",
          status: "done",
          url: supplyPath
        }
      ];
    }
    if (idPhotoFrontPath) {
      idPhotoFrontFile = [
        {
          uid: "-3",
          name: "正面.png",
          status: "done",
          url: idPhotoFrontPath
        }
      ];
    }
    if (idPhotoBackPath) {
      idPhotoBackFile = [
        {
          uid: "-4",
          name: "反面.png",
          status: "done",
          url: idPhotoBackPath
        }
      ];
    }
    return (
      <div className="user-real-name">
        <Prompt message="切换页面将造成已编辑内容丢失,确定继续？" when={promptShow} />
        <Form
          ref={this.formRef}
          {...formLayout}
          labelWrap
          scrollToFirstError
          initialValues={{ identityType: 1 }}
          onFinish={this.handleSubmit}
        >
          <h2 className="border-title mb-16"> 主体信息</h2>
          <Form.Item
            name="businessLicensePath"
            label="营业执照"
            extra="请上传有年检章的营业执照照片，支持小于2M，JPG/JPEG/PNG格式的图片"
            rules={[{ required: true, message: "请上传营业执照!" }]}
          >
            <ImgUpload fileList={businessFile} type="1" {...this.props} upLoadCallback={this.businessLicenseCallback} />
          </Form.Item>
          <Form.Item label="公司名称" name="companyName" rules={[{ required: true, message: "请输入公司名称!", whitespace: true }]}>
            <Input placeholder="请输入公司名称" />
          </Form.Item>
          <Form.Item
            label="营业注册号/统一社会信用代码"
            name="businessLicenseRegisterNo"
            rules={[{ required: true, message: "请输入营业注册号营业注册号/统一社会信用代码!", whitespace: true }]}
          >
            <Input placeholder="请输入营业注册号营业注册号/统一社会信用代码" />
          </Form.Item>
          <Form.Item name="legalPersonName" label="法定代表人" rules={[{ required: true, message: "请输入法定代表人!" }]}>
            <Input placeholder="请输入法定代表人" />
          </Form.Item>
          <Form.Item name="companyAddr" label="公司地址" rules={[{ required: true, message: "请输入公司地址!" }]}>
            <Input placeholder="请输入公司地址" />
          </Form.Item>
          <div className="form-row-item">
            <Form.Item
              className="start-date"
              name="businessLicenseStartTime"
              label={<span>证件有效期</span>}
              rules={[{ required: true, message: "请选择证件开始日期!" }]}
            >
              <DatePicker
                placeholder="开始日期"
                onOpenChange={() => this.pickerOpen("businessLicenseStartTime")}
                onChange={this.pickerChange}
              />
            </Form.Item>
            {isLicLongTerm ? null : (
              <>
                <div className="line">-</div>
                <Form.Item className="end-date" name="businessLicenseEndTime" rules={[{ required: true, message: "请选择证件结束日期!" }]}>
                  <DatePicker
                    disabledDate={endDisabledDate}
                    placeholder="结束日期"
                    onOpenChange={() => this.pickerOpen("businessLicenseEndTime")}
                    onChange={this.pickerChange}
                  />
                </Form.Item>
              </>
            )}
            <Form.Item name="isLicLongTerm" valuePropName="checked">
              <Checkbox style={{ marginLeft: "15px" }} onChange={this.onChangeLicLongTerm}>
                长期
              </Checkbox>
            </Form.Item>
          </div>

          <h2 className="border-title mb-16"> 法定代表人</h2>
          <Form.Item name="identityType" label="证件类型" rules={[{ required: true, message: "请选择证件类型!" }]}>
            <Select onChange={this.identityTypeChange}>
              <Option value={1}>大陆身份证</Option>
              <Option value={2}>护照</Option>
              <Option value={3}>其他</Option>
            </Select>
          </Form.Item>
          {identityType === 3 && refreshUpload ? (
            <Form.Item
              name="supplyPath"
              rules={[{ required: true, message: "请上传法人授权委托书!" }]}
              label="法人授权委托书"
              extra="请先下载法人授权委托书模版，按照要求填写完整后上传照片，支持小于2M，JPG/JPEG/PNG格式的图片"
            >
              <a target="_blank" onClick={this.downClick} href={`${Config.api.url}/platform/register/downLoadMould`} rel="noreferrer">
                下载法人授权委托书模版
              </a>
              <ImgUpload type="5" fileList={supplyFile} {...this.props} imageUrl={supplyPath} upLoadCallback={this.supplyCallback} />
            </Form.Item>
          ) : null}

          {(identityType === 1 || identityType === 3) && refreshUpload ? (
            <div className="form-row-item">
              <Form.Item label="证件照片" name="idPhotoFrontPath" rules={[{ validator: this.validaToIdPhotoFrontPath }]}>
                <ImgUpload
                  {...this.props}
                  type="2"
                  fileList={idPhotoFrontFile}
                  imageUrl={idPhotoFrontPath}
                  upLoadtxt={
                    <p>
                      正面
                      <br />
                      需盖公章
                    </p>
                  }
                  upLoadCallback={this.idPhotoFrontCallback}
                />
              </Form.Item>

              <Form.Item name="idPhotoBackPath" rules={[{ validator: this.validaToIdPhotoBackPath }]}>
                <ImgUpload
                  {...this.props}
                  type="3"
                  fileList={idPhotoBackFile}
                  imageUrl={idPhotoBackPath}
                  upLoadtxt={
                    <p>
                      反面
                      <br />
                      需盖公章
                    </p>
                  }
                  upLoadCallback={this.idPhotoBackCallback}
                />
              </Form.Item>
              <div className="tips-text">
                {`请上传${identityType === 1 ? "有效的" : "代理人"}身份证正反面照片，支持小于2M，JPG/JPEG/PNG格式的图片`}
              </div>
            </div>
          ) : (
            <Form.Item
              name="idPhotoFrontPath"
              label="证件照片"
              extra="请上传有效的护照照片，支持小于2M，JPG/JPEG/PNG格式的图片"
              rules={[{ required: true, message: "请上传证件照片!" }]}
            >
              <Row gutter={4}>
                {refreshUpload ? (
                  <Col span={12}>
                    <ImgUpload
                      {...this.props}
                      type="4"
                      fileList={idPhotoFrontFile}
                      imageUrl={idPhotoFrontPath}
                      upLoadCallback={this.passportCallback}
                    />
                  </Col>
                ) : null}
              </Row>
            </Form.Item>
          )}
          {identityType === 2 ? (
            <Form.Item
              name="idEngName"
              label="姓名英文"
              rules={[
                {
                  required: true,
                  message: "请输入英文姓名！"
                }
              ]}
            >
              <Input placeholder="请输入英文姓名" />
            </Form.Item>
          ) : null}
          <Form.Item
            name="idName"
            label={identityType === 1 ? "姓名" : "姓名中文"}
            rules={[
              {
                required: true,
                message: identityType === 1 ? "请输入姓名!" : "请输入中文姓名！"
              },
              {
                validator: this.compareToName
              }
            ]}
          >
            <Input placeholder={identityType === 1 ? "请输入姓名" : "请输入中文姓名"} />
          </Form.Item>
          <Form.Item name="idSex" label="性别" rules={[{ required: true, message: "请输入性别!" }]}>
            <Radio.Group>
              <Radio value={2}>女</Radio>
              <Radio value={1}>男</Radio>
            </Radio.Group>
          </Form.Item>
          {identityType === 2 ? (
            <Form.Item name="idNationality" label="国籍" rules={[{ required: true, message: "请输入国籍!" }]}>
              <Input placeholder="请输入国籍" />
            </Form.Item>
          ) : null}
          <Form.Item name="idNo" label="证件号码" rules={[{ required: true, message: "请输入证件号码!" }]}>
            <Input placeholder="请输入证件号码" />
          </Form.Item>

          <div className="form-row-item">
            <Form.Item
              className="start-date"
              name="idStartTime"
              label={<span>证件有效期</span>}
              rules={[{ required: true, message: "请选择证件开始日期!" }]}
            >
              <DatePicker placeholder="开始日期" onOpenChange={() => this.pickerOpen("idStartTime")} onChange={this.pickerChange} />
            </Form.Item>
            {isIdLongTerm ? null : (
              <>
                <div className="line">-</div>
                <Form.Item className="end-date" name="idEndTime" rules={[{ required: true, message: "请选择证件结束日期!" }]}>
                  <DatePicker
                    disabledDate={endDisabledDate}
                    placeholder="结束日期"
                    onOpenChange={() => this.pickerOpen("idEndTime")}
                    onChange={this.pickerChange}
                  />
                </Form.Item>
              </>
            )}
            <Form.Item name="isIdLongTerm" valuePropName="checked">
              <Checkbox style={{ marginLeft: 15 }} onChange={this.onChangeIdLongTerm}>
                长期
              </Checkbox>
            </Form.Item>
          </div>
          {identityType === 2 ? (
            <Form.Item name="idBirthday" label="出生年月" rules={[{ required: true, message: "请选择出生年月!" }]}>
              <DatePicker placeholder="请选择出生年月" onOpenChange={() => this.pickerOpen("idBirthday")} onChange={this.pickerChange} />
            </Form.Item>
          ) : null}
          <Form.Item
            name="idAddr"
            label="所在地"
            rules={[
              {
                required: true,
                message: "请输入所在地!"
              }
            ]}
          >
            <Input placeholder="请输入所在地" />
          </Form.Item>
          <h2 className="border-title mb-16"> 联系信息</h2>
          <div style={{ padding: "20px" }}>
            <p>注意事项:</p>
            <p>1. 请确保联系人基本信息真实、完整和准确；</p>
            <p>2. 若因基本信息填写错误，未能接收或未能及时接收通知而影响使用的，Resto 开发者平台不承担任何责任。</p>
          </div>

          <Form.Item name="linkmanName" label="姓名">
            <Input placeholder="请填写联系人姓名" />
          </Form.Item>
          <Form.Item name="linkmanPosition" label="职务">
            <Input placeholder="请填写职务" />
          </Form.Item>
          <Form.Item
            name="linkmanPhone"
            label="手机号码"
            rules={[
              {
                pattern: /^[1]([3-9])[0-9]{9}$/,
                message: "请输入正确的手机号！"
              }
            ]}
          >
            <Input placeholder="请填写手机号码" maxLength={11} />
          </Form.Item>
          <Form.Item
            name="linkmanEmail"
            label="邮箱地址"
            rules={[
              {
                pattern: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/,
                message: "请输入正确的邮箱地址！"
              }
            ]}
          >
            <Input placeholder="请填写邮箱地址" />
          </Form.Item>
          <Form.Item
            className="agreement-form-item"
            name="agreement"
            valuePropName="checked"
            rules={[{ validator: (_, value) => (value ? Promise.resolve() : Promise.reject(new Error("请确认以上内容填写无误"))) }]}
          >
            <Checkbox>请确认以上内容填写无误</Checkbox>
          </Form.Item>
          <Row>
            <Col span={14} offset={4}>
              <Alert
                message="Resto 开发者平台将严格保障您的信息安全"
                description="企业使用的账号请勿做个人认证，以避免人员变动、交接账号时可能产生的纠纷。请务必仔细核实以上信息的准确性。这将有利于审核速度的提升。"
                type="info"
                showIcon
              />
              <div className="t-center" style={{ margin: "40px 0" }}>
                <Button loading={regBtnDisabled} disabled={regBtnDisabled} type="primary" htmlType="submit">
                  提交审核
                </Button>
              </div>
            </Col>
          </Row>
        </Form>
        <Modal
          visible={modalVisible}
          getContainer={false}
          onCancel={this.handleCancel}
          className="status-modal no-title"
          footer={null}
          width="604px"
        >
          <CheckCircleFilled className="icon" style={{ color: "#329324" }} />
          <p className="title">提交成功</p>
          <p className="text">实名认证信息已提交，我们将会在1-3个工作日内进行人工审核，请耐心等待。</p>
        </Modal>
      </div>
    );
  }
}

const mapStateToProps = ({ common }) => {
  const { loginId } = common;
  return {
    loginId
  };
};
const mapDispatchToProps = {
  queryRealNameInfo,
  setLogout,
  changeLoginDialogVisible
};
export default withRouter(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )(UserRealName)
);
