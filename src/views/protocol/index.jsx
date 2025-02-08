import React from "react";
import { Anchor } from "antd";
import "./index.less";

const { Link } = Anchor;
const Protocol = () => {
  return (
    <div className="protocol">
      <div className="anchor">
        <Anchor affix showInkInFixed offsetTop={100}>
          <Link href="#p1" title="定义" />
          <Link href="#p2" title="服务商注册" />
          <Link href="#p3" title="开放平台权利义务" />
          <Link href="#p4" title="服务商规范" />
          <Link href="#p5" title="服务费及支付" />
          <Link href="#p6" title="保密" />
          <Link href="#p7" title="知识产权" />
          <Link href="#p8" title="违约责任" />
          <Link href="#p9" title="免责声明" />
          <Link href="#p10" title="协议终止" />
          <Link href="#p11" title="争议解决" />
          <Link href="#p12" title="其它" />
        </Anchor>
      </div>

      <div className="protocolContent">
        <h1>Resto 开发者平台服务协议V2.0</h1>

        <p id="p0">
          本服务协议（以下简称 “本协议”）是北京多来点信息技术有限公司（以下简称“Resto”）与服务商（以下或称为“您”）就您入驻Resto
          开发者平台有关的事宜所订立的有效合约。{" "}
          <b>
            您按照注册页面提示填写信息、阅读并同意本协议且完成全部注册程序后，即表示您已充分阅读、理解并接受本协议的全部内容，并与Resto
            达成一致，成为Resto 开发者平台的服务商。 您有违反本协议的任何行为时，Resto
            有权依照规定，随时单方限制、中止或终止向您提供本服务，并有权追究您的相关责任。
          </b>
        </p>

        <p>
          <b>
            为维护您的自身权益，请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款。限制、免责条款可能以黑体加粗形式提示您注意。您勾选
            “同意”的行为将视为对上述限制、免责条款的充分理解与完全认可。如果您不同意本协议或其中任何条款约定，请不要点击“同意”。
          </b>
        </p>

        <p>
          <b>
            本协议内容同时包括Resto 开发者平台上不断发布或更新的相关协议、业务规则、管理规定等内容。Resto
            有权随时更新本协议，更新后的协议及规则条款将公布于Resto
            开发者平台网站上。上述内容一经正式发布，即为本协议不可分割的组成部分。您同意承担及时查阅最新协议的义务。您继续使用Resto
            开发者平台即视为接受，如您不接受修改后的条款，请立即停止使用开放平台服务并向Resto 书面提出退出Resto 开发者平台。
          </b>
        </p>

        <h2 id="p1">一、定义</h2>
        <p>1、服务市场:指用户挑选您发布的应用及进行订阅或订购的自助服务市场和管理系统。</p>
        <p>
          2、Resto 开发者平台 （以下简称“开放平台”） :由Resto 所拥有并独立经营的（{" "}
          <a href="http://open.web.restosuite.ai" rel="noreferrer" target="_blank">
            http://open.web.restosuite.ai
          </a>{" "}
          ，具体名称以网页显示为准）网站及相关页面，是为餐饮企业提供基础服务的重要开放途径，旨在为需要开发接入的Resto
          商户提供系统对接服务。开发者可通过 API文档来了解Resto 开发者平台目前已开放的业务接口，可自主选择所需接口提交授权进行对接。
        </p>
        <p>3、服务商:指您，按照开放平台流程经有效注册、申请后，通过开放平台进行应用开发或完善并提供咨询、操作等服务的法人或其他组织。</p>
        <p>4、用户:指所有通过服务商提供的应用或服务的单位或个人。</p>
        <p>
          5、应用:指您基于开放平台所开发的软件或服务。本协议所称“应用”均指您发布并展示于服务市场的主应用，不包含其利用服务市场的相关服务能力、针对主应用的业务场景独立开发的、内置于主应用、可供用户单独订购的主应用的增值功能或服务（以下简称“内购应用”）。
        </p>
        <p>
          6、开发者：指按照开放平台流程经注册、登录，通过技术文档进行软件开发的自然人、法人或者组织。开发者通过开放平台提供的技术文档进行软件开发，服务自身或者其他客户。
        </p>

        <h2 id="p2">二 、服务商注册</h2>
        <p>
          1、您应保证您为一家依据中国法律合法成立并有效存续的法人或其它商事主体，能够独立承担法律责任，并具有履行本协议所需的一切权利及能力；同时您应当根据开放平台注册过程中所示在线提交各项必须文件或证明，包括但不限于营业执照、税务登记证、组织机构代码证、授权委托书、商标注册证、
          法定代表人身份证正反面复印件等。在发生用户投诉、行政机关机构调查、诉讼解决等事项时，您还应向Resto
          提交与原件核对一致且加盖公章的纸质复印件。
        </p>
        <p>2、您确保上述证明文件真实、合法、有效，如发生任何变更或更新时立即通知Resto ，并于十五个工作日内，提交更新后的文件。</p>
        <p>
          <b>
            3、若您提交虚假、过期文件、或未如期通知并提交更新文件等情形的，由您独立承担全部法律责任。若由此导致您不符合开放平台入驻条件的，Resto
            有权要求您补充提供相关资料，或者拒绝您申请、调整开放平台权限、直至终止本协议。如您造成Resto
            及其他任何第三方损失的，您还应足额赔偿。
          </b>
        </p>

        <h2 id="p3">三、 开放平台权利义务</h2>
        <p>1、负责应用开发的网络环境、接口的维护，以及平台的建设与维护。</p>
        <p>
          2、有权对服务商提交的信息及线上应用/软件服务进行审核。在服务商资质缺失、拒不提供资质信息、信息造假、不符合开放平台相关平台规则规定等情况下，开放平台有权不予以审核通过；如开放平台发现服务商在审核环节出现信息造假、故意欺瞒，不符合平台规则相关规定等情况，开放平台有权随时对服务商进行下线操作且不承担任何责任。
        </p>
        <p>
          3、服务商理解并认可，开放平台仅能以普通或非专业人员的知识水平标准对服务商在入驻环节填写或提交的入驻资料、入驻信息进行形式审核，且开放平台保留抽查、要求服务商补充提交、及时更新入驻材料及入驻信息的权利。服务商应对入驻材料、入驻信息的真实性、合法性、准确性、有效性独立承担全部责任；如开放平台发现服务商的入驻资料、信息造假或失效的，开放平台有权立即终止本协议并根据相关规则追究服务商责任。
        </p>
        <p>4、开发者与服务商存在关联关系，若开发者自身或其中某开发者存在违规行为，应由服务商承担相应责任。</p>
        <p>
          5、如服务商变更经营范围或变更已提交开放平台审核的开发应用/软件服务类型或品牌的，应及时书面通知开放平台，否则开放平台有权随时终止本协议及本协议项下的合作事宜，且不承担任何责任。
        </p>
        <p>
          6、用户使用服务商提供的产品或服务发生的任何纠纷应由用户和服务商自行协商解决，开放平台不承担任何责任。但如用户向开放平台投诉服务商，开放平台有权引导用户与服务商自行解决纠纷；{" "}
          <b>
            如任何公权力机关（如法院、工商局等）认定服务商须对用户承担相应法律责任的，开放平台有权立即终止本协议，且有权追究服务商相应的法律责任。用户与服务商之纠纷对开放平台
            /Resto /Resto 关联方/Resto 合作方有不良影响的，开放平台/Resto /Resto 关联方/Resto
            合作方有权（但无义务）根据情况自行决定介入纠纷解决过程，由此给开放平台/Resto /Resto 关联方/Resto
            合作方有权造成的成本或者支出，由服务商全额承担。
          </b>
        </p>
        <p>
          7、服务商许可开放平台/Resto 为本协议之合作目的合理使用服务商信息（包括但不限于服务商名称、LOGO、产品图片等信息），但开放平台/Resto
          不得以任何形式用于本协议约定之外的用途。
        </p>
        <b>
          <p>
            8、如开放平台认为服务商提供的信息违反法律法规的规定，或违反本协议的任何约定，开放平台有权拒绝提供接入服务或终止服务，且不承担违约或其他任何责任。如存在下列情况，开放平台以普通或非专业人员的知识水平标准对相关内容进行判别，可以认为这些内容或行为具有违法或不当性质的，开放平台有权停止对服务商提供服务，并追究服务商相应法律责任：
          </p>
          <p>(1)第三方通知开放平台，认为服务商或某个具体应用事项可能存在重大问题。</p>
          <p>(2)用户或第三方向开放平台告知平台上有违法或不当行为，例如服务商非法获取、使用或泄露商家/用户数据等。</p>
          <p>
            (3)开放平台有权对服务商和用户的注册数据及交易行为进行查阅，发现注册数据或交易行为中存在任何问题或怀疑，均有权向服务商发出询问或要求改正的通知，或直接作出删除等处理。
          </p>
          <p>
            9、开放平台根据本协议向服务商提供相关技术服务，在提供服务过程中不可避免地会解析、保存服务商提供的相应数据、信息、文本等其他资料，以便于相应技术服务的稳定及相应问题（BUG）等的排查、解决。服务商对此知悉并承诺：服务商对其提供的前述数据、信息、文本等其他资料均通过合法途径获取且有权给予Resto
            及Resto 关联公司、合作伙伴等充分授权，但Resto 对此类数据具有保密义务，且不可向Resto
            相关技术服务领域合作方以外的任何第三方披露（国家公权力机关基于相关法律、法规向Resto 提出要求的除外）。
          </p>
          <p>
            10、开放平台有权随时检查、抽查服务商提交上线的应用/软件服务，如发现如下情形，则开放平台有权随时终止本协议及本协议项下合作事项且不承担任何责任：
          </p>
          <p>
            (1)服务商及开发者主体名称、对接人信息、应用信息、软件信息、订单推送地址、回调地址等信息与开放平台审核通过的信息不相符;或服务商单方变更前述信息且未在本协议约定的时间内主动告知开放平台并经开放平台确认的。
          </p>
          <p>(2)其他违反本协议及开放平台平台规则的情形/行为。</p>
          <p>
            (3)开放平台有权抽查服务商应用是否符合平台规则针对服务商在开发、部署、运营、维护和管理等方面的安全准则要求，服务商需按规范要求执行，并接受开放平台在合规范围内的抽查。
          </p>
          <p>
            (4)开放平台有权在合理范围内，针对开放平台合作服务商的信息系统进行安全审计，服务商应配合开放平台信息安全人员完成审计。同时，不得存在欺瞒、转移、隐藏自身缺陷等行为，不得存在影响安全审查准确性、拖延审查、规避审查等行为，审查完成后，服务商应根据审查结果，在规定期限内完成整改。
          </p>
        </b>

        <h2 id="p4">四、服务商规范</h2>
        <p>1、服务商应遵守本协议之约定及平台公告发布的与服务商履行本协议项下义务相关的各项平台规则。</p>
        <p>
          2、服务商应自行负责为用户提供安全、稳定、合法、有效的应用服务，解答用户疑问和解决用户纠纷，因应用和服务商服务发生的任何纠纷、处罚、诉讼等事项，其责任应由服务商独立承担，并且服务商
          有责任采取有效措施使Resto 免责或全额弥补Resto 的损失。
        </p>
        <p>
          3、服务商、服务商的供应商/商家提供的产品、服务或信息应已获得开展本协议项下合作所需的必要的合格管理、授权、许可权限。若服务商的供应商/商家服务不符合本协议约定而造成开放平台/Resto
          /Resto 关联方/Resto 合作方或用户经济损失的，您将对开放平台/Resto /Resto 关联方/Resto 合作方或用户承担连带赔偿责任。
        </p>
        <p>
          4、服务商应确保其提供的产品、服务或信息与其经营信息一致，同时保证应符合国家法律法规的规定，服务商信息中不得含有包括但不限于危害国家安全、赌博、淫秽色情、虚假、侮辱、诽谤、恐吓或骚扰、侵犯他人知识产权、人身权或其他合法权益以及有违社会公序良俗的内容或指向这些内容的链接；服务商不得利用Resto
          提供的收付款渠道开展洗钱、贿赂、欺诈、陷害等非法用途。
        </p>
        <p>
          5、如服务商开展收费服务必须合法
          合规，在用户付款之前必须向用户进行明显的提示且获得用户的同意，不得引诱、欺诈、误导用户进行不合理的消费，不得在应用界面或代码中内嵌或设置收费接口诱导、欺骗用户付费。
        </p>
        <p>
          6、在服务商提供的某款应用已经向用户收取费用的情况下，若服务商因任何原因退出本协议项下的合作，或终止提供应用或服务的，应当依照Resto
          要求进行退出结算和开展善后工作。服务商应当本着维护用户权益的原则，对已经购买应用且尚在服务有效期内的用户提供合理的补偿。如果服务商不能提供合理补偿或与用户达成善后处置方案的，则Resto
          有权为用户提供补偿，此补偿费用最后应由服务商承担。
        </p>
        <p>
          7、如因服务商行为或服务商提供的产品、服务或信息造成用户损失的，与开放平台无关，由服务商承担相应的全部赔偿责任。如开放平台/Resto
          /Resto 关联方/Resto 合作方基于前述情况向用户先行赔付或遭受其他损失的，开放平台/Resto /Resto 关联方/Resto
          合作方有权向服务商进行追偿（包括但不限于支付罚款、给付赔偿金或律师费等）。
        </p>
        <p>
          8、服务商承诺并保证服务商对其使用的商品、商标、品牌、图片等享有合法权利或合法授权，不会侵犯他人的知识产权、企业名称权等权益；且服务商承诺开放平台/Resto
          /Resto 关联方/Resto 合作方不会因展示服务商上述信息而遭受来自第三方的任何投诉、抗辩及争议，否则相应责任均由服务商承担。
        </p>
        <b>
          <p>
            9、服务商知晓，Resto /Resto 关联方/Resto 合作方及其网站、应用、系统的所有非公知信息均为商业秘密，未经Resto
            明确同意，服务商不得获取、使用、透露该等商业秘密。对于经Resto 明确同意或者Resto
            因本协议合作之目的向服务商提供之信息（包括但不限于用户相关数据、用户针对服务商应用的使用数据及其他平台数据，下同），服务商应承担严格保密义务。服务商应采取足够的管理措施和技术等手段，妥善保管其通过本协议项下合作而获取的所有信息，并不得将前述信息用于交易、披露、泄露、共享、提供给第三方或其他本协议约定之外的用途。
          </p>
          <p>10、服务商开发/发布的应用或出于其他任何目的需要收集或使用用户数据的，应当满足以下条件：</p>
          <p>(1)服务商必须事先获得用户的同意，且应当告知用户相关数据收集的目的、范围及使用方式；</p>
          <p>
            (2)服务商不得请求、收集、索取或以其他方式从任何用户那里获取Resto
            用户的账户密码或其他身份验证凭据的访问权；不得为任何用户自动登录到Resto
            提供代理身份验证凭据；不得提供“跟踪”功能，包括但不限于识别其他用户在开发者应用档案文件页上查看或操作；
          </p>
          <p>
            (3)服务商不得使用任何漫游器、网络蜘蛛、网络爬虫、抓取工具、网站搜索/检索应用程序或其他工具访问、抓取、爬取、存储、缓存、检索等方式，获取Resto
            相关内容的任何一部分数据；亦或不得以任何方式、任何工具避开或试图避开本服务及Resto
            所提供的任何安全保护机制或系统防御工具或其他系统配置违规获取Resto 相关数据；
          </p>
          <p>(4)服务商不得利用用户/其他服务商的账号或相关权限等通过任何方式获取Resto 的用户数据；</p>
          <p>
            (5)服务商应当仅获取为应用程序运行及功能实现目的而必要的数据，服务商在特定应用中收集的用户数据仅可以在该特定应用中使用，不得将收集的用户数据转移或使用在该特定应用之外,
            不得将用户数据出售、转让或用于特定应用之外的任何其他目的；
          </p>
          <p>(6)服务商应当向用户提供修改、删除用户数据的方式，并确保相关数据被完全删除；</p>
          <p>
            (7)Resto 有权限制或阻止开发者获取用户数据及开放平台运营数据，有权自主决定相关数据的保存期限；如Resto
            认为服务商使用用户数据的方式、数据收集的目的或收集的范围有可能损害用户体验、侵犯用户权益或者不符合应用程序运行或功能实现的目的，开放平台有权要求开发者立即删除相关数据并不得再以该方式使用或再行收集该等数据；
          </p>
          <p>
            (8)一旦用户退订或停止使用开发者的应用，服务商必须立即删除从该用户处获取的全部数据；且开放平台有权基于数据安全的考虑不经通知径行做出删除数据的处理措施。
          </p>
        </b>
        <p>
          11、服务商对其通过本协议项下合作而获取的信息进行存储、传输时，应采取有效的手段防止不法人员利用上述信息开展任何不法活动，并向开放平台提供有效手段证明且经开放平台确认。
        </p>
        <p>
          12、服务商导出其通过本协议项下合作而获取的信息时，应存储系统日志。如开放平台对服务商相关导出信息行为发出询问，服务商应在开放平台规定的时间内进行解释和说明。
        </p>
        <p>
          13、鉴于在双方合作过程中，服务商可能有机会接触到用户个人信息（下称“个人信息”），依据《中华人民共和国网络安全法》等相关法律法规规定，为严格保护个人信息，服务商应严格遵守如下承诺：
        </p>
        <p>(1)服务商使用个人信息应严格遵循合法、正当、必要的原则，仅在为用户提供服务所必需的范围内采集、接触和使用个人信息。</p>
        <p>
          (2)除非因提供服务所必需的情形，服务商不会以任何形式采集个人信息，不会将个人信息用于提供服务之外的目的。对在提供服务过程中接触、使用的个人信息，服务商承诺严格保密，并不泄露、篡改、复制、非法存储、交换、对外提供或出售。
        </p>
        <p>
          (3)如发生服务商或与服务商相关的人员非法收集、使用、出售或泄露个人信息等违法情形，服务商应立即并积极配合监管机构或开放平台调查，并由服务商负责承担因此产生的民事责任、行政处罚和刑事责任。服务商因此给开放平台、Resto
          /Resto 关联方/Resto 合作方造成损失的，服务商应承担赔偿责任，且开放平台有权停止向服务商提供服务。
        </p>
        <b>
          <p>
            14、服务商对开放平台为其提供的数据安全性负全部责任，并对以其用户名进行的所有活动和事件负全部责任，服务商若发现任何非法使用开发者账号或存在数据泄露等安全漏洞或风险的情况，应立即通知开放平台。服务商不得将服务账号及开放平台在本协议下承诺向服务商提供的服务及相关资源转卖、出租、出借给任何第三方。若服务商违反该规定，开放平台将保留关闭服务接口及终止继续提供服务的权利。同时，开放平台有权追究服务商相应的法律责任。
          </p>
        </b>
        <p>
          15、服务商如基于本协议合作需使用Resto 的商标，标识等的，须获得Resto 事先书面同意，并按Resto 授权的范围、期限及内容进行。服务商
          不得擅自将Resto 商标用于双方约定的合作范围外的事项及内容，亦不得以Resto 名义从事本协议约定事项以外的事宜。
          无论本协议因任何原因终止，服务商承诺立即停止以任何方式使用Resto
          /开放平台相关的商标、标识、网站名称、网站内容等，且必须立即删除通过本协议项下合作而获取的所有信息。
        </p>
        <p>
          16、服务商应保证其要求开放平台提供的其他技术服务/支持，为其在法律法规允许或经过第三方合法授权向开放平台提出的要求。服务商确认并承诺：
        </p>
        <p>
          (1)服务商向开放平台提出的此类技术服务/支持等需求，不存在任何违反法律、法规或侵犯任何第三方合法权利的事由/瑕疵。如因此导致任何第三方向开放平台、Resto
          /Resto 关联方/Resto 合作方提出侵权、索赔、诉讼、纠纷或任何行政管理部门处罚等，由服务商负责解决并保证开放平台、Resto /Resto
          关联方/Resto 合作方免责。
        </p>
        <b>
          <p>
            (2)对于开放平台应服务商要求向其提供的其他技术服务/支持的相关技术文档、数据、接口、应用程序等，服务商应妥善保管且仅能在与开放平台合作范围内使用，不得向任何第三方披露、转让、出售，否则因此导致开放平台、Resto
            /Resto 关联方/Resto 合作方遭受直接或间接损失，由服务商负责解决、赔偿并保证开放平台、Resto /Resto 关联方/Resto 合作方免责。
          </p>
        </b>
        <p>
          (3)如服务商怠于履行上述义务，则开放平台、Resto /Resto 关联方/Resto
          合作方为解决此类侵权、索赔、诉讼、纠纷或任何行政管理部门处罚事项或为消除上述事项对开放平台、Resto /Resto 关联方/Resto
          合作方造成不利影响所产生的一切支出（包括但不限于：赔偿、罚款、合理律师费等）均由服务商承担。
        </p>
        <p>
          <b>17 、您理解并同意，Resto 有权基于对开放平台管理的需求对类目进行调整和限制，可能会将您已发布的应用做服务下架处理。</b>
        </p>

        <h2 id="p5">五 、服务费及支付</h2>
        <p>1、Resto 向您提供的服务市场的服务内容包括互联网信息服务、应用的上架及下架、商业推广以及与此有关的互联网技术服务。</p>
        <p>
          2、为了扶持服务商发展，您入驻Resto 开发者平台暂时无需向Resto 支付服务费用，但Resto 保留根据业务发展的需要今后向您收费的权利。Resto
          实施收费前将公布有关收费政策及或规则。届时如果您不同意付费的，则您须退出开放平台。
        </p>

        <h2 id="p6">六、保密</h2>
        <p>
          1、未经Resto 许可，您不得向任何第三方泄露通过签订和履行本协议而获知的Resto 及Resto 关联公司的任何商业秘密，包含但不限于Resto
          及Resto 关联公司的商业、技术、财务、市场、数据或任何其它方面的任何商业秘密。
        </p>
        <p>
          2、合作期间及合作结束后，您不得自行或授权第三方以任何方式使用Resto 提供的ID、代码等因本协议项下合作从Resto
          获得全部的材料、数据、信息和商业秘密。如因您违反此项义务，Resto 有权追究您的违约责任。
        </p>
        <p>3、本协议有效期内及终止后，保密条款仍具有法律效力。</p>

        <h2 id="p7">七 、知识产权</h2>
        <p>
          1、Resto
          所包含的全部智力成果包括但不限于数据库、网站设计、文字和图表、软件、照片、录像、音乐、声音及其前述组合，软件编译、相关源代码和软件
          (包括小应用程序和脚本) 的知识产权权利均归Resto 所有。 非经Resto 书面同意，您不得擅自使用
          、更改、拷贝、发送、公开传播前述任何材料或内容。
        </p>
        <p>
          <b>
            2、根据本协议的条款和条件，Resto
            授予服务商有限的、非排他性的、可随时终止的和不可再分发的许可，仅限于服务商在自己访问和使用开放平台开发、测试、显示其应用时，允许服务商、开发者访问Resto
            提供的或用户自身授权的用户信息；但Resto
            有权随时在提前通知或不通知的情况下自行限制、约束或禁止服务商或开发者或其他用户访问服务商的应用。
          </b>
        </p>
        <p>
          3 、服务商保留其创建的应用内容以及其中包括的所有权利、权属或权益，包括但不限于归属于服务商的知识产权。{" "}
          <b>
            开发者通过开放平台提交或发布应用，即表明服务商授予Resto 服务期内的、非排他性的、完全给付并免费的全球性许可，允许Resto
            使用、复制、再许可、重设格式、修改、删除、添加、公开显示、重现、分发和执行服务商应用，以及将其存储或缓存在Resto 指定服务器上。
          </b>
        </p>

        <h2 id="p8">八、违约责任</h2>
        <p>
          <b>
            1、如服务商违反本 协议
            的任一条款、平台规则或违反其在本协议的履行中做出的任何承诺和保证，开放平台有权拒绝向服务商提供服务；同时，开放平台有权要求服务商纠正违约行为，如服务商在开放平台要求的期限内拒绝纠正或纠正后仍不符合本协议约定的，开放平台有权单方解除本协议，并终止合作，同时开放平台有权将该服务商及其违规行为在开放平台及
            /或Resto 平台进行公示，并进一步追究其法律责任。
          </b>
        </p>
        <p>
          2 、
          因开放平台未能按照本协议履行义务，服务商有权要求开放平台纠正违约行为。如开放平台在服务商要求的期限内拒绝纠正或经两次纠正后仍不符合本协议约定的，服务商有权立即解除本协议。
        </p>

        <h2 id="p9">九、免责声明</h2>
        <p>
          1、“不可抗力”是指双方不能合理控制、不可预见或即使预见亦无法避免的事件，该事件妨碍、影响或延误任何一方根据协议履行其全部或部分义务。该事件包括但不限于政府行为、自然灾害、战争或任何其它类似事件。鉴于互联网之特殊性质，不可抗力亦包括下列影响互联网正常运行之情形:
          a. 黑客攻击； b. 电信部门技术调整导致之重大影响； c. 因政府管制而造成之暂时关闭； d. 病毒侵袭。
        </p>
        <p>
          2、出现不可抗力事件时，知情方应及时、充分地向对方以书面形式发通知，并告知对方该类事件对本协议可能产生的影响，并应当在15天内提供相关证明。由于以上所述不可抗力事件致使协议的部分或全部不能履行或延迟履行，则双方于彼此间不承担任何违约责任。
        </p>
        <b>
          <p>
            3、服务商理解开放平台为了平台的正常运行，需要定期或不定期地对平台进行停机维护，如因此类情况而造成的本协议项下相应服务的暂停或终止，服务商承诺对此不追究开放平台法律责任。
          </p>
          <p>
            4、基于市场整体利益考虑及经营需要，开放平台可能不定期对平台的服务内容、版面布局、页面设计等有关方面进行调整，如因上述调整而影响本协议项下约定的服务或导致合作事项终止，则服务商将给予充分的谅解，并承诺对此不追究开放平台法律责任。
          </p>
          <p>
            5、开放平台不对平台服务效果或服务商可能使用的与应用开发服务有关的工具、软件等作出任何明示或默示的陈述、保证和条件，开放平台在任何情况下都不承担间接损失（包括丧失交易机会或可得利益的损失等）的赔偿责任或惩罚性赔偿责任。
          </p>
          <p>6、服务商通过开发的应用进行商务活动所引起的一切法律纠纷均与开放平台/Resto 无关，应由服务商自行解决并承担相应责任。 </p>
          <p>
            7、服务商明确理解和同意，开放平台服务将按“现状”和按“可得到”的状态提供。开放平台将在现有技术的基础上尽最大努力提供相应的安全措施以保障服务安全和正常运行。但由于可能存在的计算机病毒、网络通讯故障、系统维护等方面的因素，以及可能发生的不可抗力事件，开放平台在此声明对服务不作任何明示或暗示的保证，包括但不限于对服务的可适用性、没有错误或疏漏、持续性、准确性、可靠性、适用于某一特定用途。开放平台不对因下述任一情况而导致的任何损害赔偿承担责任，包括但不限于利润、商誉、使用、数据等方面的损失和其他无形损失的损害（无论开放平台是否已被告知该损害赔偿的可能性）：
          </p>
          <p>(1)第三方未经批准的接入或第三方更改用户的传输数据或数据。</p>
          <p>(2)可能存在计算机病毒、网络通讯故障、系统停机维护。</p>
          <p>(3)使用或未能使用服务。</p>
          <p>
            8、对于服务商应用的开发、运营、支持和维护，服务商同意独立承担所有的风险和后果。开放平台没有责任和义务对于发布在开放平台上的任何不准确或不正确的内容承担任何责任。
          </p>
        </b>

        <h2 id="p10">十 、 协议终止</h2>
        <p>1、甲乙双方均有权随时终止本协议及本协议项下的合作事项，但应提前【15】日通知对方。</p>
        <b>
          <p>2、出现下列情况之一的，开放平台有权立刻终止本协议且无需承担任何责任：</p>
          <p>(1)服务商违反本协议中的约定、承诺和保证，开放平台发布的规则、规范，存在损害开放平台/Resto 商业利益、商誉等的情况；</p>
          <p>
            (2)服务商自己或受到他人提出破产、公司整顿、清算、公司重组等申请，或出现工商登记变更、合并、解散、停业等情况时；或主要财产被冻结、查封、强制执行或拍卖等，或受到行政部门的行政处分时；
          </p>
          <p>
            (3)服务商与Resto
            发生纠纷（包括但不限法律诉讼等）的，开放平台有权先暂停双方合作，待纠纷解决后由双方协商处理合作事宜；开放平台有权根据服务商过错程度选择终止合作；
          </p>
          <p>
            (4)服务商违反法律法规或本协议的约定非法获取或不当使用相关数据的，开放平台有权采取直接终止本协议、删除服务商已获取的相关数据、下架应用等措施，且前述措施可以合并使用；服务商应当以自己的名义独立承担全部责任，并对开放平台、Resto
            /Resto 关联方/Resto 合作方、用户或任何第三方造成的损失进行赔偿；
          </p>
          <p>(5)根据相关法律法规或者本协议其他条款约定，开放平台有权立即终止本协议的其他情形。</p>
        </b>
        <p>3、本协议终止后，双方约定如下：</p>
        <p>(1)开放平台有权停止平台相关接口和信息服务，清退服务商所有开发者账号，且开放平台无需就此向服务商或其他第三方承担责任。</p>
        <p>(2)本协议终止前服务商已与用户达成约定但尚未履行完毕的义务，服务商应按照约定继续履行相关义务。</p>
        <p>(3)开放平台有权要求服务商从服务器、数据库内清除并销毁所有前期推送数据内容，包括但不限于:用户数据、订单数据等。</p>
        <p>
          (4)服务商清除并销毁所有前期推送数据内容后，开放平台有权抽查服务商数据清除情况。如若发现未完全清空或不配合抽查情况，则视为侵犯Resto
          数据安全，开放平台/Resto 有权采取强制措施或索要赔偿。
        </p>
        <p>
          4、如服务商、开发者在本协议终止后再一次直接或间接以他人名义注册并登陆开放平台的，开放平台有权直接单方面终止向该服务商、开发者提供服务。
        </p>
        <p>
          5、如开放平台通过服务商提供的信息与服务商联系时，发现服务商注册时填写的联系方式已经不存在或无法接收电子邮件的，经开放平台以其他联系方式通知服务商更改而服务商在三个工作日内仍未能提供新的联系方式的，开放平台有权终止向该服务商提供服务。
        </p>

        <h2 id="p11">十一、 争议解决</h2>
        <p>1、本协议的成立、生效、履行及纠纷解决等一切事宜，均适用于中华人民共和国大陆地区法律。</p>
        <p>
          2、本协议签订地为北京市西城区。凡因履行本协议所发生的一切争议，双方应首先通过友好协商加以解决，若通过协商仍不能解决的，双方均同意提交本协议签订地有管辖权的人民法院诉讼解决。
        </p>

        <h2 id="p12">十二 、其它</h2>
        <p>1、本协议于您点击Resto 开放 平台注册页面的同意注册并完成注册程序时生效，对Resto 和您均具有约束力。</p>
        <p>2、Resto 未行使或执行本服务协议任何权利或规定，不构成对前述权利或权利之放弃。</p>
        <p>3、如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。</p>
      </div>
    </div>
  );
};
export default React.memo(Protocol);
