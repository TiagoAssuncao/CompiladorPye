#include "debugger.h"

#define DEBUG_ON

void debug(char *debug_msg) {
	#ifdef DEBUG_ON
		puts(debug_msg);
	#endif

	return;
}

