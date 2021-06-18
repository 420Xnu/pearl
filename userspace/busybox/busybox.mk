$(BUILD)/busybox/done/menuconfig: $(BUILD)/busybox/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build menuconfig
	$(CP) $(BUILD)/busybox/build/.config userspace/busybox/busybox.config

$(BUILD)/busybox/done/install: $(BUILD)/busybox/done/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" install
	@touch $@

$(BUILD)/busybox/done/build: $(BUILD)/busybox/done/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)"
	@touch $@

$(BUILD)/busybox/done/configure: userspace/busybox/busybox.config $(BUILD)/busybox/done/copy
	$(CP) $< $(BUILD)/busybox/build/.config
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/busybox/build CROSS_COMPILE=aarch64-linux-gnu- CFLAGS="$(CROSS_CFLAGS)" oldconfig
	@touch $@

$(BUILD)/busybox/done/copy: $(BUILD)/busybox/done/checkout | $(BUILD)/busybox/done/ $(BUILD)/busybox/build/
	$(CP) -a userspace/busybox/busybox/* $(BUILD)/busybox/build/
	@touch $@

$(BUILD)/busybox/done/checkout: userspace/busybox/busybox{checkout} | $(BUILD)/busybox/done/
	@touch $@
