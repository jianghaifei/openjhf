import React, { useEffect, useState } from "react";
import { Editor } from "@tinymce/tinymce-react";
import zhCN from "../../plugins/tiny/zh_CN";
import CommonBackTop from "./CommonBackTop";
import "./css/TinymceEditor.less";

const TinymceEditor = props => {
  const { content } = props;
  const [iframeWindowEle, updateIframeWindowEle] = useState(null);
  const [height, setHeight] = useState(800);
  const customOptions = {
    content_css: "/tinymce/styles.css",
    language_url: zhCN,
    language: "zh_CN",
    plugins: [
      "advlist autolink lists link image charmap print preview anchor",
      "searchreplace visualblocks code fullscreen hr",
      "insertdatetime media table paste code codesample help wordcount"
    ],
    // images_upload_handler: uploadImgHandle,
    content_style:
      'img {max-width:100%;object-fit:contain;} body {margin:0; padding-bottom:20px;} p:first-child {margin:0} .mce-item-table:not([border]), .mce-item-table:not([border]) caption, .mce-item-table:not([border]) td, .mce-item-table:not([border]) th, .mce-item-table[border="0"], .mce-item-table[border="0"] caption, .mce-item-table[border="0"] td, .mce-item-table[border="0"] th, table[style*="border-width: 0px"], table[style*="border-width: 0px"] caption, table[style*="border-width: 0px"] td, table[style*="border-width: 0px"] th {border-style:solid;}',
    placeholder: "暂无内容",
    draggable_modal: true, // 为tinymceUI的模态窗口添加拖动模式。默认是关闭的。
    visual: true, // 网格线的作用是，如果表格border为0，TinyMCE会在编辑区内的表格周围添加虚线框作为视觉辅助
    custom_undo_redo_levels: 30, // 撤销次数
    fontsize_formats:
      "10px 11px 12px 13px 14px 15px 16px 17px 18px 19px 20px 21px 22px 23px 24px 25px 26px 27px 28px 29px 30px 31px 32px 33px 34px 35px 36px"
  };
  const gstHeight = () => {
    
    const previewEditorEle = document.getElementById("previewEditor");
    const body =
      previewEditorEle?.getElementsByTagName("iframe") && previewEditorEle?.getElementsByTagName("iframe")[0]?.contentWindow.document.body || {};
      console.log("eeee", body.offsetHeight);
    setHeight((body.offsetHeight || 0) + 100);
  };
  const previewOptions = {
    ...customOptions,
    menubar: false,
    toolbar: false,
    resize: false, // true（仅允许改变高度）, false（完全不让你动）, 'both'（宽高都能改变，注意引号）
    statusbar: false, // true显示 false隐藏 底部状态栏
    init_instance_callback() {
      // 初始化完
      gstHeight();
      updateIframeWindowEle(window);
    }
  };

  useEffect(() => {
    gstHeight();
    iframeWindowEle?.scrollTo(0, 0);
    // eslint-disable-next-line
  }, [content]);

  return (
    <div className="preview-editor" id="previewEditor" style={{ height: height }}>
      <Editor initialValue={content} init={previewOptions} disabled />
      <CommonBackTop target={() => iframeWindowEle || window} />
    </div>
  );
};

export default React.memo(TinymceEditor);
