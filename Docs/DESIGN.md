# Cyber-Oracle Editorial

## 1. Overview

This design system is built to move beyond a standard mobile UI and into the territory of a high-stakes digital ritual. The creative north star is **The Neon Ritual**: a fusion of ancestral mysticism and high-fidelity cyberpunk aesthetics.

To avoid a templated look, this system rejects rigid, equal-padding grids in favor of intentional asymmetry. Use massive typography, overlapping card elements, and bleeding neon glows to create depth and mystery. The interface should feel like a layered obsidian mirror, not a flat screen.

## 2. Creative North Star

### The Neon Ritual

- Fuse mystical atmosphere with high-contrast futuristic visuals.
- Favor intentional asymmetry over rigid symmetry.
- Let important elements feel illuminated, layered, and ceremonial.
- Build screens that feel editorial and atmospheric instead of utility-first.

### Core Layout Intent

- Break the template look with uneven alignment and offset supporting text.
- Use large type for answers and decisions.
- Allow cards and glows to overlap when it improves depth.
- Treat negative space as a structural tool, not empty filler.

## 3. Color System

The palette is rooted in the void, using neon as energy rather than decoration.

### Core Palette

- `surface`: `#0E0E0E`
- `void`: `#0D0D0D`
- `primary`: neon violet energy
- `primary_dim`: softened neon glow
- `primary_container`: deeper violet support tone
- `secondary_dim`: neon red for Savage Mode emphasis
- `tertiary`: gold accent for wealth and premium states

### The No-Line Rule

Do not use `1px` solid borders for sectioning. Boundaries must come from:

1. Background shifts between surface tiers.
2. Luminous outer glows using `primary_dim`.
3. Large negative space from the spacing system.

### Surface Hierarchy

Treat the interface like stacked volcanic glass:

- Base layer: `surface`
- Mid layer: `surface-container-low`
- Top layer: `surface-bright` or `surface-container-highest`

When nesting elements, the child card must always be brighter than its parent so it feels lifted toward the user.

### Glass and Gradient Rule

Use glassmorphism for floating modals and navigation bars.

- Background formula: `surface_variant` at `40%` opacity
- Backdrop blur: `20px`
- Overlay texture: linear gradient from `primary` to `primary_container` at `15%` opacity

This gradient should feel like a subtle digital pulse inside the card.

## 4. Typography

Use high-contrast editorial typography to balance authority and clarity.

### Font Roles

- `Space Grotesk`: display and headline voice, brutalist and commanding
- `Manrope`: body and title voice, geometric and readable
- `Plus Jakarta Sans`: labels, metadata, small anchors

### Scale Guidance

- Answer text should always use `headline-lg` or `display-sm` at minimum.
- Single-word answers can escalate to `display-lg`.
- Context, sarcasm, or supporting commentary should use `body-sm`.
- Supporting text should often sit asymmetrically, such as low and right of a headline.

### Editorial Rules

- The answer must be the strongest typographic element on screen.
- Favor bold contrast between giant type and tiny metadata.
- Let short answers dominate the canvas.

## 5. Elevation and Depth

Traditional drop shadows are too generic for this system. Use tonal layering and atmospheric diffusion.

### Layering Principle

- Elevation comes from stacking brighter surfaces on darker ones.
- A `surface-container-highest` button can sit on a `surface-container-low` card without needing a drop shadow.

### Ambient Glow

If a FAB or hero action needs emphasis:

- Use `primary_dim` at `10%` opacity
- Blur radius: `40px`

This should behave like neon light cast into surrounding darkness.

### Ghost Border

For inputs and other subtle boundaries:

- Use `outline_variant` at `15%` opacity
- Keep it barely visible

### Glass Depth

Glass layers may use a top-edge inner glow:

- Inner stroke: `1px`
- Color: `on_surface` at `10%` opacity

This is the one acceptable line-like effect because it behaves like reflected light, not a divider.

## 6. Components

### Cards and Lists

- Never use divider lines.
- Separate list items with `16px` vertical space.
- Use a slight shift to `surface-container-low` for grouped items.
- Prefer `1.5rem` or `2rem` corner radii.
- Cards should feel like pockets of energy, not flat containers.
- Savage Mode cards should use a `secondary_dim` outer glow.

