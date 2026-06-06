-- ============================================
-- 财途指南 v2 - 修复 GRANT 权限
-- 原迁移 SQL 缺少对 anon/authenticated 角色的授权
-- 导致前端无法读取数据（permission denied）
-- ============================================

-- 内容表：anon 可读，authenticated 可读
GRANT SELECT ON public.careers TO anon;
GRANT SELECT ON public.careers TO authenticated;
GRANT ALL ON public.careers TO authenticated;

GRANT SELECT ON public.certs TO anon;
GRANT SELECT ON public.certs TO authenticated;
GRANT ALL ON public.certs TO authenticated;

GRANT SELECT ON public.news TO anon;
GRANT SELECT ON public.news TO authenticated;
GRANT ALL ON public.news TO authenticated;

GRANT SELECT ON public.jobs TO anon;
GRANT SELECT ON public.jobs TO authenticated;
GRANT ALL ON public.jobs TO authenticated;

GRANT SELECT ON public.settings TO anon;
GRANT SELECT ON public.settings TO authenticated;
GRANT ALL ON public.settings TO authenticated;

-- users 表：anon 可读（脱敏），authenticated 可读写自己的
GRANT SELECT ON public.users TO anon;
GRANT SELECT ON public.users TO authenticated;
GRANT ALL ON public.users TO authenticated;

-- admins 表：仅 authenticated 可读（通过 RLS 限制为管理员）
GRANT SELECT ON public.admins TO authenticated;
GRANT ALL ON public.admins TO authenticated;

-- submissions 表：authenticated 可插入（投稿）和读（管理员通过 RLS 限制）
GRANT SELECT ON public.submissions TO authenticated;
GRANT INSERT ON public.submissions TO authenticated;
GRANT ALL ON public.submissions TO authenticated;

-- 序列权限（SERIAL 主键需要）
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

SELECT '✅ GRANT 权限修复完成！' AS status;
