# Zsh completion for git-worktree-dir:
#   - Direct:  git-worktree-dir svs-<TAB>
#   - Git alias: git wtdir svs-<TAB>  (requires alias.wtdir)
#
# zsh's _git dispatches subcommands as _git-$words[1] after its internal _arguments.
# For "git wtdir …", words[1] is still "git" at that point, so zsh looks up _git-git
# (missing) instead of _git-wtdir — alias completion never runs. We wrap _git and
# hand off to the ticket compadd when the cursor is past the "wtdir" token.
#
# zsh may replace _git during compsys (e.g. after _dispatch). We keep the real git
# completer in _git_worktree_dir__orig_git once, then re-apply a thin wrapper from
# compprefuncs at the start of every _main_complete so the next Tab still sees it.
#
# Until _git is fully loaded, it can be an autoload stub; autoload +X _git before the
# first functions -c avoids the stub loading into _git when delegating before the
# cursor passes "wtdir".
#
# Setup:
#   git config --global alias.wtdir '!"/path/to/git-worktree-dir"'
#   # or if you need explicit $1 inside sh -c: !sh -c '"/path/to/git-worktree-dir" "$1"' -
#   # in ~/.zshrc after compinit (order matters — compinit must run first):
#   source /path/to/repo/bin/git-worktree-dir.completion.zsh
#   # If you sourced before compinit once, source this file again after compinit.
#
# If the script is not beside this file and not on PATH, set before sourcing:
#   export GIT_WORKTREE_DIR_SCRIPT=/path/to/git-worktree-dir
#
# If your alias name is not wtdir, change wtdir below in both places.

typeset -g _GIT_WORKTREE_DIR_COMPLETION_DIR="${${(%):-%x}:A:h}"

_git_worktree_dir_bin() {
	if [[ -n ${GIT_WORKTREE_DIR_SCRIPT:-} ]]; then
		print -r -- "${GIT_WORKTREE_DIR_SCRIPT}"
		return 0
	fi
	if [[ -x ${_GIT_WORKTREE_DIR_COMPLETION_DIR}/git-worktree-dir ]]; then
		print -r -- "${_GIT_WORKTREE_DIR_COMPLETION_DIR}/git-worktree-dir"
		return 0
	fi
	command -v git-worktree-dir 2>/dev/null
}

_git_worktree_dir_ticket_ids() {
	local script out lines pref cmd git_wtdir_ctx=0
	script="$(_git_worktree_dir_bin)" || return 1
	[[ -n ${script} ]] || return 1

	if [[ ${words[1]:-} == git && ${words[2]:-} == wtdir ]]; then
		git_wtdir_ctx=1
		# Align PREFIX/CURRENT with the ticket word (same as standalone completion).
		compset -n 2 || return 1
	fi

	if (( git_wtdir_ctx )); then
		cmd=wtdir
	elif [[ -n ${words[1]:-} ]]; then
		cmd=${words[1]}
	else
		cmd=
	fi

	pref="${(Q)PREFIX}${(Q)SUFFIX}"
	[[ -n ${cmd} && ${pref} == "${cmd}" ]] && pref=
	if [[ -z ${pref} && -n ${words[CURRENT]:-} && ${words[CURRENT]} != "${cmd}" ]]; then
		pref=${(Q)words[CURRENT]}
	fi

	out="$(${script} --complete-candidates ${pref})" || return 1
	[[ -n ${out} ]] || return 1
	local -a labels descs disps
	local line
	for line in "${(@f)out}"; do
		[[ -n ${line} ]] || continue
		if [[ ${line} == *$'\t'* ]]; then
			labels+=("${line%%$'\t'*}") 
			descs+=("${line#*$'\t'}")
		else
			labels+=("${line}")
			descs+=("")
		fi
	done
	(( ${#labels} )) || return 1
	local -i max_len=0 i
	for line in "${labels[@]}"; do
		(( ${#line} > max_len )) && max_len=${#line}
	done
	local disp_line
	for (( i = 1; i <= ${#labels}; i++ )); do
		# zsh printf -v accepts only a plain identifier, not disps[i].
		printf -v disp_line "%-*s  -- %s" max_len "${labels[i]}" "${descs[i]}"
		disps+=("$disp_line")
	done
	# -d gives the list text; matches stay the raw ticket ids. -l: one entry per line.
	compadd -Q -l -d disps -a labels
}

# Used for compdef on git-worktree-dir (direct invocation).
_git_worktree_dir_command() {
	local curcontext="${curcontext}" state ret=1
	declare -A opt_args

	_arguments -C -s \
		'1:ticket id:->tickets' && ret=0

	case ${state} in
	tickets)
		_git_worktree_dir_ticket_ids
		return
		;;
	esac

	return ret
}

_git-wtdir() {
	_git_worktree_dir_ticket_ids
}

compdef _git_worktree_dir_command git-worktree-dir
_script="$(_git_worktree_dir_bin)"
[[ -n ${_script} ]] && compdef _git_worktree_dir_command "${_script}"
unset _script

_git_worktree_dir__wrap_git() {
	if [[ ${words[1]:-} == git && ${words[2]:-} == wtdir ]] && (( CURRENT > ${words[(i)wtdir]} )); then
		_git_worktree_dir_ticket_ids
		return
	fi
	_git_worktree_dir__orig_git "$@"
}

_git_worktree_dir__git_is_wrapped() {
	[[ ${functions[_git]-} == *"_git_worktree_dir__wrap_git"* ]]
}

_git_worktree_dir__install_git_wrapper() {
	if _git_worktree_dir__git_is_wrapped; then
		return 0
	fi
	if (( $+functions[_git_worktree_dir__orig_git] )); then
		_git() {
			_git_worktree_dir__wrap_git "$@"
		}
		return 0
	fi
	(( $+functions[_git] )) || autoload -Uz _git 2>/dev/null || return 1
	autoload -Uz +X _git 2>/dev/null || true
	(( $+functions[_git] )) || return 1
	functions -c _git _git_worktree_dir__orig_git
	_git() {
		_git_worktree_dir__wrap_git "$@"
	}
}

_git_worktree_dir__comp_pre_ensure_git_wrapper() {
	_git_worktree_dir__install_git_wrapper
	compprefuncs+=( _git_worktree_dir__comp_pre_ensure_git_wrapper )
}

autoload -Uz +X _git 2>/dev/null || true
if (( $+functions[_git] )); then
	_git_worktree_dir__install_git_wrapper
fi

if [[ " ${compprefuncs[*]} " != *" _git_worktree_dir__comp_pre_ensure_git_wrapper "* ]]; then
	compprefuncs+=( _git_worktree_dir__comp_pre_ensure_git_wrapper )
fi
