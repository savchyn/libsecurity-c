DEPS?=../../deps

include ../build/common.mk

SOURCES=parserCommon.c fastUser.c fastOtp.c fastOtpUser.c fastAccounts.c fastAcl.c fastStorage.c fastPassword.c
 																	 
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=test_of_sec-c
OTHER=

all: $(SOURCES) $(EXECUTABLE) $(OTHER)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(RANDOM_BYTES) -o $@ $(LIB) -laccounts -lacl -lpassword -lentity -lsalt -lstorage -lotp -lm -lmyhash -lutils -L../../bin $(LIB_SEC) $(MBEDTLS_LIB)

.c.o:
	$(CC) $(TARGET) $(CRYPTO_TYPE) -I../include $(CFLAGS) $(STATIC_F) $(INC) $< -o $@

clean:
	rm -rf *.o
	
.PHONY: clean
