#!/usr/bin/env zsh
# Tests for wt (ephemeral worktree model) — run with: zsh wt/test_wt.zsh
# Exits non-zero on failure. Each test runs against an isolated WT_CONFIG_DIR.

set -u
emulate -L zsh
setopt extended_glob

SCRIPT_DIR="${0:A:h}"
PASS=0
FAIL=0
FAILED_TESTS=()

_setup() {
    WT_CONFIG_DIR=$(mktemp -d -t wt-test-XXXXXX 2>/dev/null)
    WT_CONFIG_DIR="${WT_CONFIG_DIR:A}"
    if [[ -z "$WT_CONFIG_DIR" || ! -d "$WT_CONFIG_DIR" || "$WT_CONFIG_DIR" == "/" ]]; then
        echo "FATAL: could not create a temp dir (mktemp failed) — aborting to avoid touching the real repo." >&2
        exit 2
    fi
    WT_REPOS_FILE="${WT_CONFIG_DIR}/repos"
    export WT_CONFIG_DIR WT_REPOS_FILE
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
    cd "$WT_CONFIG_DIR" || exit 2
    source "${SCRIPT_DIR}/wt.zsh"
}

_teardown() {
    [[ -n "${WT_CONFIG_DIR:-}" && "$WT_CONFIG_DIR" == *wt-test-* ]] && rm -rf "$WT_CONFIG_DIR"
    unset WT_CONFIG_DIR WT_REPOS_FILE
}

_assert_eq() {
    local expected="$1" actual="$2" msg="${3:-}"
    [[ "$expected" == "$actual" ]] && return 0
    echo "    expected: '$expected'"
    echo "    actual:   '$actual'"
    [[ -n "$msg" ]] && echo "    note:     $msg"
    return 1
}

_assert_contains() {
    local haystack="$1" needle="$2" msg="${3:-}"
    [[ "$haystack" == *"$needle"* ]] && return 0
    echo "    expected to contain: '$needle'"
    echo "    actual:              '$haystack'"
    [[ -n "$msg" ]] && echo "    note:                $msg"
    return 1
}

_assert_absent() {
    [[ ! -e "$1" ]] && return 0
    echo "    expected path to be gone: '$1'"
    return 1
}

_run_test() {
    local name="$1" fn="$2"
    _setup
    if "$fn"; then
        echo "  ✅ $name"
        PASS=$((PASS+1))
    else
        echo "  ❌ $name"
        FAIL=$((FAIL+1))
        FAILED_TESTS+=("$name")
    fi
    _teardown
}

# Build a fixture clone with (gitignored) node_modules + .yarn. Echoes its path.
_mk_clone() {
    local d
    d=$(mktemp -d -t wt-clone-XXXXXX 2>/dev/null); d="${d:A}"
    [[ -n "$d" && -d "$d" && "$d" != "/" ]] || return 1
    git -C "$d" init -q -b master >/dev/null 2>&1
    git -C "$d" config user.email t@t; git -C "$d" config user.name t
    mkdir -p "$d/node_modules/foo" "$d/pkg/node_modules/bar" "$d/.yarn"
    echo x > "$d/node_modules/foo/i.js"
    echo y > "$d/pkg/node_modules/bar/b.js"
    echo z > "$d/.yarn/c.txt"
    echo hi > "$d/README.md"
    echo s > "$d/pkg/app.js"
    printf 'node_modules/\n.yarn/\n' > "$d/.gitignore"
    git -C "$d" add README.md pkg/app.js .gitignore >/dev/null 2>&1
    git -C "$d" commit -qm init >/dev/null 2>&1
    echo "$d"
}

# ── tests ────────────────────────────────────────────────────────────────────

test_slugify() {
    _assert_eq "feature-a-foo" "$(_wt_slugify 'Feature A!  Foo')" "basic" || return 1
    _assert_eq "dsp-123-bar" "$(_wt_slugify '  --DSP-123 Bar-- ')" "trim/collapse" || return 1
}

