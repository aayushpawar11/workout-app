# Vector Assets Guide for Anatomical Diagram

This guide explains how to add vector muscle group images to enhance the anatomical diagram visualization.

## Current Implementation

The app uses `VectorAnatomicalDiagramView` which supports:
- ✅ Vector images (SVG/PDF) with template rendering for color highlighting
- ✅ Fallback to shape-based paths when images aren't available
- ✅ Tap gestures with haptic feedback
- ✅ Smooth animations
- ✅ Easy state management

## Step 1: Create Vector Assets

### Tools to Use:
- **Figma** (recommended) - Easy export, great for iOS
- **Illustrator** - Professional vector editing
- **Inkscape** (free) - Open source alternative

### Asset Naming Convention

Each muscle group needs two images (front and back views). Use this naming pattern:

```
{muscle_group}_{view}.pdf
```

### Required Assets:

#### Base Body Outlines:
- `body_base_front.pdf` - Front view body outline
- `body_base_back.pdf` - Back view body outline

#### Chest Muscles:
- `chest_upper_front.pdf`
- `chest_mid_front.pdf`
- `chest_lower_front.pdf`

#### Back Muscles:
- `back_upper_back.pdf`
- `back_mid_back.pdf`
- `back_lower_back.pdf`
- `lats_back.pdf`
- `traps_back.pdf`

#### Shoulder Muscles:
- `deltoids_anterior_front.pdf`
- `deltoids_lateral_front.pdf`
- `deltoids_posterior_back.pdf`

#### Arm Muscles:
- `biceps_front.pdf`
- `triceps_back.pdf`
- `forearms_front.pdf`

#### Core Muscles:
- `abs_upper_front.pdf`
- `abs_lower_front.pdf`
- `obliques_front.pdf`

#### Leg Muscles:
- `quads_front.pdf`
- `hamstrings_back.pdf`
- `glutes_back.pdf`
- `calves_front.pdf` (and `calves_back.pdf`)

## Step 2: Export Settings

### For PDF (Recommended):
1. Export as PDF
2. Ensure paths are clean (no unnecessary points)
3. Use single color fills (will be replaced by template rendering)
4. Remove strokes (or make them very thin)

### For SVG:
1. Export as SVG
2. Xcode will convert to PDF automatically
3. Ensure proper viewBox settings

## Step 3: Add to Xcode Project

1. Open Xcode
2. Right-click on `Assets.xcassets` folder
3. Select "New Image Set"
4. Name it exactly as listed above (e.g., `chest_upper_front`)
5. Drag your PDF/SVG file into the "Universal" slot
6. Repeat for all muscle groups

## Step 4: Verify

Once assets are added, the app will automatically:
- Use vector images when available
- Fall back to shape-based paths for missing assets
- Apply workout color highlighting
- Enable tap interactions

## Tips

1. **Consistency**: Keep all muscle shapes at the same scale and alignment
2. **Layering**: Design with layering in mind - muscles should stack cleanly
3. **Simplicity**: Clean, simple paths work best for template rendering
4. **Testing**: Test with different workout colors to ensure visibility

## Current Fallback

Until vector assets are added, the app uses `MusclePathView` from `PreciseMuscleHighlightView.swift` which provides shape-based muscle highlighting. This ensures the feature works immediately while you prepare vector assets.

## Example Usage

Once assets are added, the view automatically detects and uses them:

```swift
VectorAnatomicalDiagramView(
    activeMuscles: Set(workout.exercises.flatMap { $0.detailedMuscles }),
    isFront: true,
    highlightColor: workout.color
)
```

The view handles:
- Image loading and fallback
- Color highlighting based on workout color
- Tap gestures with animations
- Haptic feedback

