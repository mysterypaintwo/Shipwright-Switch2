#pragma once

// Switch 2 UI scale for the style sizes that widgets push.
//
// On Switch 2, libultraship scales the base ImGui style 3x for the 1080p screen
// (Gui.cpp: ScaleAllSizes(3)). The widgets here push their own sizes in pixels
// (padding, spacing, borders), and those pushed sizes replace the scaled ones,
// so menus came out smaller and thinner than Ship of Harkinian's. On Switch 2
// this header makes every ImGui::PushStyleVar in the file that includes it
// scale its size the same way. Ratios (alpha, text alignment) stay as they are.
//
// Include it after imgui.h, as the last include of a .cpp file: it defines
// PushStyleVar as a macro.
#ifdef __SWITCH2__

#include <imgui.h>

namespace Switch2Ui {
// Same as the base style scale in libultraship's Gui.cpp.
inline constexpr float kStyleScale = 3.0f;

inline bool IsSizeVar(ImGuiStyleVar idx) {
    switch (idx) {
        case ImGuiStyleVar_Alpha:
        case ImGuiStyleVar_DisabledAlpha:
        case ImGuiStyleVar_WindowTitleAlign:
        case ImGuiStyleVar_ButtonTextAlign:
        case ImGuiStyleVar_SelectableTextAlign:
            return false;
        default:
            return true;
    }
}

inline float ScaleStyleVar(ImGuiStyleVar idx, float value) {
    return IsSizeVar(idx) ? value * kStyleScale : value;
}

inline ImVec2 ScaleStyleVar(ImGuiStyleVar idx, const ImVec2& value) {
    return IsSizeVar(idx) ? ImVec2(value.x * kStyleScale, value.y * kStyleScale) : value;
}
} // namespace Switch2Ui

// ImGui::PushStyleVar(idx, value) -> ImGui::PushStyleVar(idx, scaled value).
// A macro is not expanded again inside its own expansion, so this calls ImGui's.
#define PushStyleVar(idx, ...) PushStyleVar(idx, Switch2Ui::ScaleStyleVar(idx, __VA_ARGS__))

#endif
