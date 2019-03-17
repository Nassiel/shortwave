light_source {
	<-50, 150, 0> color White
	area_light <0, 10, 0>, <0, 0, 10>, 5, 5
	adaptive 1
	jitter
}

//light_source {
//	<-5, 10, 0> color White
//	parallel
//	point_at <0,1.5,0>
//}

light_source {
	<0, 0, -1.5> color rgb <0.1,0.1,0.1>
	parallel
	point_at <0,0,0>
	shadowless
}

#ifndef (Pass)
	#declare Pass=1;
#end

plane {
	y, 0
	texture {
		pigment {
			#switch (Pass)
				#case (1)
					color rgb <1,1,1>
				#break
				#case (2)
					color rgb <0,0,0>
				#break
			#end
		}
	}
	finish {
		diffuse 1.0
	}
	no_reflection
}
