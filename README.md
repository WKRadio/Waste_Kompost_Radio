# Waste_Kompost_Radio

WKR is a constant radio flow of composting sound. The sounds are processed through a neo-built algorithm which gradually decomposes the sonic information throughout the year, applying the same mechanisms of biological and chemical reactions which decompose organic material into compost.

## Files tree

```bash
tree
.
└── prime_numbers.dsp
    └── compost_library.lib
        └── compost_networks.dsp
```

## Compile

```bash
$ faust2juce -double compost_networks.dsp
```
```bash
$ faust -sd -sn -svg compost_networks.dsp
```
