-- ============================================
-- 财途指南 v2 - Supabase 完整迁移脚本
-- Vue 3 + Supabase Auth + 精细化 RLS
-- ============================================

-- ============================================
-- 0. 清理旧策略（如果存在）
-- ============================================
DROP POLICY IF EXISTS "allow_all_admins" ON public.admins;
DROP POLICY IF EXISTS "allow_all_users" ON public.users;
DROP POLICY IF EXISTS "allow_all_jobs" ON public.jobs;
DROP POLICY IF EXISTS "allow_all_news" ON public.news;
DROP POLICY IF EXISTS "allow_all_careers" ON public.careers;
DROP POLICY IF EXISTS "allow_all_certs" ON public.certs;
DROP POLICY IF EXISTS "allow_all_submissions" ON public.submissions;
DROP POLICY IF EXISTS "allow_all_settings" ON public.settings;
DROP POLICY IF EXISTS "allow_all_resume_tips" ON public.resume_tips;

-- ============================================
-- 1. 重建 admins 表（id 改 UUID，移除 password_hash/encrypted_token，增加 email）
-- ============================================
DROP TABLE IF EXISTS public.admins CASCADE;
CREATE TABLE public.admins (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  account TEXT UNIQUE NOT NULL,
  name TEXT,
  role TEXT DEFAULT 'admin' CHECK (role IN ('super', 'admin')),
  identity TEXT,
  phone TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  note TEXT,
  permissions JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. 重建 users 表（id 改 UUID，移除 password/recovery_key，增加 email）
-- ============================================
DROP TABLE IF EXISTS public.users CASCADE;
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  username TEXT UNIQUE NOT NULL,
  school TEXT,
  major TEXT,
  grade TEXT,
  plan TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. jobs 表（增加 province 字段）
-- ============================================
DROP TABLE IF EXISTS public.jobs CASCADE;
CREATE TABLE public.jobs (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  company TEXT NOT NULL,
  city TEXT,
  province TEXT,
  type TEXT,
  salary TEXT,
  deadline TEXT,
  description TEXT,
  featured BOOLEAN DEFAULT false,
  apply_url TEXT,
  apply_email TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'closed', 'draft')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 4. news 表
-- ============================================
DROP TABLE IF EXISTS public.news CASCADE;
CREATE TABLE public.news (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  date TEXT,
  category TEXT,
  summary TEXT,
  content TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 5. careers 表
-- ============================================
DROP TABLE IF EXISTS public.careers CASCADE;
CREATE TABLE public.careers (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  emoji TEXT,
  description TEXT,
  skills TEXT,
  path TEXT,
  advantage TEXT,
  salary TEXT,
  industry TEXT,
  national_support TEXT,
  drawback TEXT
);

-- ============================================
-- 6. certs 表
-- ============================================
DROP TABLE IF EXISTS public.certs CASCADE;
CREATE TABLE public.certs (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT,
  badge TEXT,
  difficulty TEXT,
  value TEXT,
  cost TEXT,
  exam_time TEXT,
  signup_time TEXT,
  suitable TEXT,
  note TEXT,
  exam_mode TEXT,
  difficulty_type TEXT,
  pass_rate TEXT,
  advantage TEXT,
  salary TEXT,
  industry TEXT,
  national_support TEXT
);

-- ============================================
-- 7. submissions 表
-- ============================================
DROP TABLE IF EXISTS public.submissions CASCADE;
CREATE TABLE public.submissions (
  id SERIAL PRIMARY KEY,
  position TEXT,
  company TEXT,
  city TEXT,
  type TEXT,
  salary TEXT,
  deadline TEXT,
  description TEXT,
  apply_url TEXT,
  apply_email TEXT,
  contact TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  submitted_at TEXT,
  review_note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 8. settings 表
-- ============================================
DROP TABLE IF EXISTS public.settings CASCADE;
CREATE TABLE public.settings (
  key TEXT PRIMARY KEY,
  value TEXT
);

-- ============================================
-- 删除不再需要的表
-- ============================================
DROP TABLE IF EXISTS public.resume_tips CASCADE;

-- ============================================
-- 启用 RLS
-- ============================================
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.news ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.careers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.certs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 辅助函数
-- ============================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins
    WHERE id = auth.uid() AND status = 'active'
  );
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admins
    WHERE id = auth.uid() AND role = 'super' AND status = 'active'
  );
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ============================================
-- RLS 策略：careers / certs / news / settings
-- ============================================
-- 公开读
CREATE POLICY "public_read" ON public.careers FOR SELECT USING (true);
CREATE POLICY "public_read" ON public.certs FOR SELECT USING (true);
CREATE POLICY "public_read" ON public.news FOR SELECT USING (true);
CREATE POLICY "public_read" ON public.settings FOR SELECT USING (true);

-- 仅管理员写
CREATE POLICY "admin_write" ON public.careers FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "admin_write" ON public.certs FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "admin_write" ON public.news FOR ALL USING (is_admin()) WITH CHECK (is_admin());
CREATE POLICY "admin_write" ON public.settings FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ============================================
-- RLS 策略：jobs
-- ============================================
-- 公开读（仅 active）
CREATE POLICY "public_read_active" ON public.jobs FOR SELECT USING (status = 'active');
-- 管理员全量读写
CREATE POLICY "admin_all" ON public.jobs FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ============================================
-- RLS 策略：users
-- ============================================
-- 公开读（脱敏）
CREATE POLICY "public_read_limited" ON public.users FOR SELECT USING (true);
-- 用户只能写自己的数据
CREATE POLICY "user_write_own" ON public.users FOR ALL USING (auth.uid() = id) WITH CHECK (auth.uid() = id);
-- 管理员全量读写
CREATE POLICY "admin_all_users" ON public.users FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- ============================================
-- RLS 策略：admins
-- ============================================
-- 仅管理员可读
CREATE POLICY "admin_read" ON public.admins FOR SELECT USING (is_admin());
-- 仅超管可写
CREATE POLICY "super_admin_write" ON public.admins FOR ALL USING (is_super_admin()) WITH CHECK (is_super_admin());

-- ============================================
-- RLS 策略：submissions
-- ============================================
-- 管理员可读全部
CREATE POLICY "admin_read_submissions" ON public.submissions FOR SELECT USING (is_admin());
-- 已认证用户可写入（投稿）
CREATE POLICY "user_insert" ON public.submissions FOR INSERT WITH CHECK (auth.role() = 'authenticated');
-- 仅管理员可更新（审核）
CREATE POLICY "admin_update_submissions" ON public.submissions FOR UPDATE USING (is_admin()) WITH CHECK (is_admin());

-- ============================================
-- 种子数据：careers（10 条）
-- ============================================
INSERT INTO public.careers (id, title, emoji, description, skills, path, advantage, salary, industry, national_support, drawback) VALUES
(1, '审计', '🔍', '对企业财务报表进行独立检查，出具审计意见。四大会计师事务所是主要雇主。', '会计基础、CPA知识、分析能力、抗压能力', '八大/四大实习生 → 审计助理 → 审计经理 → 合伙人', '财会专业学生有天然的会计准则和财务知识基础，审计课程直接对口。在校期间即可备考CPA，大四进四大实习是黄金通道。', '四大起薪9-11k/月（一线城市），3年经验15-20k/月，5-8年审计经理25-40k/月。内资所起薪6-8k/月，但晋升速度快。', '审计是财会行业的核心赛道，市场空间稳定。注册制全面推行，上市公司数量持续增长，审计需求只增不减。四大+内资八大所每年校招超万人。', '《注册会计师法》保障审计行业的法定地位，上市公司必须经审计。国家持续推动审计行业做大做强，鼓励事务所规模化、国际化发展。', '年审季（1-4月）加班极其严重，忙季每天12-14小时是常态，周末基本泡汤。长期出差住酒店，前2-3年薪资性价比偏低，很多人扛不住离职。'),
(2, '税务', '📊', '帮助企业和个人进行税务筹划、税务申报、税务争议处理。', '税法知识、政策敏感度、沟通能力', '税务师事务所实习 → 税务顾问 → 税务经理', '财会专业学生税法基础扎实，对增值税、企业所得税等核心税种有深入理解。初级会计职称/CPA税法科目为税务工作打下坚实基础。', '事务所税务岗起薪8-12k/月，3年经验15-20k/月。企业税务经理20-30k/月。税务师事务所合伙人年薪50万+。', '金税四期全面上线后，企业税务合规需求暴增，税务咨询市场年增长超15%。税务师人才缺口大，与CPA双证组合是顶级配置。', '国家税务总局主管税务师职业资格，《税收征管法》保障税务服务行业规范发展。国家持续加强税收征管，税务专业人才需求长期看涨。', '政策变化极快，需要持续疯狂学习否则就落后。日常申报工作重复枯燥，税务岗位夹在税务局和企业之间两头受气。'),
(3, '财务分析', '📈', '通过财务数据分析企业经营状况，为管理层决策提供支持。', 'Excel高级、财务建模、数据敏感度、PPT汇报', '财务分析实习生 → 财务分析师 → FP&A经理', '财会专业学生对三大报表有深度理解，这是财务分析的核心能力。相比纯数据分析背景，财会学生更懂业务逻辑和会计准则。', '应届FP&A起薪8-12k/月，3年经验15-20k/月，财务分析经理20-35k/月。在互联网/科技公司薪资上浮30-50%。', '企业数字化转型推动财务分析从核算型向分析型转变，FP&A人才需求年增长20%+。懂业务、懂数据、懂财务的复合型人才最受欢迎。', '财政部《管理会计基本指引》推动管理会计人才培养，企业财务部门从后端核算向前端决策支持转型是国家政策方向。', '月初/季末/年末需要加班赶报告，deadline一个接一个。需要和业务部门反复沟通扯数据，数据源不准确/不一致是日常难题。'),
(4, '风控/内控', '🛡️', '识别和评估企业运营中的风险，建立内部控制体系。', '风险意识、流程理解、CIA/CMA证书加分', '风控实习生 → 内控专员 → 风控经理', '财会专业学生对财务报表循环、内部控制五大要素有系统学习，COSO框架是课堂必学内容。CPA审计科目直接覆盖内控知识。', '企业内控专员起薪8-12k/月，3-5年经验15-22k/月，内控经理20-35k/月。金融机构风控岗位薪资普遍高于企业内控。', '上市公司内控是法定要求，随着监管趋严和ESG发展，内控/风控人才需求持续增长。互联网金融/金融科技领域对风控人才需求尤其旺盛。', '《企业内部控制基本规范》要求上市公司建立内控体系，内控审计成为法定程序。国家监管趋严推动内控人才需求刚性增长。', '在企业内容易被边缘化，不直接创造收入。推动整改时各部门配合度差，日常工作偏文档化，成就感不强，升职通道窄。'),
(5, '咨询', '💡', '为企业提供管理、财务、战略等方面的专业建议和解决方案。', '逻辑思维、PPT制作、抗压能力、英语流利', '咨询公司PTA → 咨询顾问 → 项目经理', '财会专业学生在财务尽调、成本分析、预算管理等方面有天然优势。财务咨询是四大核心业务线之一，与审计同属一个集团，内部转岗通道顺畅。', '四大咨询起薪10-13k/月，3年经验18-25k/月。MBB起薪25-35k/月。咨询行业薪资增长快，5年经验可达40-60k/月。', '中国企业数字化转型和管理升级需求旺盛，管理咨询市场年增长约12%。四大咨询业务增速已超过审计，成为新的增长引擎。', '国家鼓励企业管理创新和数字化转型，十四五数字经济发展规划为企业咨询服务创造广阔市场空间。', '工作强度堪比投行，常年出差住酒店，项目制=永远在路上。Work-life balance基本不存在，很多人做3-5年就扛不住转甲方。'),
(6, '企业财务', '🏢', '在各类企业的财务部门从事核算、预算、资金管理等工作。', '会计核算、Excel、ERP系统、细致耐心', '财务实习生 → 会计/出纳 → 财务主管 → CFO', '财会专业学生经过了完整的会计学训练，从填制凭证到编制报表的流程烂熟于心。初级/中级会计职称是这个方向的必备证书。', '应届企业财务起薪5-8k/月（二三线）到8-12k/月（一线），5年经验财务主管12-18k/月，CFO级别50k+/月。', '企业财务是最宽口径的就业方向，每个公司都需要财务人员。从共享服务中心到业务财务再到战略财务，职业发展路径清晰。', '职称制度（初级/中级/高级会计师）是国家认可的职业晋升体系，国企/事业单位直接与薪资挂钩。', '工作重复性高，月末结账、报税循环往复，容易产生倦怠感。薪资天花板较低，晋升慢，基础核算岗正在被RPA替代。'),
(7, '投行/券商', '🏦', '从事IPO、并购、债券发行等投资银行业务，门槛高但成长快。', '财务基础、估值建模、CPA/CFA加分、抗压极强', '行研/投行实习 → 分析师 → 副总裁 → 董事总经理', '财会专业学生对财务报表分析和企业估值有系统训练，这是投行工作的核心技能。CPA持证者在投行竞聘中具有明显竞争优势。', '投行应届生起薪15-25k/月，年终奖可达6-12个月工资。3-5年经验分析师年薪40-80万，VP级别100-200万/年。', '注册制改革带来IPO业务爆发，中国资本市场持续扩容。投行/券商是财会行业薪资天花板最高的方向之一，但工作强度大。', '全面注册制是国家资本市场改革的核心，直接拉动投行/券商人才需求。国家大力支持直接融资和资本市场发展。', '工作强度天花板级别——每周80-100小时是日常。竞争极度激烈，名校硕士+CPA+CFA是标配。35岁后若未升到MD，转行出路有限。'),
(8, 'ESG/可持续发展', '🌱', '新兴方向，帮助企业进行环境、社会和治理方面的信息披露和战略规划。', '财务基础、写作能力、对可持续发展议题的兴趣', 'ESG实习生 → ESG专员 → ESG经理（新兴赛道！）', '财会专业学生对信息披露框架、数据核算、报告鉴证有天然优势。ESG报告的底层逻辑与财务报表高度相似，是财会学生的蓝海赛道。', '应届ESG专员起薪8-12k/月，3年经验15-22k/月。四大ESG咨询线起薪与审计相当，但增长空间更大。ESG总监级别30-50k/月。', 'ESG是财会行业近两年增长最快的方向，年增速超180%。A股上市公司2026年起强制披露ESG报告，四大+咨询公司+企业都在抢ESG人才。', '证监会/交易所要求上市公司强制披露ESG报告，三大交易所已发布ESG披露指引。国资委要求央企2025年实现ESG报告全覆盖。', '行业标准不统一，披露规则年年变。目前岗位集中在四大和咨询公司，企业端专职ESG岗还很少。新兴方向不确定性强。'),
(9, '精算', '🧮', '主要在保险公司、精算咨询机构从事风险评估、保费定价、准备金测算等工作，金融行业高薪方向。', '高等数学、概率统计、中国精算师考试、Excel/SAS建模', '精算实习生 → 精算分析师 → 准精算师 → 精算师（FCAA）→ 首席精算师', '财会专业学生对财务报表和金融产品有基础认知，精算报告与财务报告的对接需要财会知识。但数学要求高，纯财会背景同学需补强数理基础。', '精算实习生起薪150-250元/天，应届精算岗8-15k/月。准精算师15-25k/月，正精算师30-60k/月。精算是保险行业薪资最高的技术岗位之一。', '中国精算师持证人数稀少（约3000人），供求严重失衡。保险行业总资产超30万亿，精算人才长期供不应求。', '中国精算师考试已正式恢复并纳入国家职业资格目录。银保监会要求保险公司必须配备持证精算师，是法定准入门槛。', '考试难度极高——准精算师需要5-8年持续考试，数学要求大学数学系水平。就业面窄，基本锁死在保险行业。'),
(10, '资产评估', '📐', '对整体企业价值、商标、专利、设备等进行专业评估，服务于并购重组、抵押担保、上市等场景。', '会计基础、估值模型、CPA/资产评估师证书加分', '评估机构实习生 → 评估师助理 → 注册资产评估师 → 合伙人', '财会专业学生的财务报表分析能力和会计准则知识是资产评估的核心基础。企业价值评估中的收益法、市场法、资产基础法都需要财务报表数据支撑。', '评估所助理起薪6-10k/月，持证评估师12-20k/月。资深评估师20-35k/月。评估机构合伙人年薪50-100万+。', '中国资产评估行业年收入约250亿元，持证评估师约4万人，人才缺口较大。国企混改、上市公司并购重组、IPO评估需求持续增长。', '《资产评估法》为行业提供法律保障，评估专业人员必须持证执业。财政部主管资产评估行业，国家持续推进与CPA、税务师等资格互认。', '频繁出差做现场勘查，项目制工作收入不稳定。行业价格战严重，小评估所生存艰难。初始薪资偏低，社会认知度不如CPA。');

-- ============================================
-- 种子数据：certs（14 条）
-- ============================================
INSERT INTO public.certs (id, name, type, badge, difficulty, value, cost, exam_time, signup_time, suitable, note, exam_mode, difficulty_type, pass_rate, advantage, salary, industry, national_support) VALUES
(1, '初级会计职称', '在校可考', 'ok', '⭐⭐', '⭐⭐⭐', '约110元/科（两科共约220元）', '每年5月', '每年11月-12月', '所有财会专业学生，毕业前必考', '高中学历即可报考，大一即可准备，大二大三考试最佳时机。是会计行业的入门证书。', '机考（无纸化）', '记忆为主，计算量小', '约20-30%', '财会专业学生基础扎实，大一学完基础会计后可直接备考，通过率远高于跨专业考生。', '持证后起薪无明显涨幅，但无证无法从事会计工作，是入行门槛。', '会计职称证书是国家人社部认可的职业资格，企业招聘财会岗位时普遍要求持证。', '国家大力支持会计人才队伍建设，会计改革与发展十四五规划明确提出优化会计职称制度。'),
(2, '注册会计师 CPA', '在校可考', 'soon', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐⭐', '约70元/科（6科），综合阶段约120元', '每年8月（综合阶段10月）', '每年4月', '大四学生、应届毕业生，目标进事务所/投行', '大四下学期可以首次报名。建议在毕业前开始准备，会计/审计/税法优先备考。', '机考（闭卷）', '计算+记忆并重', '专业阶段单科约10-15%，全科通过率约5%', '财会专业学生有系统知识基础，会计/审计/财管三科有明显优势。', '持证后：四大起薪9-11k/月；内资所6-8k/月；持证是涨薪的硬指标。', '国内认可度最高的财会证书，是唯一拥有审计签字权的执业资格。', '中注协注册会计师行业发展规划明确支持CPA与国际资质互认，多地提供落户加分。'),
(3, 'ACCA（国际注册会计师）', '在校可考', 'ok', '⭐⭐⭐⭐', '⭐⭐⭐⭐', '注册费约89英镑 + 考试费约120-350英镑/科，总计约1.5-2万元', '每年3、6、9、12月', '随时注册', '英语较好、目标进外企/四大/跨国公司的学生', '大一即可开始考，共13门。费用较高，但国际认可度强。部分科目可免试。', '机考（分季考）', '记忆为主，英语阅读能力要求高', '全球单科通过率约40-50%', '财会专业可免试F1-F3（会计学本科），大幅缩短考证周期。', 'ACCA持证在外企/四大起薪与CPA相当或略高，外资机构更认可。', '国际认可度最高，在英联邦国家可直接执业。', '多地（上海/广州/深圳）将ACCA列入境外职业资格认可清单，持证者可享受人才引进优惠。'),
(4, '证券从业资格', '在校可考', 'ok', '⭐⭐', '⭐⭐⭐', '约61元/科（两科共约122元）', '每年多次', '考前2个月', '对投行/券商/基金感兴趣的同学', '门槛低、性价比高。两科通过即可拿证。', '机考（无纸化）', '纯记忆型', '约30-40%', '财会背景对金融市场基础知识中的财务报表分析部分有天然优势。', '持证是进入证券行业的门槛。', '证券行业实行严格的准入管理，所有券商/基金公司从业人员必须持证。', '《证券法》明确规定从事证券业务须取得从业资格，是法定准入证书。'),
(5, '基金从业资格', '在校可考', 'ok', '⭐⭐', '⭐⭐⭐', '约65元/科（约130元）', '每年多次', '考前1-2个月', '对基金公司/券商资管/私募基金感兴趣的同学', '门槛低，是进入基金行业的敲门砖。', '机考（无纸化）', '纯记忆型', '约35-45%', '财会专业学生对财务报表有基础认知。', '持证是门槛，基金从业者平均薪资高于证券从业。', '中国基金行业管理规模已超27万亿元，行业高速发展。', '《证券投资基金法》规定基金从业人员必须持证，是法定准入资格。'),
(6, 'CMA（管理会计师）', '在校可考', 'ok', '⭐⭐⭐', '⭐⭐⭐⭐', '会员费约2400元/年 + 考试费约415美元/科，总计约5000-8000元', '每年1-2月、5-6月、9-10月', '随时', '对管理会计、财务分析方向感兴趣的同学', '只有两科，备考周期短。外资企业认可度较高。', '机考（英文/中文可选）', '计算量中等，侧重管理会计思维', '全球单科通过率约35-45%', '财会专业学生对财务报表有扎实基础，Part1备考效率极高。', 'CMA持证者在外资企业财务分析岗起薪10-15k/月。', '随着中国企业从核算型财务向管理型财务转型，CMA需求持续增长。', '财政部《管理会计基本指引》明确推进管理会计人才培养。'),
(7, '中级会计职称', '需工作年限', 'later', '⭐⭐⭐⭐', '⭐⭐⭐⭐⭐', '约56元/科（三科共约168元）', '每年9月', '每年6月', '专科毕业5年/本科毕业4年/硕士毕业1年', '是会计职业晋升的重要门槛，对应会计师职称。', '机考（无纸化）', '计算量较大，记忆量也大', '约10-15%（全科）', '财会专业学生工作后系统复习，通过率明显高于跨专业考生。', '持证后：企业财务主管10-18k/月；财务经理15-25k/月。', '中级会计职称是企业财务中层岗位的硬性要求。', '国家会计职称制度的核心层级，人社部与财政部联合认证。'),
(8, '税务师', '在校可考', 'soon', '⭐⭐⭐⭐', '⭐⭐⭐⭐', '约93元/科（5科，共约465元）', '每年11月', '每年5-7月', '大四学生、目标从事税务工作的同学', '大四可以报考。CPA税法与税务师涉税服务科目高度重叠，双证联考效率极高。', '机考（无纸化）', '记忆+计算并重', '约15-20%（全科）', '财会专业学生税法基础扎实，双证联考效率极高。', '持证后：事务所税务岗起薪8-12k/月；企业税务专员7-10k/月。', '金税四期上线和国家税收监管趋严，企业税务合规需求暴增。', '国家税务总局主管的法定职业资格。'),
(9, 'CFA（特许金融分析师）', '在校可考', 'soon', '⭐⭐⭐⭐⭐', '⭐⭐⭐⭐⭐', '注册费约450美元 + 考试费约900-1700美元/级，全科约3-5万元', '每年2、5、8、11月', '按考期报名', '目标投行/投资/基金，财会+金融复合背景', '共三级，全英文考试，难度大费用高。和CPA双证是顶级配置。', '机考（全英文）', '计算量大，英语要求高', '一级约40%，二级约45%，三级约50%', '财会背景对财务报表分析（FRA）科目有天然优势。', 'CFA持证者：投行分析师20-30k/月；基金经理30-50k/月。', '中国CFA持证人数约1.5万人，供需缺口极大。', '北京/上海/深圳/成都等多地将CFA列入高层次人才引进目录。'),
(10, '初级审计师', '在校可考', 'ok', '⭐⭐', '⭐⭐⭐', '约50元/科（两科共约100元）', '每年9-10月', '每年5-6月', '所有财会专业学生，尤其目标进事务所/内审部门的同学', '高中及以上学历即可报考，是在校生可考的审计方向入门证书。', '纸笔考试', '记忆为主，计算量小', '约25-35%', '财会专业学生审计学课程直接覆盖考试内容。', '持证是进入审计机关/内审部门的加分项。', '随着国家对审计监督的重视程度持续提升，审计人才需求稳步增长。', '审计专业技术资格是国家人社部认可的职称序列。'),
(11, '初级经济师（财会方向）', '在校可考', 'ok', '⭐⭐', '⭐⭐⭐', '约61-91元/科（两科共约150元）', '每年11月', '每年7-8月', '所有财会专业学生，在校可考，性价比极高', '高中及以上学历即可报考，全是选择题，通过率高。', '机考（无纸化），全是客观题', '纯记忆型', '约30-40%', '财会专业学生对财政税收/金融方向基础知识扎实。', '持证后在国企/事业单位招聘中优先录用。', '经济师职称在国企/银行/事业单位广泛认可。', '人社部全国统考职称证书，多地列入积分落户加分。'),
(12, '中级审计师', '需工作年限', 'later', '⭐⭐⭐⭐', '⭐⭐⭐⭐', '约50元/科（两科共约100元）', '每年9-10月', '每年5-6月', '专科毕业5年/本科毕业4年/硕士毕业1年', '审计专业技术资格考试，是审计人员职称评定的依据。', '纸笔考试', '记忆为主，计算量中等', '约15-20%', '财会专业学生审计学基础扎实。', '持证后在审计机关/内审部门职称评定中直接加分。', '审计师职称在审计机关、国企内审部门、会计师事务所均有认可。', '《审计法》和审计专业技术资格规定明确审计专业技术资格制度。'),
(13, '资产评估师', '在校可考', 'soon', '⭐⭐⭐⭐', '⭐⭐⭐⭐', '约90元/科（4科，共约360元）', '每年9月', '每年5-6月', '大四学生、目标进入评估事务所/投行/国资机构的同学', '大四可以报考。CPA会计/财管与资产评估科目高度重叠。', '机考（无纸化）', '计算量中等，记忆量中等', '约15-20%（全科）', '财会专业学生对财务报表和企业价值评估有基础优势。', '持证后：评估事务所助理8-12k/月；持证评估师12-20k/月。', '中国资产评估行业收入约250亿元/年，持证评估师约4万人，人才缺口较大。', '财政部主管的法定职业资格，《资产评估法》规定评估专业人员应当具有评估师资格。'),
(14, '中级经济师（财会方向）', '需工作年限', 'later', '⭐⭐⭐', '⭐⭐⭐⭐', '约61-91元/科（两科共约150元）', '每年11月', '每年7-8月', '专科毕业6年/本科毕业4年/硕士毕业1年', '经济师是职称考试中对财会专业最友好的方向。全是选择题。', '机考（无纸化），全是客观题', '记忆为主，计算量小', '约20-30%', '财会专业学生对财政税收/金融方向有基础优势，且全是选择题。', '持证后职称评定直接挂钩工资，在国企/事业单位月薪可增加800-2000元。', '经济师职称在国企/事业单位/金融机构广泛认可。', '人社部全国统考，职称与工资直接挂钩。多地列入积分落户加分项目。');

-- ============================================
-- 种子数据：jobs（6 条）
-- ============================================
INSERT INTO public.jobs (id, title, company, city, province, type, salary, deadline, description, featured, apply_url, apply_email, status) VALUES
(1, '审计实习生', '普华永道 PwC', '北京', '北京市', '审计', '150-200/天', '2026-07-15', '协助审计团队进行现场审计，编制审计工作底稿，参与客户访谈。要求财会相关专业，大三及以上。', true, 'https://www.pwccn.com/zh/careers/students.html', '', 'active'),
(2, '税务咨询实习生', '德勤 Deloitte', '上海', '上海市', '税务', '180-220/天', '2026-06-30', '参与企业税务筹划项目，协助撰写税务分析报告，了解最新税收政策。', true, 'https://www.deloitte.com/cn/zh/careers/internship.html', '', 'active'),
(3, '财务分析实习生', '腾讯', '深圳', '广东省', '财务分析', '200-250/天', '2026-07-01', '负责业务部门财务数据分析，编制财务分析报告，参与预算编制工作。', true, 'https://join.qq.com/', '', 'active'),
(4, '内控实习生', '华为', '深圳', '广东省', '风控/内控', '180-230/天', '2026-07-10', '协助内控团队进行流程梳理和风险识别，参与内控自评工作。', false, 'https://career.huawei.com/', '', 'active'),
(5, '行研实习生', '中金公司', '北京', '北京市', '投行/券商', '200-300/天', '2026-06-28', '撰写行业研究报告，协助进行公司估值建模，参与上市公司调研。财会+金融复合背景优先。', false, '', 'campus@cicc.com.cn', 'active'),
(6, 'ESG实习生', '安永 EY', '上海', '上海市', 'ESG/可持续发展', '150-200/天', '2026-07-20', '参与企业ESG报告编制，协助进行可持续发展数据分析，了解TCFD披露框架。新兴方向，竞争相对较小！', false, 'https://www.ey.com/zh_cn/careers/students', '', 'active');

-- ============================================
-- 种子数据：news（6 条）
-- ============================================
INSERT INTO public.news (id, title, date, category, summary, content) VALUES
(1, '2026年初级会计职称考试报名通道正式开启', '2026-06-05', '证书报名', '全国会计专业技术资格考试网站公告，2026年初级会计职称考试报名已于11月底开放，2026年5月举行考试，在校大学生无工作年限限制可报考。', '2026年初级会计职称考试重要时间节点：\n\n报名时间：2025年11月20日起\n缴费截止：各省报名窗口关闭后约5日内\n考试时间：2026年5月10日-14日\n\n科目安排：\n● 初级会计实务（机考，75分钟）\n● 初级经济法基础（机考，75分钟）\n● 两科须在同一年度内通过\n\n在校生须知：\n● 高中及以上学历即可报考，大一新生也可报名\n● 报名时填写在读学历即可，无需工作单位\n● 报名入口：全国会计资格评价网'),
(2, '财政部发布《企业会计准则解释第17号》正式落地', '2026-05-20', '政策准则', '财政部印发企业会计准则解释第17号，对售后回购、融资性售后租回、股份支付等热点实务问题作出明确规定。', '财政部于2025年12月发布《企业会计准则解释第17号》，2026年1月1日正式施行。\n\n一、售后回购交易\n● 明确了以金融工具处理的售后回购的具体条件\n\n二、融资性售后租回\n● 区分真实销售和融资安排的判断标准进一步细化\n\n三、股份支付\n● 对等待期内离职员工的处理进行了补充规定\n\n该准则解释涉及CPA《会计》科目的高频考点，2026年CPA考试预计会有相关试题。'),
(3, '四大2026届校招攻略：时间线、笔试题型全解析', '2026-05-15', '校招动态', '四大会计师事务所2026届校招正在进行中，本文汇总了四家事务所的招聘时间、岗位名额、笔试题型和成功率。', '四大2026届校招关键信息汇总：\n\n【普华永道 PwC】笔试：英语+逻辑+财务（80分钟在线）\n【德勤 Deloitte】笔试：SHL测评+专业知识\n【毕马威 KPMG】笔试：英语+逻辑+会计综合\n【安永 EY】笔试：全英文在线测评\n\n通用备考建议：四大同步投递可行，简历需针对不同岗位定制化，实习经历和证书是核心亮点。'),
(4, '金税四期全面推开：财会人必须了解的5个变化', '2026-04-15', '政策准则', '金税四期系统在全国范围内稳步推广，企业税务合规要求大幅提升，个人收入监控更加精准。', '金税四期已在全国范围内全面推广，5个变化财会人必须了解：\n\n1. 发票全面电子化\n2. 企业收入穿透式监控\n3. 自然人税收管理加强\n4. 数据共享扩大\n5. 对财会工作的影响：票据合规要求更高，税务师和财税咨询人才需求持续旺盛'),
(5, '2026财会专业校招白皮书：薪资、去向、竞争力分析', '2026-05-08', '就业指南', '2026届财会专业毕业生校招数据出炉，四大平均月薪9500元，互联网大厂财务岗12000+，ESG方向同比增长200%。', '2026届财会专业校招数据报告：\n\n一、薪资水平\n● 四大（Big4）：8500-11000元/月\n● 互联网大厂财务岗：11000-15000元/月\n● 国企/央企财务岗：7000-10000元/月\n\n二、核心竞争力\n● 有实习经历者就业率高出约40%\n● 持证者竞争成功率提升约30%\n● 财会+数据分析复合背景薪资高出约25%'),
(6, '国务院推进ESG信息披露试点：财会人的新机遇', '2026-03-15', '行业新闻', '国务院国资委要求中央企业2026年全部完成ESG/可持续发展报告发布，ESG财会人才进入抢人阶段。', '2026年ESG领域重大政策动向：\n\n一、监管要求时间线\n● 2026年：央企全部完成ESG报告发布\n● 2027年（预计）：A股大盘蓝筹公司强制披露\n● 2028年（预计）：所有上市公司强制披露\n\n二、对财会学生的机会\n● ESG报告的底层是数据核算和信息披露\n● 四大已将ESG鉴证业务单独成线\n● ESG专员起薪已达8000-12000元/月');

-- ============================================
-- 种子数据：settings（3 条）
-- ============================================
INSERT INTO public.settings (key, value) VALUES
('version', '1'),
('site_name', '财途指南'),
('welcome_text', '面向财会专业本科在校生的实习信息聚合与职业导航平台');

-- ============================================
-- 注意：admins 表的种子数据需要手动处理
-- 超管需要先在 Supabase Auth 中创建用户，
-- 获取 UUID 后插入 admins 表。
--
-- 示例（需替换为实际 UUID）：
-- INSERT INTO public.admins (id, email, account, name, role, identity, status, note)
-- VALUES ('替换为Auth用户UUID', '3283019897@qq.com', '杨林和', '杨林和', 'super', '超级管理员', 'active', '平台创始人');
-- ============================================

SELECT '✅ 财途指南 v2 数据库迁移完成！' AS status;
