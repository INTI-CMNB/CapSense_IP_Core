PRJ=kefir_capsense
TOP=Kefir_Capsense
PNR_OPS=-d 8k -P tq144:4k

all: $(PRJ).bin

synth.blif: kefir_capsense.v capsense_sys.v capsense.v
	yosys -v3 -l synth.log -p 'synth_ice40 -top $(TOP) -blif $@; write_verilog -attr2comment synth.v' $(filter %.v, $^)

$(PRJ).asc: synth.blif
	arachne-pnr $(PNR_OPS) -o $(PRJ).asc -p $(PRJ).in.pcf synth.blif

$(PRJ).bin: $(PRJ).asc
	icepack $(PRJ).asc $(PRJ).bin

transfer-rom:
	iceprog -I B $(PRJ).bin

transfer:
	iceprog -S -I B $(PRJ).bin

clean:
	rm -f synth.log synth.v synth.blif $(PRJ).asc $(PRJ).bin

.PHONY: all transfer clean

