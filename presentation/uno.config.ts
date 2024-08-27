import type {
  Preset,
} from 'unocss'
import {
  defineConfig,
  presetWind,
  presetWebFonts,
  transformerDirectives,
  transformerVariantGroup,
} from 'unocss'

export default defineConfig({
  presets: [
    presetWebFonts({
      provider: 'google',
      fonts: {
        mono: 'Noto Sans Mono',
        sans: 'Noto Sans',
      },
    }) as unknown as Preset,
    presetWind() as unknown as Preset,
  ],
  transformers: [transformerDirectives(), transformerVariantGroup()],
})
