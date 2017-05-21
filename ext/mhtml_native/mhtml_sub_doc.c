#include "mhtml_sub_doc.h"
#include "mhtml_native.h"

void Init_mhtml_sub_doc() {
  SubDoc = rb_define_class_under(Mhtml, "SubDoc", rb_cObject);
}
