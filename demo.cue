package demo

import "github.com/jpluscplusm/jCue"

input: {
	x: 1
	y: "string in input"
	z: {
		a: 56
	}
	b: [{
		name: "foo"
		val:  10
	}, {
		name: "string in input"
		val:  20
	},
	]
}

patch: {
	x: 2
	y: "string in patch"
	b: [_,
		{name: "string in patch"},
	]
}

output: patch & {jCue.#Patch & {#Input: input}}.#Output