test_window_name() {
    _assert_eq "afm: new-wt-name" "$(_wt_window_name afm new-wt-name)" "repo and branch" || return 1
    _assert_eq "afm: master" "$(_wt_window_name afm master)" "main branch" || return 1
}

test_register_and_clone_path() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1 || return 1
    _wt_is_repo proj || { echo "    proj not registered"; rm -rf "$c"; return 1; }
    _assert_eq "$c" "$(_wt_clone_path proj)" "clone path" || { rm -rf "$c"; return 1; }
    rm -rf "$c"
}

test_register_rejects_duplicate() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1 || return 1
    local out; out=$(wt register proj "$c" 2>&1)
    _assert_contains "$out" "already registered" || return 1
    rm -rf "$c"
}

test_register_rejects_non_git() {
    local d; d=$(mktemp -d -t wt-nongit-XXXXXX); d="${d:A}"
    local out; out=$(wt register bad "$d" 2>&1)
    _assert_contains "$out" "Not a git repo" || { rm -rf "$d"; return 1; }
    rm -rf "$d"
}

test_seed_globs_default_and_custom() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1 || return 1
    _assert_eq "node_modules,.yarn" "$(_wt_repo_seeds proj)" "default seeds" || return 1
    wt register proj2 "$c" --seed 'node_modules,vendor' >/dev/null 2>&1 || return 1
    _assert_eq "node_modules,vendor" "$(_wt_repo_seeds proj2)" "custom seeds" || return 1
    rm -rf "$c"
}

test_clone_path_maps_legacy_agents_to_master() {
    local root; root=$(mktemp -d -t wt-root-XXXXXX); root="${root:A}"
    mkdir -p "${root}/master" "${root}/agents"
    echo "afm  ${root}/agents  worktree" >> "$WT_REPOS_FILE"
    _assert_eq "${root}/master" "$(_wt_clone_path afm)" "legacy .../agents → .../master" || return 1
    rm -rf "$root"
}

test_worktree_enumeration_and_resolvers() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local wtp="${c:h}/proj-feat"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b feat master >/dev/null 2>&1
    local n; n=$(_wt_worktrees "$c" | wc -l | tr -d ' ')
    _assert_eq "2" "$n" "clone + feature" || { rm -rf "$c" "$wtp"; return 1; }
    _assert_eq "$wtp" "$(_wt_resolve_target proj-feat)" "resolve by bare id" || { rm -rf "$c" "$wtp"; return 1; }
    _assert_eq "$wtp" "$(_wt_resolve_target proj/proj-feat)" "resolve by repo/id" || { rm -rf "$c" "$wtp"; return 1; }
    _assert_eq "${c}"$'\t'"proj" "$(_wt_owner_of_path "$wtp")" "owner" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c" "$wtp"
}

test_seed_copies_nested_node_modules_and_yarn() {
    local c; c=$(_mk_clone)
    local wtp="${c:h}/proj-seed"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b seed master >/dev/null 2>&1
    _wt_seed_run "$c" "$wtp" node_modules .yarn
    [[ -f "$wtp/node_modules/foo/i.js" ]] || { echo "    missing top node_modules"; rm -rf "$c" "$wtp"; return 1; }
    [[ -f "$wtp/pkg/node_modules/bar/b.js" ]] || { echo "    missing nested node_modules"; rm -rf "$c" "$wtp"; return 1; }
    [[ -f "$wtp/.yarn/c.txt" ]] || { echo "    missing .yarn"; rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c" "$wtp"
}

test_rm_removes_clean_worktree() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local wtp="${c:h}/proj-clean"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b clean master >/dev/null 2>&1
    _wt_seed_run "$c" "$wtp" node_modules .yarn
    _wt_rm_path "$c" "$wtp" 0 >/dev/null 2>&1
    _assert_absent "$wtp" "clean+seeded worktree removed without --force" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c"
}

