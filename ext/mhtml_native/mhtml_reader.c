#include "mhtml_native.h"
#include "mhtml_reader.h"

void mhtml_reader_deallocate(void *buffer) {
  free(buffer);
}

VALUE mhtml_reader_allocate(VALUE self) {
  struct Buffer *buffer = malloc(sizeof(struct Buffer));
  return Data_Wrap_Struct(self, NULL, mhtml_reader_deallocate, buffer);
}

VALUE mhtml_reader_read(VALUE self, VALUE path) {
  if (!CLASS_OF(path) == rb_cIO) {
    rb_raise(rb_eTypeError, "First parameter must be an IO");
  }

  rb_need_block();

  

  return Qnil;
}

void Init_mhtml_reader() {
  Reader = rb_define_class_under(Mhtml, "Reader", rb_cObject);
  rb_define_alloc_func(Reader, mhtml_reader_allocate);

  rb_define_method(Reader, "read", mhtml_reader_read, 1);
}
