$(BUILD)/host/sendfile/send-sendfile: local/sendfile/send-sendfile
	$(MKDIR) $(dir $@)
	$(CP) $< $@

$(BUILD)/pearl/bin/receive-sendfile: local/sendfile/receive-sendfile.c $(BUILD)/gcc/done/gcc/install $(BUILD)/glibc/done/glibc/install
	$(MKDIR) $(dir $@)
	$(WITH_CROSS_PATH) $(CROSS_COMPILE)gcc -static -Os -o $@ $<

%.image.sendfile: %.image %.image.d/sendfile
	$(MKDIR) $@.d
	$(CP) $< $@.d
	$(CP) -a $*.image.d/sendfile $@.d/script
	tar -C $@.d -c . | gzip -1 > $@

%.macho.sendfile: %.macho
	$(MKDIR) $@.d
	$(CP) $< $@.d
	(echo "#!/bin/sh"; echo "macho-to-memdump $$(basename $*.macho)"; echo "kexec --mem-min=0x900000000 -fix image") > $@.d/script
	chmod u+x $@.d/script
	tar -C $@.d -c . | gzip -1 > $@

%.sendfile{send}: %.sendfile
	$(SUDO) local/sendfile/send-sendfile $<

$(call pearl-static,$(BUILD)/pearl/bin/receive-sendfile,$(BUILD)/pearl)
