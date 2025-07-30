NAME = raylib-hotc-example
CC = cc
CFLAGS = -Wall -Wextra -Werror $(INCLUDES) -g

SRC_FOLDER = src/
LIBS_DIR = libs

# Get hotc library source files
REPO_URL = https://github.com/Tiago-0liveira/hotc.git
HOTC_DIR = $(LIBS_DIR)/hotc

RAYLIB_URL = https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_win64_mingw-w64.zip
RAYLIB_DIR = $(LIBS_DIR)/raylib-5.5_win64_mingw-w64
RAYLIB_ZIP = $(RAYLIB_DIR).zip


ifeq ($(OS),Windows_NT)
	LIB_EXT = .lib
	EXE = .exe
else
	LIB_EXT = .a
	EXE =
endif

INCLUDES = -I includes/ -I $(HOTC_DIR)/includes/ -I $(RAYLIB_DIR)/include/
BIN_DIR = bin
EXAMPLES_DIR = examples/
EXECUTABLE = $(BIN_DIR)/$(NAME)$(EXE)
LINK_FLAGS = -L$(HOTC_DIR)/bin -lhotc -L$(BIN_DIR)/ -lraylib -lwinmm -lgdi32 -lopengl32

SOURCES = $(wildcard $(SRC_FOLDER)*.c)
OBJS = $(patsubst $(SRC_FOLDER)%.c, $(BIN_DIR)/%.o, $(SOURCES))

all: setup_hotc raylib_setup $(EXECUTABLE)

run: all
	@$(EXECUTABLE)

copy_raylib_dll: $(BIN_DIR)/raylib.dll

$(BIN_DIR)/raylib.dll: 
ifeq ($(OS),Windows_NT)
	@if not exist ".\bin\raylib.dll" (copy /Y libs\raylib-5.5_win64_mingw-w64\lib\raylib.dll bin)
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
	$(CC) $(CFLAGS) $(OBJS) $(LINK_FLAGS) -o $(EXECUTABLE)
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
	@echo "❌ raylib_setup only implemented for Windows_NT (MinGW)"
endif



.PHONY: setup_hotc raylib_setup
