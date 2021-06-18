$(BUILD)/done/libuuid/install: $(BUILD)/done/libuuid/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libuuid/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/libuuid/build: $(BUILD)/done/libuuid/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libuuid/build
	@touch $@

$(BUILD)/done/libuuid/configure: $(BUILD)/done/libuuid/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/libuuid/build; PATH="$(CROSS_PATH):$$PATH" autoreconf -fi)
	(cd $(BUILD)/libuuid/build; PATH="$(CROSS_PATH):$$PATH" ./configure --disable-all-programs --enable-libuuid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/install/lib")
	@touch $@

$(BUILD)/done/libuuid/copy: $(BUILD)/done/util-linux/checkout | $(BUILD)/done/libuuid/ $(BUILD)/libuuid/build/
	cp -a userspace/util-linux/util-linux/* $(BUILD)/libuuid/build/
	@touch $@

$(BUILD)/done/libblkid/install: $(BUILD)/done/libblkid/build
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libblkid/build DESTDIR=$(BUILD)/install install
	@touch $@

$(BUILD)/done/libblkid/build: $(BUILD)/done/libblkid/configure
	PATH="$(CROSS_PATH):$$PATH" $(MAKE) -C $(BUILD)/libblkid/build
	@touch $@

$(BUILD)/done/libblkid/configure: $(BUILD)/done/libblkid/copy $(BUILD)/done/glibc/glibc/install $(BUILD)/done/gcc/gcc/install
	(cd $(BUILD)/libblkid/build; PATH="$(CROSS_PATH):$$PATH" autoreconf -fi)
	(cd $(BUILD)/libblkid/build; PATH="$(CROSS_PATH):$$PATH" ./configure --disable-all-programs --enable-libblkid --host=aarch64-linux-gnu --target=aarch64-linux-gnu --prefix=/ CFLAGS="$(CROSS_CFLAGS)" LDFLAGS="-L$(BUILD)/install/lib")
	@touch $@

$(BUILD)/done/libblkid/copy: $(BUILD)/done/util-linux/checkout | $(BUILD)/done/libblkid/ $(BUILD)/libblkid/build/
	cp -a userspace/util-linux/util-linux/* $(BUILD)/libblkid/build/
	@touch $@

$(BUILD)/done/util-linux/checkout: userspace/util-linux/util-linux{checkout} | $(BUILD)/done/util-linux/
	@touch $@
