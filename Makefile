# Makefile for Game Development by @gabriel-oprogramador
# Makefile to compile C/C++ C=99 and C++=17

CC = gcc
CCPP = g++
LD = $(CCPP)
TARGET = $(notdir $(CURDIR))

# Includes Path
INCLUDES =

# Universal Flags, Defines and Libs
DEFINES = -DGAME_NAME=$(TARGET) -D_CRT_SECURE_NO_WARNINGS
LIBS =
FLAGS =

# Language Flags and Defines
DEFINES_C =
DEFINES_CPP =
FLAGS_C =
FLAGS_CPP =

# Platform Flags and Defines
DEFINES_WINDOWS = -DPLATFORM_WINDOWS
DEFINES_LINUX = -DPLATFORM_LINUX
LIBS_LINUX =
LIBS_WINDOWS =

# Compile Mode
config = debug

# Intern Defines
_OS =
_COMPILE_COMAND =
_COMPILE_MODE =
_EXTENSION =

# Set Compile Command
ifeq ($(CC), clang)
	ifeq ($(OS), Windows_NT)
		FLAGS += --target=x86_64-w64-windows-gnu
	endif
_CLANG_COMPILE_JSON = @sed -e '1s/^/[\n''/' -e '$$s/,$$/\n'']/' $(OBJ_JSON) > compile_commands.json
_CLANG_JSON = -MJ $@.json
_CLANG_RM_TRASH = @rm -f -- --target=x86_64-w64-windows-gnu
else
_CLANG_COMPILE_JSON =
_CLANG_JSON =
_CLANG_RM_TRASH =
endif

# Set Operation System
ifeq ($(OS), Windows_NT)
	_OS = Windows
	_EXTENSION = .exe
	DEFINES += $(DEFINES_WINDOWS)
	FLAGS += $(FLAGS_WINDOWS)
	LIBS += $(LIBS_WINDOWS)
	FLAGS_C += -std=c99
	FLAGS_CPP += -std=c++17
else ifeq ($(shell uname), Linux)
	_OS = Linux
	_EXTENSION =
	DEFINES += $(DEFINES_LINUX)
	FLAGS += $(FLAGS_LINUX)
	LIBS += $(LIBS_LINUX)
	FLAGS_C += -std=gnu99
	FLAGS_CPP += -std=gnu++17
else
	_OS = Unknown
endif

define COPY_COMMAND
	@echo "Generating Game Package..."
	@mkdir -p $(BUILD_DIR)/$(_COMPILE_MODE)/Data
	@cp -f -r "$(abspath Content/)" "$(TARGET_DIR)/Data"
	@cp -f -r "$(abspath Config/)" "$(TARGET_DIR)/Data"
endef

# Set Compile Mode
ifeq ($(config), debug)
	_COMPILE_MODE = Debug
	DEFINES += -DDEBUG_MODE
	FLAGS += -g -Wall
	DEFINES += -DCONFIG_PATH=$(abspath Config/)/
	DEFINES += -DCONTENT_PATH=$(abspath Content/)/
	COPY_COMMAND =
else ifeq ($(config), release)
	_COMPILE_MODE = Release
	DEFINES += -DRELEASE_MODE
	FLAGS += -O3
	DEFINES += -DCONFIG_PATH=Data/Config/
	DEFINES += -DCONTENT_PATH=Data/Content/
else ifeq ($(config), shipping)
	_COMPILE_MODE = Shipping
	DEFINES += -DRELEASE_MODE -DSHIPPING_MODE
	DEFINES += -DCONFIG_PATH=Data/Config/
	DEFINES += -DCONTENT_PATH=Data/Content/
	FLAGS += -O3
endif

# ...
BUILD_DIR = Build
INTERMEDIATE_DIR = Intermediate
TARGET_DIR = $(BUILD_DIR)/$(_COMPILE_MODE)
OBJ_DIR = $(INTERMEDIATE_DIR)/Build/$(_COMPILE_MODE)
SRC_DIR = Source
CONFIG_DIR = Config
CONTENT_DIR = Content