test_rm_guards_unmerged_then_force() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local wtp="${c:h}/proj-work"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b work master >/dev/null 2>&1
    ( cd "$wtp"; echo n > t.txt; git add t.txt; git commit -qm w >/dev/null 2>&1 )
    _wt_rm_path "$c" "$wtp" 0 >/dev/null 2>&1
    [[ -d "$wtp" ]] || { echo "    guard failed to protect unmerged"; rm -rf "$c" "$wtp"; return 1; }
    _wt_rm_path "$c" "$wtp" 1 >/dev/null 2>&1
    _assert_absent "$wtp" "--force removed unmerged" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c"
}

test_rm_reports_cleanup_phases() {
    local c; c=$(_mk_clone)
    local wtp="${c:h}/proj-progress"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b progress master >/dev/null 2>&1
    local out; out=$(_wt_rm_path "$c" "$wtp" 1 2>&1)
    _assert_contains "$out" "Stopping warm-seed for proj-progress" || { rm -rf "$c" "$wtp"; return 1; }
    _assert_contains "$out" "Deleting worktree proj-progress" || { rm -rf "$c" "$wtp"; return 1; }
    _assert_contains "$out" "Deleting branch progress" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c"
}

test_tmux_panes_for_path() {
    tmux() {
        if [[ "$1" == "list-panes" ]]; then
            printf 's:1.0|/tmp/target\n'
            printf 's:1.1|/tmp/other\n'
            printf 's:2.0|/tmp/target\n'
        fi
    }
    local out; out=$(_wt_panes_for_path /tmp/target)
    unfunction tmux
    _assert_eq $'s:1.0\ns:2.0' "$out" "only exact matching panes" || return 1
}

test_rm_closes_matching_panes_only() {
    local c; c=$(_mk_clone)
    local wtp="${c:h}/proj-pane-safe"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b pane-safe master >/dev/null 2>&1
    local log="${c}.tmux-log"
    tmux() {
        case "$1" in
            list-panes)
                printf 's:1.0|%s\n' "$wtp"
                printf 's:1.1|%s\n' "${c}"
                printf 's:2.0|%s\n' "$wtp"
                ;;
            kill-pane) printf '%s\n' "$3" >> "$log" ;;
        esac
    }
    _wt_rm_path "$c" "$wtp" 1 >/dev/null 2>&1
    unfunction tmux
    _assert_eq $'s:1.0\ns:2.0' "$(<"$log")" "only matching panes are closed" || { rm -rf "$c" "$wtp" "$log"; return 1; }
    rm -rf "$c" "$wtp" "$log"
}

test_rm_refuses_main_clone() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local out; out=$(_wt_rm_path "$c" "$c" 0 2>&1)
    _assert_contains "$out" "main clone" || { rm -rf "$c"; return 1; }
    rm -rf "$c"
}

test_rm_repo_id_removes_merged() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local wtp="${c:h}/proj-x"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b x master >/dev/null 2>&1
    _wt_rm proj proj-x >/dev/null 2>&1
    _assert_absent "$wtp" "wt rm <repo> <id> removed merged worktree" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c"
}

test_rm_repo_unknown_id_errors() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local out; out=$(_wt_rm proj nope 2>&1)
    _assert_contains "$out" "No worktree 'nope'" || { rm -rf "$c"; return 1; }
    rm -rf "$c"
}

test_rm_all_removes_feature_worktrees() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local w1="${c:h}/proj-a" w2="${c:h}/proj-b"; w1="${w1:A}"; w2="${w2:A}"
    git -C "$c" worktree add "$w1" -b a master >/dev/null 2>&1
    git -C "$c" worktree add "$w2" -b b master >/dev/null 2>&1
    _wt_rm --all proj <<< "y" >/dev/null 2>&1
    { _assert_absent "$w1" "proj-a removed" && _assert_absent "$w2" "proj-b removed"; } || { rm -rf "$c" "$w1" "$w2"; return 1; }
    # main clone must survive --all
    [[ -d "$c" ]] || { echo "    main clone was removed by --all!"; return 1; }
    rm -rf "$c"
}

