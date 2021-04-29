#ifndef LYNX_ARGUMENT_H
#define LYNX_ARGUMENT_H

#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

#include "config.h"

/* Defined in config.h */
static const char *lynx_version = LYNX_VERSION_STRING;
static const char *lynx_maintainer = LYNX_MAINTAINER_EMAIL_STRING;
static const char *lynx_description = LYNX_DESCRIPTION_STRING;

/* option_t is used by main() to communicate with parse_arg() */
typedef struct option
{
    bool execute; /* Load script and execute */
} option_t;

static void help()
{
    printf("Usage: \n");
    printf("lynx [script_file]\n");
    printf("    -h, Show this message\n");
    printf("    -v, Print version number\n");
}

static void version()
{
    printf("Version:\t%s\n", lynx_version);
    printf("Maintainer:\t%s\n", lynx_maintainer);
    printf("Description:\t%s\n", lynx_description);
}

option_t *parse_arg(int argc, char **argv, option_t *opt)
{
    /* No cmdline argument provided, print help info and exit */
    if (argc == 1)
    {
        opt->execute = false;
        help();
        return opt;
    }

    opt->execute = true;
    int m = 0;
    while ((m = getopt(argc, argv, "vh")) != -1)
    {
        switch (m)
        {
        case 'h':
            help();
            opt->execute = false;
            break;
        case 'v':
            version();
            opt->execute = false;
            break;
        case '?': /* Unknown option */
        default:
            opt->execute = false;
            exit(-1);
        }
    }

    return opt;
}

#endif