SRC_C = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c) $(wildcard $(SRC_DIR)/*/*/*.c) $(wildcard $(SRC_DIR)/*/*/*/*.c)
SRC_CPP = $(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/*/*.cpp) $(wildcard $(SRC_DIR)/*/*/*.cpp) $(wildcard $(SRC_DIR)/*/*/*/*.Cpp)
OBJ_C = $(addprefix $(OBJ_DIR)/, $(notdir $(SRC_C:.c=.o)))
OBJ_CPP = $(addprefix $(OBJ_DIR)/, $(notdir $(SRC_CPP:.cpp=.o)))
OBJ_C_JSON = $(addprefix $(OBJ_DIR)/, $(notdir $(OBJ_C:.o=.o.json)))
OBJ_CPP_JSON = $(addprefix $(OBJ_DIR)/, $(notdir $(OBJ_CPP:.o=.o.json)))
OBJ_JSON = $(OBJ_C_JSON) $(OBJ_CPP_JSON)

all: $(TARGET)

install:
	@echo "/==========/ Compilation Start /==========/"
	@echo "Target Info => Platform:$(_OS) Linker:$(CCPP) Mode:$(_COMPILE_MODE)"
	@mkdir -p $(CONFIG_DIR)
	@mkdir -p $(CONTENT_DIR)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(TARGET_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(SRC_DIR)

run:
	@if $(TARGET_DIR)/$(TARGET)$(_EXTENSION) > /dev/null 2>&1; then \
		echo "Running => $(TARGET_DIR)/$(TARGET)$(_EXTENSION)"; \
		$(TARGET_DIR)/$(TARGET)$(_EXTENSION); \
	else \
		$(MAKE) -s build; \
	fi

build: $(TARGET) run

clean:
	@echo "Cleaning Everything..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(INTERMEDIATE_DIR)
	@rm -f compile_commands.json
	$(_CLANG_RM_TRASH)

$(TARGET): install $(OBJ_C) $(OBJ_CPP)
	@echo "Linking => $(TARGET_DIR)/$(TARGET)$(_EXTENSION)"
	@$(LD) $(OBJ_C) $(OBJ_CPP) $(FLAGS) $(LIBS) -o $(TARGET_DIR)/$(TARGET)$(_EXTENSION)
	$(_CLANG_COMPILE_JSON)
	$(_CLANG_RM_TRASH)
	$(COPY_COMMAND)
	@echo "/==========/Compilation Finish /==========/"

# C ===================
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "Compiling => $<..."
	@$(CC) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_C) $(FLAGS) $(DEFINES) $(DEFINES_C) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/%.c
	@echo "Compiling => $<..."
	@$(CC) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_C) $(FLAGS) $(DEFINES) $(DEFINES_C) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/*/%.c
	@echo "Compiling => $<..."
	@$(CC) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_C) $(FLAGS) $(DEFINES) $(DEFINES_C) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/*/*/%.c
	@echo "Compiling => $<..."
	@$(CC) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_C) $(FLAGS) $(DEFINES) $(DEFINES_C) -c -o $@

# Cpp ===================
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "Compiling => $<..."
	@$(CCPP) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_CPP) $(FLAGS) $(DEFINES) $(DEFINES_CPP) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/%.cpp
	@echo "Compiling => $<..."
	@$(CCPP) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_CPP) $(FLAGS) $(DEFINES) $(DEFINES_CPP) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/*/%.cpp
	@echo "Compiling => $<..."
	@$(CCPP) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_CPP) $(FLAGS) $(DEFINES) $(DEFINES_CPP) -c -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/*/*/*/%.cpp
	@echo "Compiling => $<..."
	@$(CCPP) $(_CLANG_JSON) $< $(INCLUDES) $(FLAGS_CPP) $(FLAGS) $(DEFINES) $(DEFINES_CPP) -c -o $@
