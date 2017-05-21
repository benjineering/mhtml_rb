#include "mhtml_header.h"
#include "mhtml_native.h"

void Init_mhtml_header() {
  Header = rb_define_class_under(Mhtml, "Header", rb_cObject);
}
