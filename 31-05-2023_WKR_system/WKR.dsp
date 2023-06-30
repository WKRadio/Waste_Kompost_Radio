// Import the WKR Library
import("LIB.lib");
FDN =   component("FDN.dsp").FDN;
FDNBP = component("FDN.dsp").FDNBP;
FDNAP = component("FDN.dsp").FDNAP;
FDNGN = component("FDN.dsp").FDNGN;

//process = (_ * 1, _ * 0, _ * 0, _ * 0) : FDN :> _/4 <: _, _;
//process = (_ * 1, _ * 0, _ * 0, _ * 0) : FDNBP :> _/4 <: _, _; 
//process = (_ * 1, _ * 0, _ * 0, _ * 0) : FDNAP :> _/4 <: _, _; 
process = (_ * 1, _ * 0, _ * 0, _ * 0) : FDNGN :> _/4 <: _, _; 