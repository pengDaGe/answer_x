# Design System: Cyber-Oracle Editorial

## 1. Overview & Creative North Star: "The Neon Ritual"
This design system is built to transcend the standard utility of a mobile app, moving into the realm of a digital experience that feels like a modern, high-stakes ritual. The Creative North Star is **"The Neon Ritual"**—a fusion of ancestral mysticism and high-fidelity cyberpunk aesthetics. 

To break the "template" look, this system rejects rigid, equal-padding grids in favor of **intentional asymmetry**. We utilize massive typography scales, overlapping card elements, and "bleeding" neon glows to create a sense of depth and mystery. The UI shouldn't feel like a flat screen; it should feel like a multi-layered obsidian mirror reflecting data from another dimension.

---

## 2. Colors: High-Contrast Luminance
The palette is rooted in the void (`#0D0D0D`), using neon tokens not just as accents, but as "energy sources" that illuminate the dark interface.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning. Boundaries must be defined through:
1.  **Background Shifts:** Transitioning from `surface` to `surface-container-low`.
2.  **Luminous Glows:** A `primary_dim` outer glow to define a container’s edge.
3.  **Negative Space:** Large gaps using the Spacing Scale to imply separation.

### Surface Hierarchy & Nesting
Treat the UI as stacked sheets of volcanic glass. 
- **Base Layer:** `surface` (#0E0E0E) for the main canvas.
- **Mid Layer:** `surface-container-low` for secondary content blocks.
- **Top Layer:** `surface-bright` or `surface-container-highest` for interactive elements.
- **Nesting:** When placing a card inside a section, the card must always be a higher tier (brighter) than its parent to "lift" towards the user.

### The "Glass & Gradient" Rule
To achieve the "Cyber-Fortune Telling" vibe, use **Glassmorphism** for all floating modals and navigation bars.
- **Formula:** `surface_variant` at 40% opacity + 20px Backdrop Blur.
- **Signature Textures:** Use a linear gradient (`primary` to `primary_container`) at 15% opacity as a subtle overlay on cards to provide a "pulsing" digital soul.

---

## 3. Typography: Editorial Authority
We use a high-contrast typographic pairing to balance "The Future" with "The Message."

*   **Display & Headlines (Space Grotesk):** This is our "Oracle" voice. It is brutalist, wide, and commanding. Use `display-lg` for single-word answers to create massive visual impact.
*   **Body & Titles (Manrope):** The "Human" voice. Clean, geometric, and highly legible. Manrope provides the functional grounding needed for longer "fortunes" or sarcastic "Savage Mode" retorts.
*   **Labels (Plus Jakarta Sans):** The "Data" voice. Used for technical metadata and small UI anchors.

**The Scale:**
- **Answer Text:** Always uses `headline-lg` or `display-sm` to ensure the "Answer" is the most important element on screen.
- **Sarcasm/Context:** Small `body-sm` text placed asymmetrically to the bottom-right of a large headline creates a modern, editorial feel.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are too "Web 2.0" for this system. We use **Tonal Layering** and **Atmospheric Diffusion**.

*   **The Layering Principle:** Depth is achieved by stacking. A `surface-container-highest` button sits on a `surface-container-low` card, creating a natural elevation without a single shadow.
*   **Ambient Shadows:** If a floating action button (FAB) requires a shadow, it must be an **Ambient Glow**. Use the `primary_dim` color at 10% opacity with a 40px blur. This mimics the way a neon sign casts light on a dark street.
*   **The "Ghost Border" Fallback:** For input fields, use the `outline_variant` token at 15% opacity. It should be barely visible, felt rather than seen.
*   **Glassmorphism Depth:** When using glass layers, the "inner glow" (a 1px inner stroke of `on_surface` at 10% opacity) should be used to catch the "light" at the top edge of the container.

---

## 5. Components

### Cards & Lists
*   **The Law:** No divider lines. Separate list items using 16px of vertical space and a slight shift to `surface-container-low`.
*   **Interactive Cards:** Use `md` (1.5rem) or `lg` (2rem) corner radii. Cards should feel like "pockets" of energy. For "Savage Mode," the card should have a `secondary_dim` (Neon Red) outer glow.

### Buttons
*   **Primary (The Action):** Filled with `primary` (#DE8EFF). Text in `on_primary`. High-contrast, maximum "clickability."
*   **Secondary (The Choice):** Glassmorphic background with a `primary` "Ghost Border" (20% opacity).
*   **Tertiary (The Subtle):** Text-only using `primary_fixed`, no background.

### Chips (Mode Selectors)
*   Selection chips must change the entire app's accent color (e.g., selecting "Wealth" switches accent tokens to `tertiary`/Gold). Use `full` (pill) roundedness.

### Input Fields
*   **The "Hollow" Input:** No background fill. Only a bottom "Ghost Border" and `headline-sm` typography for the input text. This keeps the mystical vibe feeling "light" and ethereal.

### New Component: The "Oracle Portal"
*   A large, circular glass container (`rounded-full`) used for the main interaction point. It features a rotating gradient border (`primary` to `secondary`) and a heavy backdrop blur to signify the app is "thinking" or "consulting the void."

---

## 6. Do’s and Don’ts

### Do:
*   **Do** use asymmetrical layouts. Place a heading on the left and the subtext far on the right.
*   **Do** embrace the "Glow." If an element is important, let it bleed light into the surrounding dark pixels.
*   **Do** use `display-lg` for impact. If the answer is "YES," let it take up half the screen.

### Don't:
*   **Don't** use pure white (#FFFFFF) for backgrounds. Stick to the `surface` tokens to maintain the Cyberpunk depth.
*   **Don't** use standard Material Design dividers. They kill the immersive "Ritual" vibe.
*   **Don't** use sharp corners. Everything must feel "molded" and premium (min 24px/1.5rem radius).
*   **Don't** use heavy, opaque borders. They make the UI look like a spreadsheet; we want a crystal ball.