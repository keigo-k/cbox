SRCDIR = src
INCDIR = include
TESTDIR = test
BUILDDIR = build
BINDIR = bin
TESTBINDIR = testbin
LIBDIR = lib

LIB_NAME = $(LIBDIR)/libcbox
LIB_STATIC_NAME = $(LIB_NAME).a
LIB_DINAMIC_NAME = $(LIB_NAME).so

C_TARGET_SRCS = $(shell find $(SRCDIR) -type f -name "*_run.c")
CPP_TARGET_SRCS = $(shell find $(SRCDIR) -type f -name "*_run.cpp")
C_SRCS = $(shell find $(SRCDIR) -type f -name *.c -a -not -name "*_run.c")
CPP_SRCS = $(shell find $(SRCDIR) -type f -name *.cpp -a -not -name "*_run.cpp")
C_TARGET_OBJS = $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(C_TARGET_SRCS:.c=.o))
CPP_TARGET_OBJS = $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(CPP_TARGET_SRCS:.cpp=.o))
C_OBJS = $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(C_SRCS:.c=.o))
CPP_OBJS = $(patsubst $(SRCDIR)%,$(BUILDDIR)%,$(CPP_SRCS:.cpp=.o))
C_TARGETS = $(addprefix $(BINDIR)/,$(notdir $(C_TARGET_OBJS:.o=)))
CPP_TARGETS = $(addprefix $(BINDIR)/,$(notdir $(CPP_TARGET_OBJS:.o=)))

INSTALLED_BINS = $(addprefix $(exec_prefix)/,$(C_TARGETS) $(CPP_TARGETS))
INSTALLED_INCS = $(addprefix $(prefix)/,$(shell find $(INCDIR) -type f -name *.h -o -name *.hpp))
INSTALLED_TOP_INCS = $(addprefix $(prefix)/,$(shell find $(INCDIR) -mindepth 1 -maxdepth 1))
INSTALLED_LIBS = $(addprefix $(prefix)/,$(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME))

C_TEST_SRCS = $(shell find $(TESTDIR) -type f -name *.c)
CPP_TEST_SRCS = $(shell find $(TESTDIR) -type f -name *.cpp)
C_TEST_OBJS = $(patsubst $(TESTDIR)%,$(BUILDDIR)%,$(C_TEST_SRCS:.c=.o))
CPP_TEST_OBJS = $(patsubst $(TESTDIR)%,$(BUILDDIR)%,$(CPP_TEST_SRCS:.cpp=.o))
C_TEST_TARGETS = $(addprefix $(TESTBINDIR)/,$(notdir $(C_TEST_OBJS:.o=)))
CPP_TEST_TARGETS = $(addprefix $(TESTBINDIR)/,$(notdir $(CPP_TEST_OBJS:.o=)))


all: $(C_TARGETS) $(CPP_TARGETS) $(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME)

$(C_TARGETS): $(C_OBJS) $(C_TARGET_OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $@ $(C_OBJS) $(filter %$(notdir $@).o,$(C_TARGET_OBJS))

$(CPP_TARGETS): $(CPP_OBJS) $(CPP_TARGET_OBJS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LIBS) -o $@ $(CPP_OBJS) $(filter %$(notdir $@).o,$(CPP_TARGET_OBJS))

$(C_TARGET_OBJS): $(C_TARGET_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.c))

$(CPP_TARGET_OBJS): $(CPP_TARGET_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.cpp))

$(C_OBJS): $(C_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.c))

$(CPP_OBJS): $(CPP_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(SRCDIR)%,$(@:.o=.cpp))

$(LIB_STATIC_NAME): $(C_OBJS) $(CPP_OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(LIB_DINAMIC_NAME): $(C_OBJS) $(CPP_OBJS)
	$(CXX) $(LIBS) $(LDFLAGS) -o $@ $^


install: $(INSTALLED_BINS) $(INSTALLED_INCS) $(INSTALLED_LIBS)

$(INSTALLED_BINS): $(C_TARGETS) $(CPP_TARGETS)
	install -D $(subst $(exec_prefix)/,,$@) $@

$(INSTALLED_INCS): $(subst $(prefix)/,,$(INSTALLED_INCS))
	install -D $(subst $(prefix)/,,$@) $@

$(INSTALLED_LIBS): $(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME)
	install -D $(subst $(prefix)/,,$@) $@


uninstall:
	rm -rf $(INSTALLED_BINS) $(INSTALLED_TOP_INCS) $(INSTALLED_LIBS)


clean:
	$(RM) -rf $(BUILDDIR) $(C_TARGETS) $(CPP_TARGETS) \
		$(LIB_STATIC_NAME) $(LIB_DINAMIC_NAME) $(C_TEST_TARGETS) $(CPP_TEST_TARGETS) \
		$(C_TARGET_OBJS) $(CPP_TARGET_OBJS) $(C_OBJS) $(CPP_OBJS) $(C_TEST_OBJS) $(CPP_TEST_OBJS)


test: $(C_TEST_TARGETS) $(CPP_TEST_TARGETS)

$(C_TEST_TARGETS): $(C_OBJS) $(C_TEST_OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o $@ $(C_OBJS) $(filter %$(notdir $@).o,$(C_TEST_OBJS))

$(CPP_TEST_TARGETS): $(CPP_OBJS) $(CPP_TEST_OBJS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LIBS) -o $@ $(CPP_OBJS) $(filter %$(notdir $@).o,$(CPP_TEST_OBJS))

$(C_TEST_OBJS): $(C_TEST_SRCS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(TESTDIR)%,$(@:.o=.c))

$(CPP_TEST_OBJS): $(CPP_TEST_SRCS)
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LIBS) -c -o $@ $(patsubst $(BUILDDIR)%,$(TESTDIR)%,$(@:.o=.cpp))

