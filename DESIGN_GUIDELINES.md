# School Dynamics — Design Guidelines

## Philosophy

School Dynamics follows a **clean, minimalistic, enterprise-grade** design language.  
Every screen uses only **two colours** — the enterprise primary colour and white — producing a professional, distraction-free experience.

---

## 1. Colour Palette

| Token | Value | Usage |
|---|---|---|
| **Primary** | Enterprise colour (loaded at runtime) | App bar, active states, accents, buttons, icons |
| **Primary Light** | Primary @ 10 % opacity | Subtle backgrounds, hover / surface tints |
| **White** | `#FFFFFF` | Backgrounds, cards, surfaces |
| **Text Primary** | `#212121` | Headings, body copy |
| **Text Secondary** | `#757575` | Captions, helper text |
| **Border** | `#E0E0E0` | Dividers, outlines |
| **Error** | `#D32F2F` | Validation, destructive actions |
| **Success** | `#388E3C` | Confirmations |

**Rules**

- No gradients anywhere.
- No random / "fun" colours on cards or icons.
- If an accent is needed, derive it from Primary (lighter or darker shade).

---

## 2. Corners

**All corners are square** (`BorderRadius.zero` / `0`).

- Cards → square
- Buttons → square
- Input fields → square
- Bottom sheets → square
- Images / avatars → square
- Navigation indicators → square
- Dialogs → square

No exceptions.

---

## 3. Spacing

Standard gap between elements: **12 px**.

| Token | Value | Usage |
|---|---|---|
| `xs` | 4 px | Tight inline spacing |
| `sm` | 8 px | Icon-to-label gaps |
| `md` | 12 px | **Default** element gap |
| `lg` | 16 px | Section padding |
| `xl` | 24 px | Screen-edge padding |
| `xxl` | 32 px | Section dividers |

Screen edge (horizontal padding): **16 px**.  
Card internal padding: **12 px**.

---

## 4. Typography

**Single font family: Inter** (via Google Fonts).

| Style | Size | Weight | Usage |
|---|---|---|---|
| Headline | 20 px | 600 (Semi-bold) | Screen / page titles |
| Title | 16 px | 600 (Semi-bold) | Card titles, section heads |
| Body | 14 px | 400 (Regular) | Standard body text |
| Caption | 12 px | 400 (Regular) | Helper text, timestamps |
| Label | 12 px | 500 (Medium) | Nav labels, buttons, tags |
| Overline | 10 px | 500 (Medium) | Category labels |

**Rules**

- No competing font families — only Inter everywhere.
- Body and smaller text: `TextPrimary (#212121)` or `TextSecondary (#757575)`.
- Headings on white backgrounds: `TextPrimary`.
- Text on Primary: always `White`.

---

## 5. Icons

- Use **Material Icons** (outlined style preferred).
- Colour: Primary on white backgrounds, White on Primary backgrounds.
- Size: 24 px standard, 20 px in compact contexts.
- **Monochromatic only** — never multi-coloured icons.

---

## 6. Elevation & Shadows

- Cards: elevation **0** with a `1 px` border in `Border (#E0E0E0)`.
- No decorative shadows on dashboard items.
- Floating buttons: elevation **2** maximum.
- Bottom navigation bar: top border `1 px Border`, no shadow.

---

## 7. Cards & Containers

```
┌────────────────────────┐
│  12 px padding         │
│  ┌──────────────────┐  │
│  │ Icon  Title      │  │
│  │       Subtitle   │  │
│  └──────────────────┘  │
└────────────────────────┘
```

- Background: White
- Border: 1 px `#E0E0E0`
- Corner radius: 0
- Internal padding: 12 px
- Icon/image tint: Primary

---

## 8. Buttons

| Type | Background | Text | Border |
|---|---|---|---|
| Primary | Primary | White | None |
| Secondary | White | Primary | 1 px Primary |
| Text / Ghost | Transparent | Primary | None |

All buttons: square corners, 12 px vertical / 16 px horizontal padding.

---

## 9. Dashboard Menu Grid

- **2 columns** on phones (≤ 600 px), 3 columns on tablets.
- Card: white background, 1 px border, square corners.
- 24 px icon (Primary colour) centred above title.
- Title: 12 px, medium weight, `TextPrimary`.
- Gap between cards: 12 px.
- Aspect ratio: ~1.0 (square-ish).

---

## 10. App Bar

- Background: Primary (flat, no gradient).
- Title: White, 18 px semi-bold, left-aligned.
- Icons: White, 24 px.
- Elevation: 0.

---

## 11. Bottom Navigation

- Background: White.
- Top border: 1 px `#E0E0E0`.
- Active icon + label: Primary.
- Inactive icon + label: `#757575`.
- No background highlight on active tab.
- Label: 10 px medium.

---

## 12. Lists

- Dividers: 1 px `#E0E0E0`.
- Row padding: 12 px vertical, 16 px horizontal.
- Leading icon: 24 px, Primary.
- Title: body (14 px).
- Subtitle: caption (12 px, `TextSecondary`).

---

## 13. Responsiveness

- All spacing scales from the token system.
- No hard-coded pixel widths wider than individual components.
- Minimum touch target: 44 × 44 px.

---

## Summary Checklist

- [ ] Only Primary + White.
- [ ] Zero border radius everywhere.
- [ ] 12 px default spacing.
- [ ] Inter font only.
- [ ] No gradients.
- [ ] No decorative shadows.
- [ ] Monochromatic icons (Primary or White).
- [ ] Flat app bar (Primary, no gradient).
- [ ] Clean bottom nav (white, top border).
