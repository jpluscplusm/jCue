# jCue

jCue is a *horrible* way to use CUE as if it were `jq`. Well, for (relatively)
statically patched structured data, at least. 

jCue exposes a single definition: `#Patch`. This definition has a couple of
fields:

- `#Input`: put your source data here
- `#Output`: get your patched data back from here

A "patch" is simply a struct containing data that you'd like to take precedence
over the source data, in exactly the same shape as the source data. It can
contain a subset of the source data structure, and only those fields present in
the patch are overridden - the rest of the source data is left unchanged.

To apply a patch, simply unify it with the `#Output` field:

```cue
output: patch & {jCue.#Patch & {#Input: input}}.#Output
```

## Example

See [/demo.cue](demo.cue):

```
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
```

Run this demo as follows:

```shell
$ cue export .:demo -e output
{
    "x": 2,
    "y": "string in patch",
    "z": {
        "a": 56
    },
    "b": [
        {
            "name": "foo",
            "val": 10
        },
        {
            "name": "string in patch",
            "val": 20
        }
    ]
}
```

## Caveats

1. This isn't /exactly/ a joke, but don't use it in production.  
   Or do; I'm a README, not a cop.
1. Your source data and patch can't contain any CUE defaults
1. Performance is ok for small source data, but it will rapidly approach "very very
   poor" as source data size grows

## Bugs

Yes.