test_rm_no_arg_detects_cwd_worktree() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    local wtp="${c:h}/proj-cwd"; wtp="${wtp:A}"
    git -C "$c" worktree add "$wtp" -b cwd master >/dev/null 2>&1
    ( cd "$wtp" && _wt_rm >/dev/null 2>&1 )
    _assert_absent "$wtp" "no-arg wt rm removed the cwd worktree" || { rm -rf "$c" "$wtp"; return 1; }
    rm -rf "$c"
}

test_unregister_removes_repo() {
    local c; c=$(_mk_clone)
    wt register proj "$c" >/dev/null 2>&1
    wt unregister proj >/dev/null 2>&1
    _wt_is_repo proj && { echo "    still registered after unregister"; rm -rf "$c"; return 1; }
    rm -rf "$c"
}

test_init_uninit_aliases() {
    local c; c=$(_mk_clone)
    wt init proj "$c" >/dev/null 2>&1 || { echo "    init alias failed"; rm -rf "$c"; return 1; }
    _wt_is_repo proj || { echo "    init did not register"; rm -rf "$c"; return 1; }
    wt uninit proj >/dev/null 2>&1
    _wt_is_repo proj && { echo "    uninit did not unregister"; rm -rf "$c"; return 1; }
    rm -rf "$c"
}

test_removed_commands_are_stubbed() {
    local cmd out
    for cmd in new sync clean convert repo; do
        out=$(wt $cmd 2>&1)
        _assert_contains "$out" "removed" "wt $cmd stub" || return 1
    done
}

# ── runner ────────────────────────────────────────────────────────────────────

echo "Running wt tests..."
_run_test "slugify"                                      test_slugify
_run_test "tmux window names use repo and branch"         test_window_name
_run_test "register + clone path"                        test_register_and_clone_path
_run_test "register: rejects duplicate"                  test_register_rejects_duplicate
_run_test "register: rejects non-git path"               test_register_rejects_non_git
_run_test "seed globs default + custom"                  test_seed_globs_default_and_custom
_run_test "clone_path maps legacy .../agents → master"   test_clone_path_maps_legacy_agents_to_master
_run_test "worktree enumeration + resolvers (both ids)"  test_worktree_enumeration_and_resolvers
_run_test "seed copies nested node_modules + .yarn"      test_seed_copies_nested_node_modules_and_yarn
_run_test "rm: removes clean worktree"                   test_rm_removes_clean_worktree
_run_test "rm: guards unmerged, --force overrides"       test_rm_guards_unmerged_then_force
_run_test "rm: reports cleanup phases"                   test_rm_reports_cleanup_phases
_run_test "tmux: finds panes for exact worktree path"    test_tmux_panes_for_path
_run_test "rm: closes matching panes only"                test_rm_closes_matching_panes_only
_run_test "rm: refuses main clone"                       test_rm_refuses_main_clone
_run_test "rm <repo> <id>: removes merged worktree"      test_rm_repo_id_removes_merged
_run_test "rm <repo> <unknown-id>: errors"               test_rm_repo_unknown_id_errors
_run_test "rm --all: removes features, keeps main"       test_rm_all_removes_feature_worktrees
_run_test "rm (no arg): detects cwd worktree"            test_rm_no_arg_detects_cwd_worktree
_run_test "unregister removes repo"                      test_unregister_removes_repo
_run_test "init/uninit aliases work"                     test_init_uninit_aliases
_run_test "removed commands are stubbed"                 test_removed_commands_are_stubbed

echo ""
echo "──────────────────────────────────────"
echo "  PASS: $PASS   FAIL: $FAIL"
if (( FAIL > 0 )); then
    echo "  Failed:"
    printf '    - %s\n' "${FAILED_TESTS[@]}"
    exit 1
fi
echo "  All tests passed ✅"
