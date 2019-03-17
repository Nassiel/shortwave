#declare Concrete = texture {
	pigment {
		spherical
		turbulence <1, 1, 1>
		omega 1
		lambda 6

		color_map {
			[ 0.1 color rgb <0.478431, 0.513725, 0.462745> ]
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

	finish {
		ambient rgb <0, 0, 0>
		diffuse 0.3
		specular 0.6
		conserve_energy

		reflection {
			rgb <0.1, 0.1, 0.1>
			metallic 1
		}
	}
	scale 1
}