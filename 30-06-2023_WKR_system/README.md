# Waste_Kompost_Radio

WKR is a constant radio flow of composting sound. The sounds are processed through a neo-built algorithm which gradually decomposes the sonic information throughout the year, applying the same mechanisms of biological and chemical reactions which decompose organic material into compost.

## Files tree

```bash
tree
.
└── compost_library.lib
    └── compost_bioagents.dsp
        └── compost_network.lib
```

## Compile

```bash
$ faust -sd -sn -svg compost_network.dsp
```
