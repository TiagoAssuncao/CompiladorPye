#include <stdio.h>

#include "debugger.h"

void debug(char *debug_msg) {
	#ifdef DEBUG_ON
		puts(debug_msg);
	#endif

	return;
}

