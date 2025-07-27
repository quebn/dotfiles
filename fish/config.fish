if status is-interactive
    # MARK: settings

    set -U tide_os_color 9ccfd8
    set -U tide_context_color 9ccfd8
    set -U tide_git_icon ''
    set -U fish_autosuggestion_enabled 0

    set -U fish_color_command 31748f
    set -U fish_color_redirection c4a7e7


    set -x ARDUINO_CONFIG "$HOME/Programming/arduino/.arduino15"
    set -x MANPAGER "nvim +Man!"
    set -x CHROME_EXECUTABLE (which google-chrome-stable)
    set -x ANDROID_HOME "$HOME/Apps/.tools/android_sdk"
    set -x PATH "$ANDROID_HOME/cmdline-tools/latest/bin" $PATH
    set -x PATH "$ANDROID_HOME/platform-tools" $PATH
    set -x EDITOR (which nvim)
    set -x VISUAL (which nvim)
    set -x GOPATH "$HOME/Programming/.go"
    set -x DIFFPROG "nvim -d"
    set -x CGO_ENABLED 1
    # set -q C_INCLUDE_PATH; or set C_INCLUDE_PATH ''
    # set -x C_INCLUDE_PATH "$HOME/.local/include:$C_INCLUDE_PATH"
    set -x FZF_DEFAULT_OPTS "
    --pointer ''
    --prompt ' '
    --color=fg:#908caa,bg:#000000,hl:#e0def4
    --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
    --color=border:#524f67,header:#31748f,gutter:#000000
    --color=spinner:#f6c177,info:#9ccfd8
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#31748f
    "

    # MARK: Bindings
    bind \cs 'tmux-sessionizer; commandline -f execute'
    # NOTE: for vi mode
    bind -M insert \cs 'tmux-sessionizer; commandline -f execute'

    # MARK: alias
    alias vi="nvim"
    alias vim="nvim"
    alias open="tmux-sessionizer"
    alias create="project"
    alias a="attach"
    alias ll="nvim"
    alias todoedit="$EDITOR ~/.TODO.md"
    alias grep="grep --color=auto"
    alias ls="lsd"

    alias ino="arduino-cli --config-dir $ARDUINO_CONFIG"

    fzf --fish | source

    fish_default_key_bindings
    # fish_vi_key_bindings
    function fish_greeting
    end
    function fish_vi_cursor --description "Disable cursor shape changes"
        # Do nothing; this disables cursor shape switching in vi mode
    end

    function tide_pre_prompt_command --on-event fish_prompt
        printf '\e[1 q'  # Blinking block cursor
    end
end
