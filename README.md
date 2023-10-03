# Waste_Kompost_Radio

WKR is a constant radio flow of composting sound. The sounds are processed through a neo-built algorithm which gradually decomposes the sonic information throughout the year, applying the same mechanisms of biological and chemical reactions which decompose organic material into compost.

What does it mean to transpose such a complex phenomenon as the principle of biodegradation leading to the creation of compost, into a biodegradation of sonic waste?
How is it possible to transpose all the organisms present in the composting process, which are mainly: bacteria, fungi and actinomycetes?
The answer to these questions arose from understanding what it means, from a philosophical point of view, to go from organic matter to compost.
Compost is the result of the biological activity of decomposition of organic waste by billions of micro-organisms that, in the presence of oxygen, transform organic matter into humus. These microorganisms thus take the energy they need for their metabolic activities and activate a series of biochemical reactions that release substances such as water, carbon dioxide, mineral salts and humus, contained in the organic material, to give rise to compost.

So how can we imagine a transduction of those principles that occur in the composting process by realising them through a sound process? 
Fourier's theorem states that any periodic signal is given by the superposition of simple sine waves, each with its own amplitude and phase, and whose frequencies are harmonics of the signal's fundamental frequency; based on this principle, we have modelled an autonomous network that extracts its individual characteristics from the sound over time. 
Through the use of specific agents, the sound input to the system is then decomposed by extracting over time a variety of the individual components that made up the original sound, recombining them into new possible configurations of 'minerals and substances' extracted from the sound.

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
