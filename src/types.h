#ifndef __TYPES_H_
#define __TYPES_H_

// gtk.h defines its own true and false
#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

typedef unsigned int bool;
typedef void(*simpleEvent)(void);

#endif
