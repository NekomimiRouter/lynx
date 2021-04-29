#include <mruby.h>
#include <mruby/compile.h>
#include <stdlib.h>

#include "argument.h"

int main(int argc, char **argv)
{
    /* Parse cmdline arguments */
    option_t opt;
    parse_arg(argc, argv, &opt);
    if (!opt.execute)
    {
        return 0;
    }

    /* Initialize Ruby runtime */
    mrb_state *mrb = mrb_open();
    if (!mrb)
    {
        fprintf(stderr, "Could not initialize Ruby runtime. Abort.\n");
        exit(-1);
    }

    /* Load script file */
    FILE *fp = fopen(argv[1], "r+"); /* read & update fails on opening directories */
    if (!fp)
    {
        fprintf(stderr, "Failed to open file %s. Abort.\n", argv[1]);
        mrb_close(mrb);
        exit(-1);
    }
    mrb_load_file(mrb, fp);
    fclose(fp);

    /* Runtime error */
    if (mrb->exc)
    {
        mrb_print_error(mrb);
        mrb_close(mrb);
        exit(-1);
    }

    /* Clean up */
    mrb_close(mrb);

    return 0;
}
