#!/usr/bin/env zsh
# Tests for wt — run with: zsh wt/test_wt.zsh
# Exits non-zero on failure. Each test runs against an isolated WT_CONFIG_DIR.

set -u
emulate -L zsh
setopt extended_glob

SCRIPT_DIR="${0:A:h}"
PASS=0
FAIL=0
FAILED_TESTS=()

_setup() {
    WT_CONFIG_DIR=$(mktemp -d -t wt-test-XXXXXX)
    WT_CONFIG_DIR="${WT_CONFIG_DIR:A}"
    WT_REPOS_FILE="${WT_CONFIG_DIR}/repos"
    WT_TITLES_FILE="${WT_CONFIG_DIR}/.titles"
    export WT_CONFIG_DIR WT_REPOS_FILE WT_TITLES_FILE
    export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
    source "${SCRIPT_DIR}/wt.zsh"
}

_mktemp_resolved() {
    local d
    d=$(mktemp -d -t "$1")
    echo "${d:A}"
}

_teardown() {
    [[ -n "${WT_CONFIG_DIR:-}" && "$WT_CONFIG_DIR" == /tmp/* ]] && rm -rf "$WT_CONFIG_DIR"
    unset WT_CONFIG_DIR WT_REPOS_FILE WT_TITLES_FILE
}

_assert_eq() {
    local expected="$1" actual="$2" msg="${3:-}"
    if [[ "$expected" == "$actual" ]]; then
        return 0
    else
        echo "    expected: '$expected'"
        echo "    actual:   '$actual'"
        [[ -n "$msg" ]] && echo "    note:     $msg"
        return 1
    fi
}

_assert_contains() {
    local haystack="$1" needle="$2" msg="${3:-}"
    if [[ "$haystack" == *"$needle"* ]]; then
        return 0
    else
        echo "    expected to contain: '$needle'"
        echo "    actual:              '$haystack'"
        [[ -n "$msg" ]] && echo "    note:                $msg"
        return 1
    fi
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

# ── tests ────────────────────────────────────────────────────────────────────

test_register_single_mode_when_no_master_or_agents() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    git -C "$repo_dir" init -q

    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1 || return 1
    _assert_eq "single" "$(_wt_repo_kind tiny)" "kind should be single" || return 1
    _assert_eq "$repo_dir" "$(_wt_repo_path tiny)" "path should be repo_dir" || return 1
    rm -rf "$repo_dir"
}

test_register_worktree_mode_when_master_and_agents_exist() {
    local root
    root=$(_mktemp_resolved wt-root-XXXXXX)
    mkdir -p "${root}/master" "${root}/agents"

    _wt_repo_register "multi" "$root" >/dev/null 2>&1 || return 1
    _assert_eq "worktree" "$(_wt_repo_kind multi)" "kind should be worktree" || return 1
    _assert_eq "${root}/agents" "$(_wt_agents_dir multi)" "agents_dir should be <root>/agents" || return 1
    rm -rf "$root"
}

test_register_worktree_mode_when_path_is_agents_dir_directly() {
    local root
    root=$(_mktemp_resolved wt-root-XXXXXX)
    mkdir -p "${root}/master" "${root}/agents"

    _wt_repo_register "multi2" "${root}/agents" >/dev/null 2>&1 || return 1
    _assert_eq "worktree" "$(_wt_repo_kind multi2)" || return 1
    _assert_eq "${root}/agents" "$(_wt_repo_path multi2)" || return 1
    rm -rf "$root"
}

test_repos_file_writes_three_columns() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    local last_line
    last_line=$(grep -v '^\s*#' "$WT_REPOS_FILE" | grep -v '^\s*$' | tail -1)
    local cols
    cols=$(echo "$last_line" | awk '{print NF}')
    _assert_eq "3" "$cols" "row should have 3 columns: name path kind" || return 1
    rm -rf "$repo_dir"
}

test_repos_helper_defaults_legacy_two_column_rows_to_worktree() {
    _wt_ensure_config
    echo "legacy  /tmp/legacy/agents" >> "$WT_REPOS_FILE"
    local kind
    kind=$(_wt_repo_kind legacy)
    _assert_eq "worktree" "$kind" "2-col legacy row should default to worktree" || return 1
}

test_repo_root_returns_path_for_single_mode() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    _assert_eq "$repo_dir" "$(_wt_repo_root tiny)" || return 1
    rm -rf "$repo_dir"
}

test_repo_root_returns_parent_of_agents_for_worktree_mode() {
    local root
    root=$(_mktemp_resolved wt-root-XXXXXX)
    mkdir -p "${root}/master" "${root}/agents"
    _wt_repo_register "multi" "$root" >/dev/null 2>&1
    _assert_eq "$root" "$(_wt_repo_root multi)" || return 1
    rm -rf "$root"
}

test_register_rejects_nonexistent_path() {
    local out
    out=$(_wt_repo_register "ghost" "/nonexistent/path/xyz" 2>&1)
    _assert_contains "$out" "does not exist" "should warn about missing path" || return 1
}

test_register_rejects_duplicate_name() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "dup" "$repo_dir" >/dev/null 2>&1
    local out
    out=$(_wt_repo_register "dup" "$repo_dir" 2>&1)
    _assert_contains "$out" "already registered" || return 1
    rm -rf "$repo_dir"
}

test_wt_new_rejects_single_mode_repo() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    local out
    out=$(_wt_new "tiny" 1 2>&1)
    _assert_contains "$out" "single-mode" "wt new on single repo should reject" || return 1
    _assert_contains "$out" "wt tiny" "should hint at workspace command" || return 1
    rm -rf "$repo_dir"
}

test_wt_rm_rejects_single_mode_repo_bulk() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    local out
    out=$(_wt_rm "tiny" 2>&1)
    _assert_contains "$out" "single-mode" || return 1
    rm -rf "$repo_dir"
}

test_wt_rm_rejects_single_mode_repo_with_num() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    local out
    out=$(_wt_rm "tiny-1" 2>&1)
    _assert_contains "$out" "single-mode" || return 1
    rm -rf "$repo_dir"
}

test_wt_sync_rejects_num_for_single_mode() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    git -C "$repo_dir" init -q
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    local out
    out=$(_wt_sync "tiny-1" 2>&1)
    _assert_contains "$out" "doesn't apply" || return 1
    rm -rf "$repo_dir"
}

test_repo_list_shows_kind_column() {
    local repo_dir root
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    root=$(_mktemp_resolved wt-root-XXXXXX)
    mkdir -p "${root}/master" "${root}/agents"

    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    _wt_repo_register "multi" "$root" >/dev/null 2>&1

    local out
    out=$(_wt_repo_list 2>&1)
    _assert_contains "$out" "KIND" "header should include KIND" || return 1
    _assert_contains "$out" "single" "tiny should show as single" || return 1
    _assert_contains "$out" "worktree" "multi should show as worktree" || return 1

    rm -rf "$repo_dir" "$root"
}

test_window_name_no_title_returns_id_only() {
    _assert_eq "rr"     "$(_wt_window_name rr "")"     || return 1
    _assert_eq "afm-1"  "$(_wt_window_name afm-1 "")"  || return 1
}

test_window_name_with_title_returns_id_colon_title() {
    _assert_eq "rr: Bug fix"     "$(_wt_window_name rr "Bug fix")"   || return 1
    _assert_eq "afm-3: Refactor" "$(_wt_window_name afm-3 "Refactor")" || return 1
}

test_unregister_removes_repo() {
    local repo_dir
    repo_dir=$(_mktemp_resolved wt-repo-XXXXXX)
    _wt_repo_register "tiny" "$repo_dir" >/dev/null 2>&1
    _wt_repo_unregister "tiny" >/dev/null 2>&1
    _assert_eq "" "$(_wt_repo_kind tiny)" "kind lookup should be empty after unregister" || return 1
    rm -rf "$repo_dir"
}

# ── runner ───────────────────────────────────────────────────────────────────

echo "Running wt tests..."
echo

_run_test "register: single-mode auto-detected for plain dir"           test_register_single_mode_when_no_master_or_agents
_run_test "register: worktree-mode auto-detected for root with master+agents" test_register_worktree_mode_when_master_and_agents_exist
_run_test "register: worktree-mode auto-detected when path IS agents dir"     test_register_worktree_mode_when_path_is_agents_dir_directly
_run_test "register: writes 3-column row"                                     test_repos_file_writes_three_columns
_run_test "compat: 2-column legacy rows default to worktree"                  test_repos_helper_defaults_legacy_two_column_rows_to_worktree
_run_test "_wt_repo_root: single-mode returns path"                           test_repo_root_returns_path_for_single_mode
_run_test "_wt_repo_root: worktree-mode returns parent of agents"             test_repo_root_returns_parent_of_agents_for_worktree_mode
_run_test "register: rejects nonexistent path"                                test_register_rejects_nonexistent_path
_run_test "register: rejects duplicate name"                                  test_register_rejects_duplicate_name
_run_test "wt new: rejects single-mode repo"                                  test_wt_new_rejects_single_mode_repo
_run_test "wt rm <repo>: rejects single-mode repo (bulk)"                     test_wt_rm_rejects_single_mode_repo_bulk
_run_test "wt rm <repo-num>: rejects single-mode repo"                        test_wt_rm_rejects_single_mode_repo_with_num
_run_test "wt sync <repo-num>: rejects num for single-mode repo"              test_wt_sync_rejects_num_for_single_mode
_run_test "wt repo list: shows KIND column"                                   test_repo_list_shows_kind_column
_run_test "_wt_window_name: no title returns just the id"                     test_window_name_no_title_returns_id_only
_run_test "_wt_window_name: with title returns 'id: title'"                   test_window_name_with_title_returns_id_colon_title
_run_test "wt repo unregister: removes the repo"                              test_unregister_removes_repo

echo
echo "Results: ${PASS} passed, ${FAIL} failed"
if (( FAIL > 0 )); then
    echo "Failed tests:"
    for t in "${FAILED_TESTS[@]}"; do
        echo "  - $t"
    done
    exit 1
fi
exit 0
