declare name "WKR Compost Networks";
declare author "Luca Spanedda";
declare author "Dario Sanfilippo";
declare version "1.0";
declare description "2023";
declare copyright "Copyright (C) 2023 Luca Spanedda <lucaspanedda1995@gmail.com>";
declare license "MIT license";
// Import the WKR Library
import("compost_library.lib");
// N = voices,  M = network inputs.
N = 4; M = 3;


/************************************************************************
************************************************************************
- AGENTS NETWORKS -
************************************************************************
************************************************************************/


AgentCulture(N, M, S) =  
    (netINPeaks : delays(S) : gains : netLimt : hgroup("ControlSignals", cntrlSignal) <: 
	(hgroup("Agents", Agent(S)), (si.block(N), MapDynaComp)) : routeSig : hgroup("DynamicCompressors", netdynComp) : netStability) ~ 
        	(matrix) <: (netEnergy, si.bus(N)) : ro.crossNM(N, N)
with{
    routeSig = ro.crossNM(N, N) : ro.interleave(N, N / 2);
    // Agents Network
    gains = vecOp((si.bus(N) , par(i, N, 16)), *);
    matrix = vecOp((hadamard(N) , par(i, N, 1.0 / sqrt(N))), *);
    //netInsx = vecOp((si.bus(N) , si.bus(N)), +); 
    netINPeaks = si.bus(N), (si.bus(N) <: si.bus(N * 2)) : 
        vecOp((vecOp((si.bus(N), par(i, N, 1 - peakenvelope(10))), *), si.bus(N)), +); 
    netdynComp = par(i, N, si.bus(2) : dynamiComp(S, i, .5, 100)); 
    netLimt = par(i, N, LookaheadLimiter(1.0, .002, 10));  
    netStability = par(i, N, HPTPT(40) : LPTPT(15000)); 
    delays(T) = vecOp((si.bus(N) , par(i, N, (ba.take((i + 1 + T) * 10, primesThousands) : MS2T))), @);
    netEnergy = par(i, N, energy(100, 200));
    cntrlSignal = si.bus(N) <: (si.bus(N), par(i, N, controlSignalProcessing(S, i, 48, 10)));
    // Mapping
    MapDynaComp = par(i, N, 48 ^ _ );
    MapBP = par(i, N, vgroup("FC", MapBPf(i)), MapBPx(i))
    with{
        MapBPf(i) = 640 * 2 ^ (4 * _) : info(i, 0, 20000);
        MapBPx(i) = _;
    };
    MapAP = par(i, N, MapOut(i), MapAPx(i))
    with{
        MapOut(i) = _ <: vgroup("Time", MapAPt(i)), vgroup("Gain", MapAPg(i));
        MapAPt(i) = 10 ^ (2 * _ - 1) : infoScale(i, 0, 10) : _ * ma.SR;
        MapAPg(i) = _ : biToUni : map(-0.999, 0.999) : infoScale(i, -1, 1);
        MapAPx(i) = _;
    };
    MapGN = par(i, N, vgroup("Jit", MapGNj(i)), vgroup("Pitch", MapGNp(i)), MapGNx(i))
    with{
        MapGNj(i) = 1;
        MapGNp(i) = 4 ^ _ : infoScale(i, -1, 4);
        MapGNx(i) = _;
    };
    // Agents
    Agent(0) = hgroup("0 BP Agent", routeSig : MapBP : par(i, N, BPSVF(1)));
    Agent(1) = hgroup("1 AP Agent", routeSig : MapAP : par(i, N, AllpassWernerCascade(8, 192000, 60 * ma.SR)));
    Agent(2) = hgroup("2 GN Agent", routeSig : MapGN : par(i, N, Stretcher(30, 30, 1, 1, 1, 0, 10, i)));  
};
// Populations
Populations = par(i, M, AgentCulture(4, 3, i));

// Populations influences (Matrix Of  Influences)
// Populations Influences: (Int Populations, Ext Populations) in Percent
MatrixOfInfluences(Int, Ext) = si.bus(N * M) <: par(i, M, W(i) : si.bus(N * M) :> si.bus(N))
with{
    percent(P) = (1 / 100) * P;
    W(0) =  si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= 0) & (i < N), percent(Int), percent(Ext/2) ))), *);
    W(1) =  si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= N) & (i < (N * 2)), percent(Int), percent(Ext/2)))), *);
    W(2) =  si.vecOp((si.bus(N * M), par(i, N * M, ba.if((i >= (N * 2)) & (i < (N * 3)), percent(Int), percent(Ext/2)))), *);
};   

// Organisms live population growth
GrowthModel(E) = hgroup("Growth Model", par(i, M, vgroup("Population %i", populationGrowth(i, 24, E))));
// Listening points of the network
ListeningPoints = si.bus(N * M) <: (
    lerpMulti(12, hslider("Listening Point 1", 0, 0, 1, .001)),
    lerpMulti(12, hslider("Listening Point 2", 0, 0, 1, .001))
);


/************************************************************************
************************************************************************
- COMPOST SYSTEM NETWORK (Main) -
************************************************************************
************************************************************************/


// Main Compost Network
WKR_Network =  vgroup("Waste_Kompost_System", 
(
    vecOp((MatrixOfInfluences(95, 5), si.bus(N * M)), +) :
        Populations : (par(i, M, (si.bus(N)), (si.bus(N) :> _)) <: 
            (par(i, M, si.block(N), _) :> _/(N * M)), 
            (par(i, M, si.bus(N), !))) 
            : (!, si.bus(N * M)) // : GrowthModel // 
    ) ~ si.bus(N * M)
) :> (_/(N * M / 2)), (_/(N * M / 2)); // : ListeningPoints; //
// outs
process = si.bus(2) <: WKR_Network;