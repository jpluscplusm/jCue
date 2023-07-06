package jCue

#Patch: {
	#Input: {...}
	#Output: {
		for k, v in #Input
		let _is_list = bool & ((v & [...]) != _|_)
		let _is_struct = bool & ((v & {...}) != _|_)
		let _is_complex = bool & (_is_list || _is_struct) {
			if !_is_complex {"\(k)": *v | _}
			if _is_complex {
				if _is_struct {
					"\(k)": *{{#Patch & {#Input: v}}.#Output} | _
				}
				if _is_list {
					"\(k)": {{#Patch & {#Input: v}}.#Output}
				}
			}
		}, ...
	}
} | {
	#Input: [...]
	#Output: [
		for v in #Input
		let _is_list = bool & ((v & [...]) != _|_)
		let _is_struct = bool & ((v & {...}) != _|_)
		let _is_complex = bool & (_is_list || _is_struct) {
			if !_is_complex {*v | _}
			if _is_complex {
				if _is_struct {*{{#Patch & {#Input: v}}.#Output} | _}
				if _is_list {{#Patch & {#Input: v}}.#Output}
			}
		},
	]
}
