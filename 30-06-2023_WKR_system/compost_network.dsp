// Import the WKR Library
import("compost_library.lib");

// N = voices, M = network inputs.
N = 4;  M = 3;  
W(0) =  si.vecOp((si.bus(N * M), 
        par(i, N * M, ba.if((i >= 0) & 
        (i < N), .9, .05))), *);
W(1) =  si.vecOp((si.bus(N * M), 
        par(i, N * M, ba.if((i >= N) & 
        (i < (N * 2)), .9, .05))), *);
W(2) =  si.vecOp((si.bus(N * M),    
        par(i, N * M, ba.if((i >= (N * 2)) & 
        (i < (N * 3)), .9, .05))), *);

Compost_Network(ins, outs) =  
    hgroup("Waste_Kompost_System", 
    (si.bus(ins) <: 
        (par(i, M, W(i) : si.bus(N * M) :> si.bus(N)), 
        si.bus(N * M) :> par(i, M, Agent(i + 1))) ~ 
        (si.bus(N * M) <: si.bus(N * M * M)) :
            (si.bus(outs), si.block(12-outs)) 
    ))
with{ 
    Agent(0) = FDNBP(N, M);
    Agent(1) = FDNB2(N, M);
    Agent(2) = FDNAP(N, M);
    Agent(3) = FDNGN(N, M);
    Agent(4) = FDNG2(N, M);
};

process =  Compost_Network(4, 2);       