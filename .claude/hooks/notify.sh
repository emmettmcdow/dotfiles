#!/usr/bin/env bash
# Claude Code Stop/Notification hook: post a macOS notification titled with
# the session's name so you can tell which agent finished.
# Name preference: /rename name > custom title > auto title > cwd basename.
set -u

input=$(cat)
field() { jq -r "$1 // empty" <<<"$input" 2>/dev/null; }

event=$(field .hook_event_name)
transcript=$(field .transcript_path)
cwd=$(field .cwd)

name=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
    # Latest entry of each kind wins, since sessions can be renamed.
    name=$(jq -rn '[inputs] as $e
                   | [$e[] | select(.type=="agent-name") | .agentName] | last //
                     ([$e[] | select(.type=="custom-title") | .customTitle] | last) //
                     ([$e[] | select(.type=="ai-title") | .aiTitle] | last) // empty' \
        "$transcript" 2>/dev/null)
fi
[ -n "$name" ] || name=$(basename "${cwd:-$PWD}")

if [ "$event" = "Notification" ]; then
    message=$(field .message)
    message=${message:-Waiting for your input}
    sound=""
else
    message="Task complete"
    sound="Glass"
fi

# Pass text as argv so quotes in session names can't break the AppleScript.
osascript - "$name" "$message" "$sound" <<'EOF' >/dev/null 2>&1
on run argv
    set {theTitle, theMessage, theSound} to argv
    if theSound is "" then
        display notification theMessage with title "Claude Code" subtitle theTitle
    else
        display notification theMessage with title "Claude Code" subtitle theTitle sound name theSound
    end if
end run
EOF
exit 0
