#include <raylib.h>
#include <time.h>

#include <hotc.h>
#include <hotc_extra.h>
#include <shared.h>
#include <project.h>

#define TYPE_PTR_FUNC(RET, NAME, PARAMS) typedef RET (*NAME##_func_ptr)(PARAMS);NAME##_func_ptr NAME = NULL; 

TYPE_PTR_FUNC(void, draw_sidebar, void)

struct SidebarProps sidebar_props = {0};

LAMBDA(styles, {
	struct SidebarProps *res = get_lib_address(lib_info, "sidebar_properties");
	sidebar_props = *res;

	draw_sidebar = get_lib_address(lib_info, "draw_sidebar");
})

LAMBDA(before_check, { draw_hotc_update_frame(lib_info, BEFORE_CHECK); })
LAMBDA(before_rebuild, { draw_hotc_update_frame(lib_info, BEFORE_REBUILD); })
LAMBDA(after_rebuild, { draw_hotc_update_frame(lib_info, BEFORE_REBUILD); })
LAMBDA(on_error, { 
	draw_hotc_update_frame(lib_info, ON_ERROR);
	draw_sidebar = NULL;
})

update_lib_event_handlers update_handlers = { LAMBDA_before_check, LAMBDA_before_rebuild, LAMBDA_after_rebuild, LAMBDA_on_error };

int main(void)
{
	HOTC_SET_PATH("./libs/hotc/");
	#ifdef _WIN32
		register_shared_library("./src/shared/styles.c", HOTC_ON_LOAD(LAMBDA_styles), "-I ./libs/raylib-5.5_win64_mingw-w64/include -I ./includes -L./bin -lraylib -lwinmm -lgdi32 -lopengl32");
	#else
		register_shared_library("./src/shared/styles.c", HOTC_ON_LOAD(LAMBDA_styles), "-I ./libs/raylib-5.5_linux_amd64/include -I ./includes -L./bin -lraylib");
	#endif

	InitWindow(800, 600, "raylib [core] example - basic window");
	SetTargetFPS(60);
	time_t last = time(NULL);
	time_t now = time(NULL);

	while (!WindowShouldClose())
	{
		time(&now);
		double diff = difftime(now, last);
		if (diff >= 0.5) {
			last = now;
			check_and_update_libs(update_handlers);
		}
		BeginDrawing();
		ClearBackground(BLACK);

		if (draw_sidebar) {
			draw_sidebar();
		}
		EndDrawing();
	}
	CloseWindow();
	return 0;
}