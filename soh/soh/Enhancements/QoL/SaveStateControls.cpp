#ifdef __SWITCH__
#include "SaveStateControls.h"

#include <imgui.h>
#include <ship/Context.h>
#include <ship/window/Window.h>
#include <ship/window/gui/Gui.h>
#include <ship/window/gui/GameOverlay.h>
#include <ship/controller/controldeck/ControlDeck.h>
#include <libultraship/bridge/consolevariablebridge.h>
#include "soh/Enhancements/game-interactor/GameInteractor.h"
#include "soh/Enhancements/savestates.h"
#include "soh/OTRGlobals.h"
#include "soh/ShipInit.hpp"

extern "C" {
#include "z64.h"
#include "macros.h"
#include "variables.h"
}

#define CVAR_SAVE_STATES_ON CVAR_CHEAT("SaveStatesEnabled")

static void Notify(const char* message) {
    Ship::Context::GetRawInstance()->GetWindow()->GetGui()->GetGameOverlay()->TextDrawNotification(3.0f, true, "%s",
                                                                                                   message);
}

static void NotifySlot(const char* action, unsigned int slot) {
    char message[64];
    snprintf(message, sizeof(message), "%s slot %u", action, slot + 1);
    Notify(message);
}

void SaveStateControls_Save() {
    const unsigned int slot = OTRGlobals::Instance->gSaveStateMgr->GetCurrentSlot();
    switch (OTRGlobals::Instance->gSaveStateMgr->AddRequest({ slot, RequestType::SAVE })) {
        case SaveStateReturn::SUCCESS:
            NotifySlot("Saved state to", slot);
            break;
        case SaveStateReturn::FAIL_WRONG_GAMESTATE:
            Notify("Save states only work during gameplay");
            break;
        default:
            Notify("Could not save state");
            break;
    }
}

void SaveStateControls_Load() {
    const unsigned int slot = OTRGlobals::Instance->gSaveStateMgr->GetCurrentSlot();
    switch (OTRGlobals::Instance->gSaveStateMgr->AddRequest({ slot, RequestType::LOAD })) {
        case SaveStateReturn::SUCCESS:
            NotifySlot("Loaded state from", slot);
            break;
        case SaveStateReturn::FAIL_STATE_EMPTY:
            NotifySlot("Nothing saved in", slot);
            break;
        case SaveStateReturn::FAIL_WRONG_GAMESTATE:
            Notify("Save states only work during gameplay");
            break;
        default:
            Notify("Could not load state");
            break;
    }
}

void SaveStateControls_NextSlot() {
    const unsigned int slot = (OTRGlobals::Instance->gSaveStateMgr->GetCurrentSlot() + 1) % 6;
    OTRGlobals::Instance->gSaveStateMgr->SetCurrentSlot(slot);
    NotifySlot("Save state", slot);
}

static bool IsInputForUi() {
    auto gui = Ship::Context::GetRawInstance()->GetWindow()->GetGui();
    if (gui->GetMenuOrMenubarVisible() || ImGui::IsPopupOpen("", ImGuiPopupFlags_AnyPopupId)) {
        return true;
    }
    auto inputEditor = gui->GetGuiWindow("Configure Controller");
    return inputEditor != nullptr && inputEditor->IsVisible();
}

// Every mapping on the line must be held, so several mappings form a combo.
static bool IsComboHeld(CONTROLLERBUTTONS_T bitmask) {
    auto button = Ship::Context::GetRawInstance()->GetControlDeck()->GetControllerByPort(0)->GetButton(bitmask);
    if (button == nullptr) {
        return false;
    }
    const auto mappings = button->GetAllButtonMappings();
    if (mappings.empty()) {
        return false;
    }
    for (const auto& [id, mapping] : mappings) {
        CONTROLLERBUTTONS_T pad = 0;
        mapping->UpdatePad(pad);
        if ((pad & bitmask) == 0) {
            return false;
        }
    }
    return true;
}

static void OnGameStateMainStartSaveStates() {
    // After a menu closes, wait for the combos to be released so the press that
    // closed it (or a combo just bound) cannot trigger an action.
    static bool sArmed = false;
    static bool sSaveHeld = false;
    static bool sLoadHeld = false;
    if (gGameState == nullptr || CVarGetInteger(CVAR_SAVE_STATES_ON, 0) == 0 || IsInputForUi()) {
        sArmed = false;
        return;
    }

    const bool saveHeld = IsComboHeld(BTN_CUSTOM_SAVE_STATE);
    const bool loadHeld = IsComboHeld(BTN_CUSTOM_LOAD_STATE);
    if (!sArmed) {
        sArmed = !saveHeld && !loadHeld;
    } else if (saveHeld && !sSaveHeld) {
        SaveStateControls_Save();
    } else if (loadHeld && !sLoadHeld) {
        SaveStateControls_Load();
    }
    sSaveHeld = saveHeld;
    sLoadHeld = loadHeld;
}

static void RegisterSaveStateControls() {
    COND_HOOK(OnGameStateMainStart, true, OnGameStateMainStartSaveStates);
}

static RegisterShipInitFunc initFuncSaveStateControls(RegisterSaveStateControls, {});
#endif
