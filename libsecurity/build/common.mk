AR=ar rcs
DEPS?=../../../deps
MAKE_HOST?=t

OS?="LINUX" #[LINUX MBED]
TARGET=-D$(OS)_OS

ifneq ($(CRYPTO), NaCl)
ifneq ($(CRYPTO), MBEDTLS)
ifneq ($(CRYPTO), OPENSSL)
$(error Error! CRYPTO=[$(CRYPTO)] must be set to one of {NaCl OPENSSL MBEDTLS})
endif
endif
endif

$(message CRYPTO=[$(CRYPTO)] must be set to one of {NaCl OPENSSL MBEDTLS})

CRYPTO?=NaCl #[NaCl OPENSSL MBEDTLS]
export CRYPTO
CRYPTO_TYPE=-D$(CRYPTO)_CRYPTO

OUTDIR=$(LIBDIR)

GCC_C="GCC_C"
GCC_O="GCC_O"
CLANG="CLANG"

COMPILER="clang"
# the default is export COMPILER="GCC_C"

DEBUG?=NDEBUG
#export PURE=1

CFLAGS_COMMON = $(TARGET) $(CRYPTO_TYPE) -D$(DEBUG) \
    -Wall -Wextra\
    -Wmissing-declarations -Wpointer-arith \
    -Wwrite-strings -Wcast-qual -Wcast-align \
	-Wformat-security \
    -Wmissing-format-attribute \
    -Winline -W -funsigned-char \
    -Wstrict-overflow -fno-strict-aliasing \
    -Wno-missing-field-initializers

ifeq ($(COMPILER),GCC_O)
	CC=gcc
	CFLAGS = -c -std=c99 -O3
	CPPFLAGS = -c -std=c++11 -Os -D _POSIX_C_SOURCE=200809L -fno-exceptions -fno-rtti
else ifeq ($(COMPILER),CLANG)
	CC=clang
	CFLAGS = -fsanitize=address -fno-omit-frame-pointer -c -g -std=c99
	CPPFLAGS = -fsanitize=address -fno-omit-frame-pointer -c -g
	LDFLAGS=-fsanitize=address
else # GCC_C
    export COMPILER="GCC_C"
	CC=gcc
	CFLAGS = -c -std=c99 -g $(COVFLAGS)
	CPPFLAGS = -c -std=c++11 -g -D _POSIX_C_SOURCE=200809L -fno-exceptions -fno-rtti
	CFLAGS-C = -Wmissing-prototypes -Wstrict-prototypes -Wbad-function-cast
endif

ifdef AFL
	CC=/usr/local/bin/afl-gcc
endif

ifdef COV
	COVFLAGS = -fprofile-arcs -ftest-coverage -fPIC -O0 
	LDFLAGS=-lgcov --coverage
endif

DEPS_PATH=$(DEPS)
HASH=$(DEPS_PATH)

MBEDTLS_INC_DIR=$(DEPS_PATH)/crypto/mbedtls/include
MBEDTLS_LIB_DIR=$(DEPS_PATH)/crypto/mbedtls/library
MBEDTLS_CONFIG_INC=$(MBEDTLS_INC_DIR)/mbedtls/config.h
MBEDTLS_BASE_LIB=-lmbedtls -lmbedx509 -lmbedcrypto

OPENSSL_INC_DIR=$(DEPS_PATH)/crypto/openssl-1.0.2g/include
OPENSSL_LIB_DIR=$(DEPS_PATH)/crypto/openssl
OPENSSL_LIB=-lssl -lcrypto -ldl

INCLUDE_PATH=../../include/libsecurity

INC_BASE= -I. -I$(INCLUDE_PATH) -I$(INCLUDE_PATH)/.. -I$(HASH) -I$(LIBSECURITY_DIR)/src/include
LIB_BASE= -L$(HASH)/hashtab -L$(LIBDIR)

INC_OS=-I../../../../sockets -I../../../../minar -I../../../../mbed-os -I../../../../mbed-os/platform -I../../../../mbed-os/hal -I../../../../mbed-os/features -I../../../../mbed-os/rtos/TARGET_CORTEX -I../../../../mbed-os/rtos/TARGET_CORTEX/rtx5/RTX/Source -I../../../../mbed-os/cmsis  -I../../../../mbed-os/cmsis/TARGET_CORTEX_M

#-I../../../../mbed-os/targets/TARGET_STM/TARGET_STM32F4/device

ifeq ($(CRYPTO),MBEDTLS)
	INC_ADD=-I$(MBEDTLS_INC_DIR)
	LIB=-L$(MBEDTLS_LIB_DIR) $(LIB_BASE)
	MBEDTLS_LIB=$(MBEDTLS_BASE_LIB)
endif

ifeq ($(CRYPTO),OPENSSL)
	INC_ADD = -I$(OPENSSL_INC_DIR) -I$(MBEDTLS_INC_DIR)
	LIB=-L /usr/local/ssl/lib/ -L$(OPENSSL_LIB_DIR) $(LIB_BASE)
	LIB_SEC=$(OPENSSL_LIB)
endif

ifeq ($(CRYPTO),NaCl)
	CRYPTO_DIR=$(DEPS_PATH)/crypto/nacl-20110221/build/$(MAKE_HOST)
	NACL_CPU_TYPE=x86 #or amd64
	RANDOM_BYTES=$(CRYPTO_DIR)/lib/$(NACL_CPU_TYPE)/randombytes.o
	CRYPTO_PATH=$(CRYPTO_DIR)/include/$(NACL_CPU_TYPE)
	CRYPTO_LIB=$(CRYPTO_DIR)/lib/$(NACL_CPU_TYPE)
	LIB_SEC=-lnacl
	INC_ADD=-I$(MBEDTLS_INC_DIR) -I$(CRYPTO_PATH)
	LIB=$(LIB_BASE) -L$(MBEDTLS_LIB_DIR) -L$(CRYPTO_LIB)
	MBEDTLS_LIB=$(MBEDTLS_BASE_LIB)
endif


INC=$(INC_BASE) $(INC_ADD) $(INC_OS)
