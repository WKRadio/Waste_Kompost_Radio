// Import the WKR Library
import("LIB.lib");


// Classic FDN derived from Sanfilippo's vecOp code
vecOp(vectorsList, op) =
    vectorsList : seq(i, vecDim - 1, vecOp2D , vecBus(vecDim - 2 - i))
    with {
        vecBus(0) = par(i, vecLen, 0 : !);
        vecBus(dim) = par(i, dim, si.bus(vecLen));
        vecOp2D = ro.interleave(vecLen, 2) : par(i, vecLen, op);
        vecDim = outputs(vectorsList) / vecLen;
        vecLen = outputs(ba.take(1, vectorsList));
    };
// vector FDN Matrix
vecMx(N, gatesList) = si.bus(N) <: par(i, N, (vecOp((si.bus(N), gatesList), *) :> +) );


FDN =   (vecOp((si.bus(N) , si.bus(N)), +) : vecOp((si.bus(N), D), @))~
        (vecMx(N, M) : vecOp((si.bus(N), G), *))
with{
    N = 4; 
    G = 1/N, 1/N, 1/N, 1/N; 
    D = 1, 1, 1, 1: par(i, N, _ * ma.SR - 1); 
    M = 1, 1, 1, 1;
};


FDNBP = (netInsx : netNorm : netDels)~ (netAgnt : netGain : netLimt : netMtrx : netDCof)
with{
    N = 4;  
        netInsx = vecOp((si.bus(N) , si.bus(N)), +);
    D = 10, 10, 10, 10 : 
        par(i, N, _ * ma.SR - 1); 
        netDels = vecOp((si.bus(N), D), @);
        netNorm = par(i, N, RMSNorm(10, 10, .10, 0));
        netLimt = par(i, N, lookaheadLimiter(.8));
        agnt =  par(i, N, BPSVF(1, 200 + (i * 200)));
        netAgnt = si.bus(N) : agnt;
    G = 1/N, 1/N, 1/N, 1/N;
        netGain = vecOp((si.bus(N), G), *);
    M = 1, 1, 1, 1; 
        netMtrx = vecMx(N, M);
        netDCof = par(i, N, dcblocker);
};


FDNAP = (netInsx : netNorm : netDels)~ (netAgnt : netGain : netLimt : netMtrx : netDCof)
with{
    N = 4;  
        netInsx = vecOp((si.bus(N) , si.bus(N)), +);
    D = 10, 10, 10, 10 : 
        par(i, N, _ * ma.SR - 1); 
        netDels = vecOp((si.bus(N), D), @);
        netNorm = par(i, N, RMSNorm(10, 10, .10, 0));
        netLimt = par(i, N, lookaheadLimiter(.8));
        agnt =  par(i, N, 
                    apf(ms2samp(primeNumbers(8)), .25) : 
                        apf(ms2samp(primeNumbers(14)), .25) : 
                            apf(ms2samp(primeNumbers(22)), .25));
        netAgnt = si.bus(N) : agnt;
    G = 1/N, 1/N, 1/N, 1/N;
        netGain = vecOp((si.bus(N), G), *);
    M = 1, 1, 1, 1; 
        netMtrx = vecMx(N, M);
        netDCof = par(i, N, dcblocker);
};


FDNGN = (netInsx : netNorm : netDels)~ (netAgnt : netGain : netLimt : netMtrx : netDCof)
with{
    N = 4;  
        netInsx = vecOp((si.bus(N) , si.bus(N)), +);
    D = 10, 10, 10, 10 : 
        par(i, N, _ * ma.SR - 1); 
        netDels = vecOp((si.bus(N), D), @);
        netNorm = par(i, N, RMSNorm(10, 10, .10, 0));
        netLimt = par(i, N, lookaheadLimiter(.8));
        //(bufferMax, bufferSec, record, readPnt, strtPnt, Stretch, Jitter, grainDimMs, i, x)
        agnt =  timeStretcher(1, 1, 1, .30, .3, .10, .01, 80, 1),
                timeStretcher(1, 1, 1, .25, .4, .20, .01, 80, 2),
                timeStretcher(1, 1, 1, .50, .6, .15, .01, 80, 3),
                timeStretcher(1, 1, 1, .75, .8, .25, .01, 80, 4);
        netAgnt = si.bus(N) : (agnt);
    G = 1/N, 1/N, 1/N, 1/N;
        netGain = vecOp((si.bus(N), G), *);
    M = 1, 1, 1, 1; 
        netMtrx = vecMx(N, M);
        netDCof = par(i, N, dcblocker);
};