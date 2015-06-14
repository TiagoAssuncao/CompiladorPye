#ifndef _BOOL_H
#define _BOOL_H

// C (< C99) has no bool type. This will simulate it.
typedef enum {
	FALSE,
	TRUE
} bool;

#endif