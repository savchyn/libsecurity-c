LIBSECURITY_DIR?=./libsecurity
export LIBSECURITY_DIR
export OS
export CRYPTO
export MODE

VARIANT=bin/$(OS)/$(CRYPTO)
LIBDIR=../../../$(VARIANT)
export LIBDIR

test: tests examples

all: sec-c

deps:
	$(MAKE) -C deps download_deps build_deps

sec-c:
	mkdir -p $(VARIANT)
	$(MAKE) -C $(LIBSECURITY_DIR)/src/accounts
	$(MAKE) -C $(LIBSECURITY_DIR)/src/acl
	$(MAKE) -C $(LIBSECURITY_DIR)/src/entity
	$(MAKE) -C $(LIBSECURITY_DIR)/src/password
	$(MAKE) -C $(LIBSECURITY_DIR)/src/otp
	$(MAKE) -C $(LIBSECURITY_DIR)/src/salt
	$(MAKE) -C $(LIBSECURITY_DIR)/src/utils
	$(MAKE) -C $(LIBSECURITY_DIR)/src/storage

tests:
	$(MAKE) -C $(LIBSECURITY_DIR)/testing

examples:
	$(MAKE) -C $(LIBSECURITY_DIR)/examples

depsclean:
	$(MAKE) -C deps clean

clean:
	rm -Rf $(VARIANT)
	$(MAKE) clean -C $(LIBSECURITY_DIR)/src/accounts
	$(MAKE) clean -C $(LIBSECURITY_DIR)/src/acl clean
	$(MAKE) clean -C $(LIBSECURITY_DIR)/src/entity clean
	$(MAKE) clean -C $(LIBSECURITY_DIR)/src/password clean
	$(MAKE) -C $(LIBSECURITY_DIR)/src/otp clean
	$(MAKE) -C $(LIBSECURITY_DIR)/src/salt clean
	$(MAKE) -C $(LIBSECURITY_DIR)/src/utils clean
	$(MAKE) -C $(LIBSECURITY_DIR)/src/storage clean
	$(MAKE) -C $(LIBSECURITY_DIR)/testing clean
	$(MAKE) -C $(LIBSECURITY_DIR)/examples clean
	
.PHONY: all clean depclean deps libsecurity-c
