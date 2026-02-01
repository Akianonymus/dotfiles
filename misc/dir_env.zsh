# Directory-based environment variables
# Automatically loads/unsets env vars based on current directory
# Configuration: ~/.secrets.json
# 
# Pattern precedence:
# - Higher priority values override lower priority values
# - When priorities are equal, JSON order wins (first pattern wins)
# - Priority field is optional (defaults to 0)
# 
# Example:
#   { "pattern": "/**", "priority": 0, "env_vars": {...} }           # defaults
#   { "pattern": "/home/aki/**", "priority": 5, "env_vars": {...} }  # overrides
#   { "pattern": "/home/aki/project/**", "priority": 10, ... }      # specific overrides

typeset -gA _dir_env_prev_vars
typeset -g _dir_env_prev_dir=""
typeset -gA _dir_env_var_source
typeset -ga _dir_env_active_patterns=()
typeset -ga _dir_env_patterns=()
typeset -ga _dir_env_vars_list=()
typeset -ga _dir_env_priorities=()

_unset_dir_env_vars() {
	[[ -n $_dir_env_prev_dir ]] || {
		_load_dir_env_vars
		return 0
	}
	
	local old_active_patterns=($_dir_env_active_patterns)
	_dir_env_active_patterns=()
	
	_load_dir_env_vars
	
	local new_active_patterns=($_dir_env_active_patterns)
	
	local i
	for i in "${old_active_patterns[@]}"; do
		local still_active=false
		local j
		for j in "${new_active_patterns[@]}"; do
			[[ $i -eq $j ]] && still_active=true && break
		done
		
		if ! $still_active; then
			local vars="$_dir_env_vars_list[$i]"
			while IFS= read -r line; do
				[[ -z $line ]] && continue
				local key="${line%%=*}"
				local source_idx=$_dir_env_var_source[$key]
				[[ $source_idx -eq $i ]] && {
					unset $key
					unset "_dir_env_prev_vars[$key]"
					unset "_dir_env_var_source[$key]"
				}
			done <<< "$vars"
		fi
	done
	
	_dir_env_prev_dir="$PWD"
}

_load_dir_env_config() {
	local secrets_file="$HOME/.secrets.json"
	[[ -f $secrets_file ]] || return 1

	local perms=$(stat -c %a $secrets_file 2>/dev/null || stat -f %Lp $secrets_file 2>/dev/null)
	if [[ $perms != "600" ]]; then
		echo "Warning: $secrets_file has insecure permissions ($perms)" >&2
	fi

	_dir_env_patterns=()
	_dir_env_vars_list=()
	_dir_env_priorities=()

	local parsed_data
	if command -v jq >/dev/null; then
		parsed_data=$(jq -r '.directory_envs | to_entries | .[] | 
			(.key | tonumber) as $idx |
			(.value.priority // 0) as $prio |
			(if .value.path then .value.path else .value.pattern end) as $pat |
			(.value.env_vars // {} | to_entries[] | "\(.key)=\(.value)") as $vars |
			"\($prio)|\($idx)|\($pat)|\($vars)"' $secrets_file 2>/dev/null)
	else
		parsed_data=$(python -c "
import json, sys
try:
    with open('$secrets_file', 'r') as f:
        data = json.load(f)
    for idx, entry in enumerate(data.get('directory_envs', [])):
        prio = entry.get('priority', 0)
        pat = entry.get('path', entry.get('pattern', ''))
        for k, v in entry.get('env_vars', {}).items():
            print(f'{prio}|{idx}|{pat}|{k}={v}')
except Exception as e:
    sys.stderr.write(str(e) + '\n')
    sys.exit(1)
" 2>/dev/null)
	fi

	[[ -n $parsed_data ]] || return 1

	declare -a tmp_prio=()
	declare -a tmp_idx=()
	declare -a tmp_pat=()
	declare -A tmp_vars=()

	local current_prio=""
	local current_idx=""
	local current_pat=""
	local current_vars=""
	
	while IFS= read -r line; do
		[[ -z $line ]] && continue
		local prio="${line%%|*}"
		local rest="${line#*|}"
		local idx="${rest%%|*}"
		rest="${rest#*|}"
		local pat="${rest%%|*}"
		local var="${rest#*|}"

		if [[ $pat != $current_pat ]]; then
			[[ -n $current_pat ]] && {
				tmp_prio+=($current_prio)
				tmp_idx+=($current_idx)
				tmp_pat+=($current_pat)
				tmp_vars[$current_pat]="$current_vars"
			}
			current_prio=$prio
			current_idx=$idx
			current_pat=$pat
			current_vars=$var$'\n'
		else
			current_vars+=$var$'\n'
		fi
	done <<< "$parsed_data"

	[[ -n $current_pat ]] && {
		tmp_prio+=($current_prio)
		tmp_idx+=($current_idx)
		tmp_pat+=($current_pat)
		tmp_vars[$current_pat]="$current_vars"
	}

	(( ${#tmp_pat[@]} == 0 )) && return 0

	declare -a sorted_indices=()
	local i
	for i in {1..$#tmp_pat}; do
		sorted_indices+=($i)
	done

	local swapped
	for ((i = 1; i <= $#tmp_pat; i++)); do
		swapped=false
		for ((j = 1; j <= $#tmp_pat - i; j++)); do
			local k1=$sorted_indices[$j]
			local k2=$sorted_indices[$((j + 1))]
			local prio1=$tmp_prio[$k1]
			local prio2=$tmp_prio[$k2]
			local idx1=$tmp_idx[$k1]
			local idx2=$tmp_idx[$k2]
			
			if [[ $prio1 -gt $prio2 ]] || [[ $prio1 -eq $prio2 && $idx1 -gt $idx2 ]]; then
				sorted_indices[$j]=$k2
				sorted_indices[$((j + 1))]=$k1
				swapped=true
			fi
		done
		[[ $swapped == false ]] && break
	done

	for i in "${sorted_indices[@]}"; do
		_dir_env_priorities+=($tmp_prio[$i])
		_dir_env_patterns+=($tmp_pat[$i])
		_dir_env_vars_list+=("${tmp_vars[$tmp_pat[$i]]}")
	done

	return 0
}

_load_dir_env_vars() {
	(( $#_dir_env_patterns )) || _load_dir_env_config || return 1

	_dir_env_active_patterns=()
	
	local i
	for i in {1..$#_dir_env_patterns}; do
		local pat="$_dir_env_patterns[i]"
		local matched=false
		
		if [[ $pat == *"/**" ]]; then
			local base_pat="${pat%\/**}"
			[[ $PWD = $~base_pat || $PWD = $~base_pat/* ]] && matched=true
		else
			[[ $PWD = $~pat ]] && matched=true
		fi
		
		if $matched; then
			_dir_env_active_patterns+=($i)
			local vars="$_dir_env_vars_list[i]"
			while IFS= read -r line; do
				[[ -z $line ]] && continue
				local key="${line%%=*}"
				local value="${line#*=}"
				export "$key=$value"
				_dir_env_prev_vars[$key]="$value"
				_dir_env_var_source[$key]=$i
			done <<< "$vars"
		fi
	done
}

chpwd() {
	_unset_dir_env_vars
}

_load_dir_env_vars
