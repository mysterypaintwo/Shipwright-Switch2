#include <libultraship/bridge/consolevariablebridge.h>

#include "soh/Enhancements/game-interactor/GameInteractor.h"
#include "soh/Enhancements/enhancementTypes.h"
#include "soh/ShipInit.hpp"

extern "C" {
#include "z64.h"
extern PlayState* gPlayState;
}

#ifdef __SWITCH2__
// At 1080p the default depth offset cuts the paths off near the camera.
static constexpr ZFightingFixType CVAR_DIRT_PATH_DEFAULT = ZFIGHT_FIX_NO_VANISH;
#else
static constexpr ZFightingFixType CVAR_DIRT_PATH_DEFAULT = ZFIGHT_FIX_DISABLED;
#endif
#define CVAR_DIRT_PATH_NAME CVAR_ENHANCEMENT("SceneSpecificDirtPathFix")
#define CVAR_DIRT_PATH_VALUE CVarGetInteger(CVAR_DIRT_PATH_NAME, CVAR_DIRT_PATH_DEFAULT)

static void DirtPathFix_UpdateZFightingMode(int32_t sceneNum) {
    switch (sceneNum) {
        case SCENE_HYRULE_FIELD:
        case SCENE_KOKIRI_FOREST:
        case SCENE_HYRULE_CASTLE:
            CVarSetInteger(CVAR_Z_FIGHTING_MODE, CVAR_DIRT_PATH_VALUE);
            return;
        default:
            CVarClear(CVAR_Z_FIGHTING_MODE);
    }
}

static void RegisterDirtPathFix() {
    if (gPlayState != NULL) {
        DirtPathFix_UpdateZFightingMode(gPlayState->sceneNum);
    }

    COND_HOOK(OnTransitionEnd, CVAR_DIRT_PATH_VALUE, DirtPathFix_UpdateZFightingMode);
}

static RegisterShipInitFunc initFunc(RegisterDirtPathFix, { CVAR_DIRT_PATH_NAME });
