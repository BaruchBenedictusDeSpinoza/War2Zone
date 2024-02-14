#!/bin/sh
#-*-sh-*-

#
# Copyright © 2015-2018 Inria.  All rights reserved.
# See COPYING in top-level directory.
#

HWLOC_top_srcdir="/Users/gonenc.aydin/War2Zone/xmigbuilfroomsource/xmrig/scripts/build/hwloc-2.9.0"
HWLOC_top_builddir="/Users/gonenc.aydin/War2Zone/xmigbuilfroomsource/xmrig/scripts/build/hwloc-2.9.0"
srcdir="$HWLOC_top_srcdir/utils/hwloc"
builddir="$HWLOC_top_builddir/utils/hwloc"
hdhd="$builddir/hwloc-dump-hwdata"

: ${TMPDIR=/tmp}
{
  tmp=`
    (umask 077 && mktemp -d "$TMPDIR/fooXXXXXX") 2>/dev/null
  ` &&
  test -n "$tmp" && test -d "$tmp"
} || {
  tmp=$TMPDIR/foo$$-$RANDOM
  (umask 077 && mkdir "$tmp")
} || exit $?

set -e

tarball="$srcdir/test-hwloc-dump-hwdata/"`basename $1`
(cd "$tmp" && tar xfj $tarball)

HWLOC_FSROOT="`echo "$tmp"/*`"
export HWLOC_FSROOT

$hdhd -o $tmp/output

/usr/bin/diff -u -r "$HWLOC_FSROOT/expected_output" "$tmp/output"

rm -rf "$tmp"
