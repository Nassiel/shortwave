#macro Scuffed(R,G,B)
	texture {
		pigment {
			spherical
			turbulence <1, 1, 1>
			omega 1
			lambda 6

			color_map {
				[ 0.1 color rgb <R, G, B> ]
			}
		}
		normal {
			boxed
			30
			turbulence <1, 1, 1>
			omega 1
			lambda 6
			frequency 15
		}
	}
#end
