import { ref, computed } from 'vue'
import { supabase } from '@/config/supabase'
import { useDataStore } from '@/stores/data'
import type { ResumeTip } from '@/types'

/** 硬编码兜底数据，与旧版 DEFAULT_RESUME_TIPS 一致 */
const FALLBACK_TIPS: ResumeTip[] = [
  {
    id: 1,
    title: '误区一：把"熟练使用Office"当成技能亮点',
    category: '误区',
    content: '改法：具体说明"能使用Excel制作财务报表、数据透视表"，"能用Word排版专业报告"。展现你实际能做什么，而不是笼统地说"熟练"。',
  },
  {
    id: 2,
    title: '误区二：堆砌课程名称，没有展现实际能力',
    category: '误区',
    content: '改法：学完"财务会计"就写"掌握企业会计准则，能独立编制三大报表"，学完"税法"就写"了解增值税和企业所得税实务"。把课程转化成技能。',
  },
  {
    id: 3,
    title: '误区三：过于强调校内经历和竞赛项目',
    category: '误区',
    content: '改法：HR更看重你能否上岗做事、能否创造价值，而非校园评价体系里的"好学生"。校内经历挑1-2个最相关的写，把篇幅留给实习经历、项目经验和实际技能。',
  },
  {
    id: 4,
    title: '建议一：用数据说话，量化你的成果',
    category: '建议',
    content: '不要写"参与审计项目"，写成"参与3个上市公司年报审计项目，独立完成6家子公司底稿编制"。数字让HR一眼看到你的实际贡献。',
  },
  {
    id: 5,
    title: '建议二：根据投递方向定制简历关键词',
    category: '建议',
    content: '投审计岗要突出"审计流程""底稿编制""内控测试"；投财务分析岗要突出"财务报表分析""Excel建模""数据可视化"。不同岗位用不同版本。',
  },
  {
    id: 6,
    title: '建议三：证书是财会简历的硬通货，放在显眼位置',
    category: '建议',
    content: '初级会计职称、CPA通过科目、ACCA通过科目——这些是HR筛选简历的第一眼关键词。正在备考也要写上，标注"CPA备考中（已通过X科）"。',
  },
  {
    id: 7,
    title: '建议四：STAR法则组织实习经历',
    category: '建议',
    content: '情境(Situation) → 任务(Task) → 行动(Action) → 结果(Result)。例如："协助税务团队（S）完成季度增值税申报（T），独立整理200+条进项发票数据并用Excel做比对分析（A），将申报准备时间从3天缩短到1.5天（R）。"',
  },
]

export function useResumeTips() {
  const dataStore = useDataStore()
  const loading = ref(false)

  const resumeTips = computed(() => dataStore.resumeTips)

  async function fetchResumeTips() {
    loading.value = true
    try {
      const { data, error } = await supabase
        .from('resume_tips')
        .select('*')
        .order('id', { ascending: true })
      if (error) throw error
      if (data && data.length > 0) {
        dataStore.setResumeTips(data as ResumeTip[])
      } else {
        // 数据库无数据时使用兜底数据
        dataStore.setResumeTips(FALLBACK_TIPS)
      }
    } catch {
      // 查询失败时使用兜底数据
      dataStore.setResumeTips(FALLBACK_TIPS)
    } finally {
      loading.value = false
    }
  }

  return { resumeTips, loading, fetchResumeTips }
}
