NAME = raylib-hotc-example
CC = cc
CFLAGS = -Wall -Wextra -Werror $(INCLUDES) -g

SRC_FOLDER = src/
LIBS_DIR = libs

# Get hotc library source files
REPO_URL = https://github.com/Tiago-0liveira/hotc.git
HOTC_DIR = $(LIBS_DIR)/hotc

ifeq ($(OS),Windows_NT)
	EXE = .exe
	PLATFORM_SPEC_FLAGS = -lwinmm -lgdi32 -lopengl32
	RAYLIB_URL = https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_win64_mingw-w64.zip
	RAYLIB_DIR = $(LIBS_DIR)\raylib-5.5_win64_mingw-w64
	RAYLIB_DYNAMIC_LIB = raylib.dll
else
	EXE =
	PLATFORM_SPEC_FLAGS = -ldl -Wl,-rpath=./bin
	RAYLIB_URL = https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_linux_amd64.tar.gz
	RAYLIB_DIR = $(LIBS_DIR)/raylib-5.5_linux_amd64
	RAYLIB_TAR = raylib5-5.tar
	RAYLIB_DYNAMIC_LIB = libraylib.so
endif

RAYLIB_ZIP = $(RAYLIB_DIR).zip

INCLUDES = -I includes/ -I $(HOTC_DIR)/includes/ -I $(RAYLIB_DIR)/include/
BIN_DIR = bin
EXECUTABLE = $(BIN_DIR)/$(NAME)$(EXE)
LINK_FLAGS = -L$(HOTC_DIR)/bin -lhotc -L$(BIN_DIR)/ -lraylib $(PLATFORM_SPEC_FLAGS)

SOURCES = $(wildcard $(SRC_FOLDER)*.c)
OBJS = $(patsubst $(SRC_FOLDER)%.c, $(BIN_DIR)/%.o, $(SOURCES))

all: setup_hotc raylib_setup $(EXECUTABLE)

run: all
ifeq ($(OS),Windows_NT)
	@$(EXECUTABLE)
else
	@LIBGL_ALWAYS_SOFTWARE=1 $(EXECUTABLE)
endif

copy_raylib_dll:
ifeq ($(OS),Windows_NT)
	@if not exist ".\bin\$(RAYLIB_DYNAMIC_LIB)" (copy /Y $(RAYLIB_DIR)\lib\$(RAYLIB_DYNAMIC_LIB) bin)
else
	@cp -f $(RAYLIB_DIR)/lib/$(RAYLIB_DYNAMIC_LIB).5.5.0 $(BIN_DIR)/$(RAYLIB_DYNAMIC_LIB).550
endif

create_bin_dir:
ifeq ($(OS),Windows_NT)
	@if not exist $(BIN_DIR) (mkdir $(BIN_DIR)\)
else
	@mkdir -p $(BIN_DIR)
endif

$(BIN_DIR)/%.o: $(SRC_FOLDER)%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(EXECUTABLE): create_bin_dir copy_raylib_dll $(OBJS)
ifeq ($(OS),Windows_NT)
	@if not exist $(BIN_DIR) (mkdir $(BIN_DIR)\)
else
	@mkdir -p $(BIN_DIR)
endif
	@$(CC) $(CFLAGS) $(OBJS) $(LINK_FLAGS) -o $(EXECUTABLE)
	@echo "✅ Built $(EXECUTABLE)"

setup_hotc:
ifeq ($(OS),Windows_NT)
	@if not exist "$(subst /,\,$(HOTC_DIR))" ( \
		echo Cloning $(REPO_URL)... && \
		git clone $(REPO_URL) $(subst /,\,$(HOTC_DIR)) && \
		cd $(subst /,\,$(HOTC_DIR)) && \
		make \
	) else ( \
		echo Hotc is Ready! \
	)
else
	@[ -d $(HOTC_DIR) ] || ( \
		echo "📦 Cloning repository into $(HOTC_DIR)..." && \
		git clone $(REPO_URL) $(HOTC_DIR) && \
		cd $(HOTC_DIR) && \
		$(MAKE) \
	)
endif

raylib_setup:
ifeq ($(OS),Windows_NT)
	@if not exist "$(subst /,\,$(RAYLIB_DIR))" ( \
		echo Downloading raylib... && \
		curl -L -o $(subst /,\,$(RAYLIB_ZIP)) $(RAYLIB_URL) && \
		powershell -Command "Expand-Archive -Path '$(subst /,\,$(RAYLIB_ZIP))' -DestinationPath '$(subst /,\,$(LIBS_DIR))'" && \
		del /Q $(subst /,\,$(RAYLIB_ZIP)) \
	) else ( \
		echo Raylib already exists. Skipping download. \
	)
else
	@if [ ! -d "$(RAYLIB_DIR)" ]; then \
		echo "Downloading raylib..."; \
		curl -L -o $(RAYLIB_TAR) $(RAYLIB_URL); \
		tar -xf $(RAYLIB_TAR) -C $(LIBS_DIR); \
		rm -f $(RAYLIB_TAR); \
	else \
		echo "Raylib already exists. Skipping download."; \
	fi
endif



.PHONY: setup_hotc raylib_setup
