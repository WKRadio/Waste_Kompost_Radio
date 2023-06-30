// Import the WKR Library
import("compost_library.lib");


// N = voices, M = network inputs.
N = 4;  M = 3;  
W(0) = si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= 0) & 
    (i < N), .9, .05))), *);
W(1) = si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= N) & 
    (i < (N * 2)), .9, .05))), *);
W(2) = si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= (N * 2)) & 
    (i < (N * 3)), .9, .05))), *);
Compost_Network =  si.bus(N) <: 
    (par(i, M, W(i) : si.bus(N * M) :> si.bus(N)), 
     si.bus(N * M) :> par(i, M, Agent(i+1))) ~ 
    (si.bus(N * M) <: si.bus(N * M * M))
with{ 
    FDNBP = component("compost_bioagents.dsp").FDNBP; Agent(0) = FDNBP(N, M);
    FDNB2 = component("compost_bioagents.dsp").FDNB2; Agent(1) = FDNB2(N, M);
    FDNAP = component("compost_bioagents.dsp").FDNAP; Agent(2) = FDNAP(N, M);
    FDNGN = component("compost_bioagents.dsp").FDNGN; Agent(3) = FDNGN(N, M);
    FDNG2 = component("compost_bioagents.dsp").FDNG2; Agent(4) = FDNG2(N, M);
};
process = Compost_Network;