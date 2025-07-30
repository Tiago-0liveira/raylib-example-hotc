#include <hotc.h>
#include <raylib.h>
#include <project.h>


void draw_hotc_update_frame(const t_lib_info *lib_info, enum RaylibSingleFrameType type)
	{
	if (!lib_info) return;

	BeginDrawing();
	char text_buff[512];
	Color bg_color;

	switch (type) {
		case BEFORE_CHECK:
			snprintf(text_buff, sizeof(text_buff), "Checking %s...\n", lib_info->name);
			bg_color = GRAY;
			break;
		case BEFORE_REBUILD:
			snprintf(text_buff, sizeof(text_buff), "Rebuilding %s...\n", lib_info->name);
			bg_color = ORANGE;
			break;
		case AFTER_REBUILD:
			snprintf(text_buff, sizeof(text_buff), "Built %s\n", lib_info->name);
			bg_color = GREEN;
			break;
		case ON_ERROR:
			snprintf(text_buff, sizeof(text_buff), "Could not compile %s...\n", lib_info->name);
			bg_color = RED;
			break;
		default:
			EndDrawing();
			return;
	}
	int text_size = MeasureText(text_buff, 24);

	DrawRectangleRounded((Rectangle) {(int)(800 * 0.125), (int)(600 * 0.30), (int)(800 * 0.75), (int)(600*0.10)}, 0.5, 15, bg_color);
	DrawText(text_buff, 600 / 2 - text_size / 2, 200, 24, BLACK);
	EndDrawing();
}