### Buttons

#### Primary

- Background: `primary` (`#DE8EFF`)
- Foreground: `on_primary`
- Feeling: high-contrast, immediate, highly clickable

#### Secondary

- Glassmorphic background
- Ghost border using `primary` at `20%` opacity

#### Tertiary

- Text-only
- Use `primary_fixed`
- No background

### Chips

- Chips are mode selectors.
- Always use pill rounding.
- Selection should change the accent family of the app.
- Example: Wealth mode switches emphasis toward `tertiary` gold tones.

### Input Fields

Use the hollow input style:

- No background fill
- Bottom ghost border only
- Input typography should use `headline-sm`

This keeps the experience ethereal and light.

### Oracle Portal

Use a large circular glass container as the main interaction focal point.

- Shape: fully rounded
- Border: rotating gradient from `primary` to `secondary`
- Blur: heavy backdrop blur
- Meaning: the app is consulting the void

## 7. Spacing and Composition

### Asymmetry Rules

- Align the main heading left.
- Push metadata or supporting commentary noticeably off-axis.
- Avoid identical top, horizontal, and bottom padding blocks everywhere.
- Let some components bleed into nearby space if it adds drama.

### Separation Rules

- Prefer large gaps over hard separators.
- Use spacing to imply structure.
- Let hero sections breathe.

## 8. Interaction Tone

- Important actions should glow.
- Quiet actions should recede into glass or text-only treatments.
- State changes should feel atmospheric rather than mechanical.
- The UI should suggest a ritual in progress, not a standard form flow.

## 9. Do

- Use asymmetrical layouts.
- Let important elements bleed neon into nearby dark surfaces.
- Use oversized display text for short answers like `YES`, `NO`, or `WAIT`.
- Stack surfaces to create depth.
- Keep corners rounded and premium.
- Use glass layers for floating UI such as modals and nav bars.

## 10. Don't

- Do not use pure white backgrounds.
- Do not use Material divider lines.
- Do not use sharp corners.
- Do not use heavy opaque borders.
- Do not flatten everything into uniform cards with equal spacing.

## 11. Implementation Checklist

Use this checklist while building screens:

- Is the screen asymmetrical in at least one obvious way?
- Is the main answer or headline visually dominant?
- Are boundaries defined without hard divider lines?
- Are nested surfaces brighter than their parents?
- Do important actions glow rather than rely on standard shadows?
- Are floating elements glass-based where appropriate?
- Are corners at least `24px` rounded?
- Does the screen feel ceremonial and editorial instead of generic?

## 12. SwiftUI Translation Notes

When implementing this style in SwiftUI:

- Prefer layered `ZStack` compositions over flat `VStack` lists.
- Use gradient overlays with low opacity on cards.
- Use `ultraThinMaterial` or custom blurred backgrounds for glass-like surfaces when appropriate.
- Build depth with stacked fills and glows before reaching for shadows.
- Use large, expressive typography and avoid shrinking hero copy too early.
- Keep support copy visually secondary through size, placement, and opacity.

## 13. File Purpose

This file is the layout reference for the `answer_x` project. Keep it open while designing screens so visual decisions remain aligned with the Cyber-Oracle Editorial direction.

## 14. SwiftUI Entry Points

Use these project files alongside this document when building screens:

- `answer_x/DesignSystem/OracleTheme.swift`: color, spacing, radius, blur, opacity, and mode tokens
- `answer_x/DesignSystem/OracleTypography.swift`: editorial typography helpers with fallback fonts
- `answer_x/DesignSystem/OracleComponents.swift`: glass cards, portal, button styles, hollow input, and background helpers
- `answer_x/ContentView.swift`: live example of the design system applied to a screen

## 15. Reference Imports

Imported design reference files for this project live in `Docs/ReferenceMaterial/`.

- `screen.png`: original file provided by the user, preserved as-is
- `code.html`: fallback design source used when the original image file was unreadable
- `VoidTab/`: second-tab design references imported from the newer handoff set
- `AnswerDetail/`: answer-detail page references and the card screenshot used for entry-state context
- `AnswerResult/`: answer-result page references imported from the latest handoff set
- `AnswerTransition/`: animated transition-page references imported from the latest loading-state handoff
