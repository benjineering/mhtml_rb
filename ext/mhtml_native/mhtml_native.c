#include "mhtml_native.h"

VALUE Mhtml = Qnil;
VALUE Doc = Qnil;
VALUE SubDoc = Qnil;

VALUE mhtml_read(VALUE self, VALUE path) {
  if (!CLASS_OF(path) == rb_cIO) {
    rb_raise(rb_eTypeError, "First parameter must be an IO");
  }

  rb_need_block();

  

  return Qnil;
}

void Init_mhtml_native() {
  Mhtml = rb_define_module("Mhtml");
  rb_define_singleton_method(Mhtml, "read", mhtml_read, 1);
}
