$(BUILD)/done/dtc/install: $(BUILD)/done/dtc/build
	$(MAKE) CC=aarch64-linux-gnu-gcc PREFIX="$(BUILD)/install" CFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/dtc/build install
	@touch $@

$(BUILD)/done/dtc/build: $(BUILD)/done/dtc/configure
	$(MAKE) PKG_CONFIG=/bin/false CC=aarch64-linux-gnu-gcc CFLAGS="$(CROSS_CFLAGS)" PREFIX="$(BUILD)/install" LDFLAGS="$(CROSS_CFLAGS)" -C $(BUILD)/dtc/build
	@touch $@

$(BUILD)/done/dtc/configure: $(BUILD)/done/dtc/copy
	@touch $@

$(BUILD)/done/dtc/copy: | $(BUILD)/done/dtc/ $(BUILD)/dtc/build/
	cp -a userspace/dtc/dtc/* $(BUILD)/dtc/build/
	@touch $@


DTC ?= dtc

build/%.dtb.h: build/%.dtb
	(echo "{";  cat $< | od -tx4 --width=4 -Anone -v | sed -e 's/ \(.*\)/\t0x\1,/'; echo "};") > $@

build/%.dts.h: build/%.dts dtc/dtc-relocs
	$(CC) -E -x assembler-with-cpp -nostdinc $< | dtc/dtc-relocs > $@

build/%.dts.dtb: build/%.dts
	$(DTC) -Idts -Odtb $< > $@.tmp && mv $@.tmp $@

build/%.dtb.dts: build/%.dtb
	$(DTC) -Idtb -Odts $< > $@.tmp && mv $@.tmp $@