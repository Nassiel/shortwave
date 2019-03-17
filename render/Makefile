
define slavepasses
	ssh $(SLAVE) 'rm -rf render/*; mkdir -p render'
	bash -c "scp passes.sh ./*.{pov,inc} $(SLAVE):render/"
	ssh $(SLAVE) 'PATH=$$HOME/bin:$$PATH; cd render; ./passes.sh $(1) $(2)' 2>>$(1).log
	bash -c "scp -r $(SLAVE):render/$(1)*png ./"
endef

define slavepreview
	ssh $(SLAVE) 'mkdir -p render'
	bash -c "scp ./*.{pov,inc} $(SLAVE):render/"
	ssh $(SLAVE) 'PATH=$$HOME/bin:$$PATH; cd render; povray -D0 +A0.0 +AM2 +J -H512 -W512 +K0 DECLARE=Pass=1 +Fn +Opreview.png -I$(1).pov' 2>>$(1).log
	bash -c "scp -r $(SLAVE):render/preview.png ./"
endef

all:
	$(call slavepasses,radio)
	./merge.sh radio
	cp radio-icon.png ../
	cp radio-hr.png ../
	cp radio-lr.png ../
	cp radio-thumb.png ../thumbnail.png
	cp radio-tech.png ../tech.png

preview:
	$(call slavepreview,radio)
	eog preview.png