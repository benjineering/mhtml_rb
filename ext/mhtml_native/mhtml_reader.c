#include "mhtml_native.h"
#include "mhtml_reader.h"

void mhtml_reader_deallocate(void *buffer) {
  free(buffer);
}

VALUE mhtml_reader_allocate(VALUE self) {
  struct Buffer *buffer = malloc(sizeof(struct Buffer));
  return Data_Wrap_Struct(self, NULL, mhtml_reader_deallocate, buffer);
}

VALUE mhtml_reader_initialize(VALUE self) {
  if (rb_block_given_p()) {
    rb_iv_set(self, "@block", rb_block_proc());
  }

  return self;
}

VALUE mhtml_reader_read(VALUE self, VALUE path) {
  if (!CLASS_OF(path) == rb_cIO) {
    rb_raise(rb_eTypeError, "Parameter must be an IO");
  }

  rb_need_block();

  

  return Qnil;
}

VALUE mhtml_reader_shovel(VALUE self, VALUE string) {
  Check_Type(string, T_STRING);

  VALUE item = Qnil;
  VALUE block = rb_iv_get(self, "@block");

  if (block == Qnil) {
    rb_raise(rb_eTypeError, "No block given at initialize");
  }

  if (item != Qnil) {
    if (block != Qnil) {
      rb_funcall(block, rb_intern("call"), 1, item);
    }
  }

  return Qnil;
}

void Init_mhtml_reader() {
  Reader = rb_define_class_under(Mhtml, "Reader", rb_cObject);
  rb_define_alloc_func(Reader, mhtml_reader_allocate);

  rb_define_method(Reader, "initialize", mhtml_reader_initialize, 0);
  rb_define_method(Reader, "read", mhtml_reader_read, 1);
  rb_define_method(Reader, "<<", mhtml_reader_shovel, 1);
}
