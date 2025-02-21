import { ISchemeStatus } from "@/@types/scheme";
import classnames from "classnames";
import { observer } from "mobx-react-lite";

export interface IVersion {
  version?: string | number;
  status?: ISchemeStatus;
}

const Version = observer<IVersion>(({ version, status }) => {
  if (!version || !status) {
    return null;
  }
  return (
    <div className="h-[20px] flex rounded-[4px] text-[12px] text-[#ffffff] overflow-hidden">
      <div className="h-full pl-[12px] pr-[8px] bg-[#4A4A4A]">
        {ISchemeStatus[status]}
      </div>
      <div
        className={classnames("h-full pl-[12px] pr-[8px]", {
          "bg-[#13AF3F]": status === ISchemeStatus.已发布,
          "bg-[#FF7A00]": status === ISchemeStatus.草稿,
        })}
      >
        {version}
      </div>
    </div>
  );
});

export default Version;
