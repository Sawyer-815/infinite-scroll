# Scroll Jump on iOS 26

This project reproduces a **scroll position jump** issue when using a `ScrollView` with a `LazyVStack` containing **dynamic-height** views.

---

## Steps to Reproduce

1. Open in **Xcode 26.0.1** and run on **iOS 26** (e.g. iPhone 17 Pro simulator).  
2. Add a few cells to the bottom or the top of the scroll view, and position yourself in the middle.
2. Tap the **Input** field to show the keyboard → the scroll view **jumps**.  
3. Dismiss the keyboard → scroll position shifts again.  
4. Toggle between **Fixed size** and **Dynamic size** using the segmented control:
   - Fixed size (colored squares) → ✅ works fine  
   - Dynamic size (multiline text) → ⚠️ shows glitches

## Notes

- Seems to work correctly on iOS 18.  
- Seems related to `scrollPosition(id:)`, `scrollTargetLayout` + dynamic height content.
