#include <hotc_shared.h>
#include <raylib.h>
#include <shared.h>

struct SidebarButton {
	const char *text;
};

EXPORT struct SidebarProps sidebar_properties = {
	{ 150, 10, 10, 255 },
	300, 600, 0, 1,
	"Sidebar", { 255, 161, 0, 255 }, 32
};

struct SidebarButton buttons[5] = {
	{"Play"},{"Multiplayer"},{"Friends"},{"Settings"},{"Exit"}
};

Vector2 BtnSize = {300 / 1.3, 35};
int btnOffsetIncrement = 50;
#define ARRAY_LEN(arr) sizeof(buttons)/sizeof(buttons[0])

void EXPORT draw_sidebar() {
	DrawRectangle(0, 0, sidebar_properties.width, sidebar_properties.height, sidebar_properties.background);
	DrawFPS(10,10);
	
	int textSize = MeasureText(sidebar_properties.text, sidebar_properties.fontSize);
	DrawText(sidebar_properties.text, 300 / 2 - textSize / 2, 50, sidebar_properties.fontSize, sidebar_properties.textColor);

	Vector2 mouse_pos = GetMousePosition();
	int hovering_btn = false;

	for (int i = 0; i < ARRAY_LEN(buttons); i++) {
		struct SidebarButton button = buttons[i];
		textSize = MeasureText(button.text, 18);
		Rectangle btnHitBox = {
			sidebar_properties.width / 8, 150 + i*btnOffsetIncrement,
			BtnSize.x, BtnSize.y
		};
		if (i >= ARRAY_LEN(buttons) - 2) {
			btnHitBox.y = 600 - 20 - (ARRAY_LEN(buttons)-i)*btnOffsetIncrement;
		}
		if (CheckCollisionPointRec(mouse_pos, btnHitBox)) {
			DrawRectangleRounded((Rectangle){
				btnHitBox.x - 2, btnHitBox.y -2,
				btnHitBox.width + 4, btnHitBox.height + 4
			}, 0.5, 10, WHITE);	
			hovering_btn = true;
		}
		DrawRectangleRounded(btnHitBox, 0.5, 10, BLACK);
		DrawText(button.text, sidebar_properties.width / 2 - textSize / 2, btnHitBox.y + 10, 19, RAYWHITE);
	}

	if (hovering_btn) {
		SetMouseCursor(MOUSE_CURSOR_POINTING_HAND);
	} else {
		SetMouseCursor(MOUSE_CURSOR_DEFAULT);
	}
	return;
}