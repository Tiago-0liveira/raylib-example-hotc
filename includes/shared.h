#ifndef SHARED_H
#define SHARED_H

#include <raylib.h>


struct SidebarProps {
	Color background;
	int width;
	int height;
	int posX;
	int posY;
	const char *text;
	Color textColor;
	int fontSize;
};

#endif