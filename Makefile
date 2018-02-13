CEXT := c
CPPEXT := cpp
PREFIX := /usr/local

CC := gcc
CXX := g++
LIBS := -pthread -Llib
INCLUDES := -Iinclude
CFLAGS := -std=c11 -O2 -Wall -fPIC
CXXFLAGS := -std=c++11 -O2 -Wall -fPIC
LDFLAGS := -shared

SRCDIR := src
INCDIR := include
TESTDIR := test
BUILDDIR := build
BINDIR := bin
TESTBINDIR := testbin
LIBDIR := lib

LIB_NAME := $(LIBDIR)/libcbox
LIB_STATIC_NAME := $(LIB_NAME).a
LIB_DINAMIC_NAME := $(LIB_NAME).so

C_TARGET_SRCS := $(shell find $(SRCDIR) -type f -name "*_run.$(CEXT)")
CPP_TARGET_SRCS := $(shell find $(SRCDIR) -type f -name "*_run.$(CPPEXT)")
C_SRCS := $(shell find $(SRCDIR) -type f -name *.$(CEXT) -a -not -name "*_run.$(CEXT)")
CPP_SRCS := $(shell find $(SRCDIR) -type f -name *.$(CPPEXT) -a -not -name "*_run.$(CPPEXT)")
C_TARGET_OBJS := $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(C_TARGET_SRCS:.$(CEXT)=.o))
CPP_TARGET_OBJS := $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(CPP_TARGET_SRCS:.$(CPPEXT)=.o))
C_OBJS := $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(C_SRCS:.$(CEXT)=.o))
CPP_OBJS := $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(CPP_SRCS:.$(CPPEXT)=.o))
C_TARGETS := $(addprefix $(BINDIR)/,$(notdir $(C_TARGET_OBJS:.o=)))
CPP_TARGETS := $(addprefix $(BINDIR)/,$(notdir $(CPP_TARGET_OBJS:.o=)))

INSTALLED_BINS := $(addprefix $(PREFIX)/,$(C_TARGETS) $(CPP_TARGETS))
INSTALLED_INCS := $(addprefix $(PREFIX)/,$(shell find $(INCDIR) -type f -name *.h -o -name *.hpp))
INSTALLED_TOP_INCS := $(addprefix $(PREFIX)/,$(shell find $(INCDIR) -mindepth 1 -maxdepth 1))
INSTALLED_LIBS := $(addprefix $(PREFIX)/,$(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME))

C_TEST_SRCS := $(shell find $(TESTDIR) -type f -name *.$(CEXT))
CPP_TEST_SRCS := $(shell find $(TESTDIR) -type f -name *.$(CPPEXT))
C_TEST_OBJS := $(patsubst $(TESTDIR)%,$(BUILDDIR)%,$(C_TEST_SRCS:.$(CEXT)=.o))
CPP_TEST_OBJS := $(patsubst $(TESTDIR)%,$(BUILDDIR)%,$(CPP_TEST_SRCS:.$(CPPEXT)=.o))
C_TEST_TARGETS := $(addprefix $(TESTBINDIR)/,$(notdir $(C_TEST_OBJS:.o=)))
CPP_TEST_TARGETS := $(addprefix $(TESTBINDIR)/,$(notdir $(CPP_TEST_OBJS:.o=)))


.PHONY: all build test install clean uninstall

all: build

build: $(C_TARGETS) $(CPP_TARGETS) $(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME)

$(C_TARGETS): $(C_OBJS) $(C_TARGET_OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) $(LIBS) -o $@ $(C_OBJS) $(filter %$(notdir $@).o,$(C_TARGET_OBJS))

$(CPP_TARGETS): $(CPP_OBJS) $(CPP_TARGET_OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -o $@ $(CPP_OBJS) $(filter %$(notdir $@).o,$(CPP_TARGET_OBJS))

$(C_TARGET_OBJS): $(C_TARGET_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.$(CEXT)))

$(CPP_TARGET_OBJS): $(CPP_TARGET_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.$(CPPEXT)))

$(C_OBJS): $(C_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.$(CEXT)))

$(CPP_OBJS): $(CPP_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.$(CPPEXT)))

$(LIB_STATIC_NAME): $(C_OBJS) $(CPP_OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(LIB_DINAMIC_NAME): $(C_OBJS) $(CPP_OBJS)
	$(CXX) $(LIBS) $(LDFLAGS) -o $@ $^


install: $(INSTALLED_BINS) $(INSTALLED_INCS) $(INSTALLED_LIBS)

$(INSTALLED_BINS): $(C_TARGETS) $(CPP_TARGETS)
	install -D $(subst $(PREFIX)/,,$@) $@

$(INSTALLED_INCS): $(subst $(PREFIX)/,,$(INSTALLED_INCS))
	install -D $(subst $(PREFIX)/,,$@) $@

$(INSTALLED_LIBS): $(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME)
	install -D $(subst $(PREFIX)/,,$@) $@


uninstall:
	rm -rf $(INSTALLED_BINS) $(INSTALLED_TOP_INCS) $(INSTALLED_LIBS)


clean:
	$(RM) -rf $(BUILDDIR) $(C_TARGETS) $(CPP_TARGETS) \
		$(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME) $(C_TEST_TARGETS) $(CPP_TEST_TARGETS) \
		$(C_TARGET_OBJS) $(CPP_TARGET_OBJS) $(C_OBJS) $(CPP_OBJS) $(C_TEST_OBJS) $(CPP_TEST_OBJS)


test: $(C_TEST_TARGETS) $(CPP_TEST_TARGETS)

$(C_TEST_TARGETS): $(C_OBJS) $(C_TEST_OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) $(LIBS) -o $@ $(C_OBJS) $(filter %$(notdir $@).o,$(C_TEST_OBJS))

$(CPP_TEST_TARGETS): $(CPP_OBJS) $(CPP_TEST_OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -o $@ $(CPP_OBJS) $(filter %$(notdir $@).o,$(CPP_TEST_OBJS))

$(C_TEST_OBJS): $(C_TEST_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(TESTDIR)%,$(@:.o=.$(CEXT)))

$(CPP_TEST_OBJS): $(CPP_TEST_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(TESTDIR)%,$(@:.o=.$(CPPEXT)))

