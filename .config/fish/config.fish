if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path /opt/homebrew/opt/openjdk/bin
set -gx ANDROID_SDK_ROOT /Users/ipad/Library/Android/sdk
set -gx ANDROID_NDK_HOME /Users/ipad/Library/Android/sdk/ndk
alias tb:on "adb shell settings put secure enabled_accessibility_services com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService"
alias tb:off "adb shell settings put secure enabled_accessibility_services com.android.talkback/com.google.android.marvin.talkback.TalkBackService"
alias reverse "adb reverse tcp:8081 tcp:8081"
alias code "open /Applications/Visual\ Studio\ Code.app"
alias yw 'yarn test --watch '
alias ll='ls -la --color'


function gif
    ffmpeg -i $argv -r 30 -filter_complex "[0:v] scale=420:-1" $argv.gif
end

fish_add_path /opt/homebrew/opt/gradle@6/bin

function prune
    git fetch -a
    for branch in (git branch -v | grep "gone" | awk '{print $1}')
        git branch -D $branch
    end
end

function screenshot
    echo "Taking screenshot of Android device via adb ~/Desktop/android.png"
    adb exec-out screencap -p >~/Desktop/android.png
end

function adb-input
    for c in (string split '' $argv)
        adb shell input text $c
        sleep 0.00001
    end
end

set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_stashed_verbose yes
set -g theme_display_git_default_branch yes
set -g theme_display_virtualenv no
set -g theme_display_nix no
set -g theme_display_ruby no
set -g theme_display_node yes
set -g theme_display_user ssh
set -g theme_display_hostname ssh
set -g theme_display_vi no
set -g theme_display_date no
set -g fish_prompt_pwd_dir_length 0
set -g theme_newline_cursor yes
set -g theme_newline_prompt " "

function nvm
    bass source (brew --prefix nvm)/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

set -x ANDROID_HOME /Users/ipad/Library/Android/sdk

set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH '/Users/ipad/.jenv/shims' $PATH
set -gx PATH $HOME/.maestro/bin $PATH
set -gx JENV_SHELL fish
set -gx JENV_LOADED 1
set -e JAVA_HOME
set -e JDK_HOME
set -gx FZF_DEFAULT_COMMAND 'ag -p ~/.gitignore -g ""'
source '/Users/ipad/.jenv/libexec/../completions/jenv.fish'

jenv refresh-plugins > /dev/null 2>&1
function jenv
    set command $argv[1]
    set -e argv[1]

    switch "$command"
        case enable-plugin rehash shell shell-options
            source (jenv "sh-$command" $argv|psub)
        case '*'
            command jenv "$command" $argv
    end
end
source /opt/homebrew/Cellar/chruby-fish/1.0.0/share/fish/vendor_functions.d/chruby.fish
source /opt/homebrew/Cellar/chruby-fish/1.0.0/share/fish/vendor_conf.d/chruby_auto.fish
chruby ruby-3.2.1

alias vim="nvim"
alias vi="nvim"
alias oldvim="vim"
alias mirror="scrcpy -t"


# pnpm
set -gx PNPM_HOME "/Users/ipad/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
