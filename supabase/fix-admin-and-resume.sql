-- ============================================
-- 财途指南 v2 - 补丁：管理员 + resume_tips + GRANT
-- ============================================

-- 1. 插入超级管理员（UUID 来自 Supabase Auth 注册的用户）
INSERT INTO public.admins (id, email, account, name, role, identity, status, note)
VALUES ('76819242-3361-49f0-898b-c91a8f497ffb', '3283019897@qq.com', '杨林和', '杨林和', 'super', '超级管理员', 'active', '平台创始人')
ON CONFLICT (id) DO NOTHING;

-- 2. 重建 resume_tips 表（原迁移中被删除了）
CREATE TABLE IF NOT EXISTS public.resume_tips (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('误区', '建议')),
  content TEXT NOT NULL,
  status TEXT DEFAULT 'published' CHECK (status IN ('published', 'draft')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS 策略
ALTER TABLE public.resume_tips ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public_read_tips" ON public.resume_tips FOR SELECT USING (true);
CREATE POLICY "admin_write_tips" ON public.resume_tips FOR ALL USING (is_admin()) WITH CHECK (is_admin());

-- 种子数据：7条简历提示
INSERT INTO public.resume_tips (id, title, category, content, status) VALUES
(1, '误区一：把"熟练使用Office"当成技能亮点', '误区', '改法：具体说明"能使用Excel制作财务报表、数据透视表"，"能用Word排版专业报告"。展现你实际能做什么，而不是笼统地说"熟练"。', 'published'),
(2, '误区二：堆砌课程名称，没有展现实际能力', '误区', '改法：学完"财务会计"就写"掌握企业会计准则，能独立编制三大报表"，学完"税法"就写"了解增值税和企业所得税实务"。把课程转化成技能。', 'published'),
(3, '误区三：过于强调校内经历和竞赛项目', '误区', '改法：HR更看重你能否上岗做事、能否创造价值，而非校园评价体系里的"好学生"。校内经历挑1-2个最相关的写，把篇幅留给实习经历、项目经验和实际技能。', 'published'),
(4, '建议一：用数据说话，量化你的成果', '建议', '不要写"参与审计项目"，写成"参与3个上市公司年报审计项目，独立完成6家子公司底稿编制"。数字让HR一眼看到你的实际贡献。', 'published'),
(5, '建议二：根据投递方向定制简历关键词', '建议', '投审计岗要突出"审计流程""底稿编制""内控测试"；投财务分析岗要突出"财务报表分析""Excel建模""数据可视化"。不同岗位用不同版本。', 'published'),
(6, '建议三：证书是财会简历的硬通货，放在显眼位置', '建议', '初级会计职称、CPA通过科目、ACCA通过科目——这些是HR筛选简历的第一眼关键词。正在备考也要写上，标注"CPA备考中（已通过X科）"。', 'published'),
(7, '建议四：STAR法则组织实习经历', '建议', '情境(Situation) → 任务(Task) → 行动(Action) → 结果(Result)。例如："协助税务团队（S）完成季度增值税申报（T），独立整理200+条进项发票数据并用Excel做比对分析（A），将申报准备时间从3天缩短到1.5天（R）。"', 'published')
ON CONFLICT (id) DO NOTHING;

-- 3. GRANT 权限（补充新表的权限）
GRANT SELECT ON public.resume_tips TO anon;
GRANT SELECT ON public.resume_tips TO authenticated;
GRANT ALL ON public.resume_tips TO authenticated;

GRANT SELECT ON public.users TO anon;
GRANT SELECT ON public.users TO authenticated;
GRANT ALL ON public.users TO authenticated;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- 4. 确认 admins 表也有 GRANT（已认证用户需要能读自己是否是管理员）
GRANT SELECT ON public.admins TO authenticated;

SELECT '✅ 补丁执行完成！管理员已创建 + resume_tips 表已重建 + GRANT 权限已补充' AS status;
