#ifndef MHTML_NATIVE_H
#define MHTML_NATIVE_H

#include <ruby.h>

#define BUFFER_SIZE 2048

struct Header {
  const char *key;
  const char *value;
};

struct Buffer {
  char bytes[BUFFER_SIZE];
};

extern VALUE Header;
extern VALUE Mhtml;
extern VALUE Reader;
extern VALUE SubDoc;

#endif
