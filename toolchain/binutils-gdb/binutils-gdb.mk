$(BUILD)/binutils-gdb/done/install: $(BUILD)/binutils-gdb/done/build
	$(MAKE) -C $(BUILD)/binutils-gdb/source install
	@touch $@

$(BUILD)/binutils-gdb/done/build: $(BUILD)/binutils-gdb/done/configure
	$(MAKE) -C $(BUILD)/binutils-gdb/source
	@touch $@

$(BUILD)/binutils-gdb/done/configure: $(BUILD)/binutils-gdb/done/copy
	(cd $(BUILD)/binutils-gdb/source/; ../source/configure --target=aarch64-linux-gnu --prefix=$(BUILD)/toolchain)
	@touch $@

$(BUILD)/binutils-gdb/done/copy: $(BUILD)/binutils-gdb/done/checkout | $(BUILD)/binutils-gdb/source/ $(BUILD)/binutils-gdb/done/
	$(CP) -a toolchain/binutils-gdb/binutils-gdb/* $(BUILD)/binutils-gdb/source/
	@touch $@

$(BUILD)/binutils-gdb/done/checkout: toolchain/binutils-gdb/binutils-gdb{checkout} | $(BUILD)/binutils-gdb/done/
	@touch $@
