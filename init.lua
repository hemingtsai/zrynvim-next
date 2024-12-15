state_manager = {}

-- i18n should be loaded before other modules.
require("core.i18n")
i18n = zrynvim_next_i18n.init_i18n()

-- Run Early Hook
require("user.hook.early_loading")
early_loading.init()

-- Load core module.
require("core")

-- Load editor configurtions.
require("editor")

-- Load Editor Tools

require("tools")

-- Run Late Hook
require("user.hook.late_loading")
early_loading.init()

print(i18n["all_modules_loaded"])
