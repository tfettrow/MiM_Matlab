/* Copyright (C) 2001-2020 Artifex Software, Inc.
   All Rights Reserved.

   This software is provided AS-IS with no warranty, either express or
   implied.

   This software is distributed under license and may not be copied,
   modified or distributed except as expressly authorized under the terms
   of the license contained in the file LICENSE in this distribution.

   Refer to licensing information at http://www.artifex.com or contact
   Artifex Software, Inc.,  1305 Grant Avenue - Suite 200, Novato,
   CA 94945, U.S.A., +1(415)492-9861, for further information.
*/


/* filter_read_predictor prototype */

#ifndef ifwpred_INCLUDED
#  define ifwpred_INCLUDED

#include "scommon.h"
#include "iref.h"

/* Exported by zfilter2.c for zfzlib.c */
int filter_write_predictor(i_ctx_t *i_ctx_p, int npop,
                           const stream_template * templat,
                           stream_state * st);

#endif /* ifwpred_INCLUDED */
