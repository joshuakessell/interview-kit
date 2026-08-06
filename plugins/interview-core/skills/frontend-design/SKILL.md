---
name: frontend-design
description: Make a timed-build UI look intentional instead of AI-generated. Use whenever building or polishing UI, pages, components, layouts, or when the user asks to make it look good, polish, or improve UX.
---

# UI That Doesn't Look Like a 2-Hour Build

(Replace this file with your own frontend-design skill if you have a better one — this is
the standalone fallback.)

## Ten minutes of polish, in priority order

1. **One typeface, real scale.** Load a single distinctive font (Inter is the AI-slop
   default — pick Geist, Instrument Sans, or Space Grotesk instead). Type scale: 14/16 body,
   ~24 section, ~36-48 page title. Nothing between.
2. **Commit to a palette of three.** One neutral ramp, one accent, one semantic
   (destructive). Define as CSS variables up front; never inline hex mid-build.
3. **Spacing on a 4px grid, generous by default.** Cramped spacing is the #1 tell of a
   rushed build. p-6 minimum on cards, gap-6 between sections.
4. **States are features.** Empty state with one line of guidance, loading skeleton or
   spinner, visible error state. An app with graceful states reads as finished; a perfect
   happy path with a blank error console does not.
5. **Alignment beats decoration.** Max-width container (~640-960px for tools), consistent
   left edge, one card style. No gradients-because-AI, no glassmorphism, no three different
   border radii.
6. **Dark-on-light unless the domain says otherwise.** Dark mode is a stretch goal, never a
   starting point.

## shadcn/ui usage

Add only the components actually used (`pnpm dlx shadcn@latest add button card input`).
Restyle the accent color immediately so it doesn't ship stock — stock shadcn is
recognizable at a glance.
