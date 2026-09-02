// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import mermaid from 'astro-mermaid';
import rehypeKatex from 'rehype-katex';
import remarkMath from 'remark-math';

export default defineConfig({
  // Mirrors project/astro.config.mjs.jinja: docs live under docs/, not src/.
  srcDir: './docs',
  // Astro's default `dist/` is where `uv build` writes wheels.
  outDir: './site',
  integrations: [
    mermaid(),
    starlight({
      title: 'Copier Modern ML',
      description: 'Copier template for modern machine learning projects',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/appleparan/copier-modern-ml' },
      ],
      customCss: ['katex/dist/katex.min.css'],
      sidebar: [{ label: 'Home', link: '/' }],
    }),
  ],
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
});
