#include "colors.inc"
#include "textures.inc"
#include "shapes.inc"
#include "glass.inc"
#include "metals.inc"
#include "woods.inc"
#include "stones.inc"
#include "golds.inc"
#include "electric.inc"
#include "clock.inc"
#include "concrete.inc"
#include "camera.inc"
#include "lights.inc"
#include "scuffed.inc"

union {
	object {
		difference {
			Round_Box(<-1, 0, -0.75>, <1, 1.75, 0.75>, 0.05, true)
			Round_Box(<-0.9, 0.1, -0.9>, <0.9, 1.55, 0.75>, 0.05, true)
			#for (I,0,4)
				object {
					Round_Box(<-0.05, 0, -0.3>, <0.05, 0.5, 0.5>, 0.05, true)
					rotate <0,0,-30>
					translate <-0.4+(0.2*I),1.5,-0.1>
				}
			#end
		}
		Scuffed(0.2, 0.1, 0.1)
	}
	// panel
	object {
		Round_Box(<-0.9, 0.1, -0.7>, <0.9, 1.55, 0.7>, 0.05, true)
		texture { pigment { color rgb <0.8,0.8,0.8> } }
	}
	// knob outer
	object {
		Round_Cylinder(<0, 0, 0>, <0, 1, 0>, 0.4, 0.02, true)
		texture { pigment { color rgb <0.2,0.1,0.1> } }
		rotate <-90,0,0>
		translate <0.4,0.5,0.2>
	}
	// knob inner
	object {
		Round_Cylinder(<0, 0, 0>, <0, 1, 0>, 0.35, 0.02, true)
		texture { T_Chrome_5C }
		rotate <-90,0,0>
		translate <0.4,0.5,0.15>
	}
	// dial bar
	object {
		box {
			<-0.03,0,-0.05>, <0.03,0.3,0.05>
		}
		rotate <0,0,20>
		translate <0.4,0.5,-0.82>
		texture { pigment { color rgb <0.2,0.2,0.2> } }
	}
	// display
	object {
		Round_Box(<-0.35, 0, -0.3>, <0.35, 1.0, 0.3>, 0.03, true)
		material { M_Orange_Glass }
		translate <-0.45,0.3,-0.45>
	}

	// small knobs
	#for (I, 0, 2)
		object {
			Round_Cylinder(<0, 0, 0>, <0, 0.8, 0>, 0.1, 0.01, true)
			texture { pigment { color rgb <0.1,0.1,0.1> } }
			rotate <-90,0,0>
			translate <0.1+(I*0.3),1.25,0>
		}
	#end
	// aerial
	object {
		Round_Cylinder(<0, 0, 0>, <0, 1.1, 0>, 0.05, 0.02, true)
		texture { T_Chrome_5C }
		translate <-0.75,1.75,-0.5>
	}
	// aerial 2
	object {
		Round_Cylinder(<0, 0, 0>, <0, 2.2, 0>, 0.04, 0.01, true)
		texture { T_Chrome_5C }
		translate <-0.75,1.75,-0.5>
	}
	// aerial knob
	sphere {
		<-0.75,3.95,-0.5>, 0.1
		texture { T_Copper_5C }
	}
	// red connector
	sphere {
		<-0.5,1.75,0.65>, 0.15
		texture { pigment { color rgb <0.5,0,0> } }
	}
	// green connector
	sphere {
		<0.5,1.75,0.65>, 0.15
		texture { pigment { color rgb <0,0.5,0> } }
	}
}