#include "mhtml_native.h"
#include "mhtml_reader.h"
#include "mhtml_header.h"
#include "mhtml_sub_doc.h"

VALUE Header = Qnil;
VALUE Mhtml = Qnil;
VALUE Reader = Qnil;
VALUE SubDoc = Qnil;

void Init_mhtml_native() {
  Mhtml = rb_define_module("Mhtml");

  Init_mhtml_reader();
  Init_mhtml_header();
  Init_mhtml_sub_doc();
}
