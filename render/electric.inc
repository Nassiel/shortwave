// ELECTRICITY INCLUDE FILE for POV-Ray 3.1
// ****************************************
// Copyright 2001 Rune S. Johansen

    //#version unofficial MegaPov 1.1;

// The output is a point that moves from PointA to PointB
// as Value goes from 0.0 to 1.0
#macro LinearPath (PointA,PointB,Value)
  (PointA*(1-Value)+PointB*Value)
#end

// The output is a color vector that changes from ColorA to Color B
// as Value goes from 0.0 to 1.0
#macro LinearColor (ColorA,ColorB,Value)
  (
    vnormalize( ColorA*(1-Value) + ColorB*Value )
    *( vlength(ColorA)*(1-Value) + vlength(ColorB)*Value )
  )
#end

// This macro is used internally only.
// The user do not need to call this macro.
#macro _Electric(ValueA,ValueB,PointA,PointB,Level,Offset)
   #local ValueM = (ValueA+ValueB)/2;
   #local FlickerClock = int((clock*FlickerSpeed+vturbulence(0,0,0,Offset+FlickerSpeed*z*clock).y));
   #local Turbulence = vturbulence(0,0,0,Offset-<100*FlickerClock,RollSpeed*clock,0>);
   #local PointM = (
      (PointA+PointB)/2+(ElectricPath(ValueM))-((ElectricPath(ValueA))+(ElectricPath(ValueB)))/2
      +Turbulence*vlength(PointA-PointB)*Fuzzyness
   );
   //glow is obsolete in recent versions (3.6+). Replaced by the following code (Reactor, April 2010 in povray.newusers):
   //glow {location PointM type 0 color ElectricColor(ValueM)*Brightness #if(Thickness>0) radius Thickness #end}
   //start new code:
   sphere {
     <0,0,0>, 1
     pigment { color rgbt 1 }
     interior {
       #local M_samples = 15;
       #local M_variance = 1/500;
       media {
         //intervals 1  //default
         samples M_samples
         //confidence 1 - M_variance  //obsolete
         //variance m_variance  //obsolete
         emission color rgb 1
         //method 3 //default
         //aa_threshold 0.1 //default
         //aa_level 4 //default
         //jitter 0.5
         density {
           spherical
           poly_wave 1.5
           color_map{
             [0.00 color rgb 0 ]
             //[0.80 color rgb ElectricColor(ValueM)*Brightness*2 ]
             //[0.90 color rgb <1,1,1>*Brightness*75  ]
             //[1.00 color rgb <1,1,1>*Brightness*200 ]
             //or this? (Alain)
             [0.80 color rgb ElectricColor(ValueM)*Brightness/Thickness ]
             [0.90 color rgb <1,1,1>*Brightness/Thickness  ]
             [1.00 color rgb <1,1,1>*Brightness/Thickness ]
           }
         }
       }
     }
     hollow
     #if(Thickness>0) scale Thickness  #else scale 0.50 #end
     translate PointM
   }
   //end new code
   #if (vlength(PointA-PointM)>MinDist) _Electric(ValueA,ValueM,PointA,PointM,Level+1,Offset+pow(3,Level)*x) #end
   #if (vlength(PointB-PointM)>MinDist) _Electric(ValueB,ValueM,PointB,PointM,Level+1,Offset+pow(3,Level)*y) #end
#end


// This is the Electric macro. It calls the internal _Electric macro
// specified further down.
#macro
Electric(Brightness,Thickness,Fuzzyness,RollSpeed,FlickerSpeed,MinDist)
_Electric(0,1,ElectricPath(0),ElectricPath(1),1,-((ElectricPath(0))+(ElectricPath(1)))*100)
#end

