// Import the WKR Library
import("compost_library.lib");


// N = voices, M = network inputs.
FDNBP(N, M) = (netInsx : netNorm : netDCof : netLimt) ~ (agnt : hadamard)
with{
    hadamardnorm = 1.0 / sqrt(N); // norm for hadamard
    hadamardcoeff = par(i, N, hadamardnorm); // norm par
    hadamard = vecOp((ro.hadamard(N) , hadamardcoeff), *);
    netInsx = vecOp((si.bus(N) , si.bus(N)), +); // ins + fbs
    netNorm = par(i, N, RMSNorm(10, 10, .1, 10)); // norm + del
    netLimt = par(i, N, lookaheadLimiter(.8)); // signal limit
    agnt =  par(i, N, BPSVF(1, 200 + (i * 200))); // agents
    netDCof = par(i, N, dcblocker); // dc blockers
};
//process = si.bus(2) <: si.bus(4) : FDNBP(4, 3);
FDNB2(N, M) = (netInsx : netNorm : vDelays : netDCof : netLimt) ~ (agnt : hadamard)
with{
    hadamardnorm = 1.0 / sqrt(N); // norm for hadamard
    hadamardcoeff = par(i, N, hadamardnorm); // norm par
    hadamard = vecOp((ro.hadamard(N) , hadamardcoeff), *);
    netInsx = vecOp((si.bus(N) , si.bus(N)), +); // ins + fbs
    netNorm = par(i, N, RMSNorm(10, 10, .1, 10)); // norm + del
    vDelays = par(i, N, d(i)) // del
    with{
        d(i) =  de.fdelay(192000 * 10, 
                    si.smoo(hslider("V Del %i", i, 0, 10, .001) * 
                        ma.SR));
    };
    netLimt = par(i, N, lookaheadLimiter(.8)); // signal limit
    agnt =  par(i, N, BPSVF(1, f(i))) // agents
    with{
        f(i) = si.smoo(hslider("BP F %i", (i+1) * 200, 20, 10000, 1));
    };
    netDCof = par(i, N, dcblocker); // dc blockers
};
//process = si.bus(2) <: si.bus(4) : FDNB2(4, 3);
FDNAP(N, M) = (netInsx : netNorm : netDCof : netLimt) ~ (agnt : hadamard)
with{
    hadamardnorm = 1.0 / sqrt(N); // norm for hadamard
    hadamardcoeff = par(i, N, hadamardnorm); // norm par
    hadamard = vecOp((ro.hadamard(N) , hadamardcoeff), *);
    netInsx = vecOp((si.bus(N) , si.bus(N)), +); // ins + fbs
    netNorm = par(i, N, RMSNorm(10, 10, .1, 10)); // norm + del
    netLimt = par(i, N, lookaheadLimiter(.8)); // signal limit
    agnt =  apfLattice(N, 10, 10, 400, 5, .5); // agents
    netDCof = par(i, N, dcblocker); // dc blockers
};
//process = si.bus(2) <: si.bus(4) : FDNAP(4, 3); 
FDNGN(N, M) = (netInsx : netNorm : netDCof : netLimt) ~ (agnt : hadamard)
with{
    hadamardnorm = 1.0 / sqrt(N); // norm for hadamard
    hadamardcoeff = par(i, N, hadamardnorm); // norm par
    hadamard = vecOp((ro.hadamard(N) , hadamardcoeff), *);
    netInsx = vecOp((si.bus(N) , si.bus(N)), +); // ins + fbs
    netNorm = par(i, N, RMSNorm(10, 10, .1, 10)); // norm + del
    netLimt = par(i, N, lookaheadLimiter(.8)); // signal limit
    agnt =  par(i, N, 
        timeStretcher(30, 30, 1, 1, 1, 0, .5, 10000, (i+1))); // agents
    netDCof = par(i, N, dcblocker); // dc blockers
};
//process = si.bus(2) <: si.bus(4) : FDNGN(4, 3); 
FDNG2(N, M) = (netInsx : netNorm : netDCof : netLimt) ~ (agnt : hadamard)
with{
    hadamardnorm = 1.0 / sqrt(N); // norm for hadamard
    hadamardcoeff = par(i, N, hadamardnorm); // norm par
    hadamard = vecOp((ro.hadamard(N) , hadamardcoeff), *);
    netInsx = vecOp((si.bus(N) , si.bus(N)), +); // ins + fbs
    netNorm = par(i, N, RMSNorm(10, 10, .1, 10)); // norm + del
    netLimt = par(i, N, lookaheadLimiter(.8)); // signal limit
    agnt =  par(i, N, hgroup("Granulators", 
                    granular_sampling((i+1), 10, 2))); // agents
    netDCof = par(i, N, dcblocker); // dc blockers
};
//process = si.bus(2) <: si.bus(4) : FDNGN2(4, 3); 