#ifndef PROJECT_H
#define PROJECT_H

enum RaylibSingleFrameType {
	BEFORE_CHECK,
	BEFORE_REBUILD,
	AFTER_REBUILD,
	ON_ERROR
};

void draw_hotc_update_frame(const t_lib_info *lib_info, enum RaylibSingleFrameType type);

#endif