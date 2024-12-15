-- i18n implementation of LuaJIT in Neovim Editor.
zrynvim_next_i18n = {}

function choose_language()
    require("data.i18n.languages")
    vim.ui.select(zrynvim_next_languages, {
        prompt = "Choose a language:"
    }, function(choice)
        state_manager["i18n"] = choice
    end)
end

function zrynvim_next_i18n.init_i18n()
    require("user.core.i18n_config")

    if i18n_config["language"] == nil then
        choose_language()
    else
        state_manager["now_language"] = i18n_config["language"]
    end

    require(string.format("data.i18n.%s", state_manager["now_language"]))

    return lang
end
