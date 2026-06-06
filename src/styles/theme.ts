import type { GlobalThemeOverrides } from 'naive-ui'

export const themeOverrides: GlobalThemeOverrides = {
  common: {
    primaryColor: '#2563EB',
    primaryColorHover: '#1D4ED8',
    primaryColorPressed: '#1E40AF',
    primaryColorSuppl: '#3B82F6',
    successColor: '#22C55E',
    successColorHover: '#16A34A',
    successColorPressed: '#15803D',
    warningColor: '#F59E0B',
    warningColorHover: '#D97706',
    warningColorPressed: '#B45309',
    errorColor: '#EF4444',
    errorColorHover: '#DC2626',
    errorColorPressed: '#B91C1C',
    borderRadius: '8px',
    borderRadiusSmall: '6px',
    fontFamily: 'system-ui, PingFang SC, Microsoft YaHei, sans-serif',
    fontSize: '15px',
    lineHeight: '1.6',
    bodyColor: '#F9FAFB',
    cardColor: '#FFFFFF',
    textColorBase: '#1F2937',
    textColor1: '#1F2937',
    textColor2: '#374151',
    textColor3: '#6B7280',
  },
  Card: {
    borderRadius: '12px',
    boxShadow: '0 1px 3px rgba(0,0,0,0.08)',
  },
  Button: {
    borderRadiusMedium: '8px',
    borderRadiusSmall: '6px',
  },
  Tag: {
    borderRadius: '6px',
  },
}
