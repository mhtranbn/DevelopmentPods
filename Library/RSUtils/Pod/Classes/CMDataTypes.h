/**
 @file      CMDataTypes.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#ifndef CMDataTypes_h
#define CMDataTypes_h

// _FM_ not includes %: use eg "%02"_FM_floating

/*
 Middle format characters (flags):
 • "-": Left-justify within the given field width; Right justification is the default
 • "+": Forces to preceed the result with a plus or minus sign (+ or -) even for positive numbers.
 By default, only negative numbers are preceded with a - sign.
 • "#": Used with o, x or X specifiers the value is preceeded with 0, 0x or 0X respectively for values different than zero.
 Used with a, A, e, E, f, F, g or G it forces the written output to contain a decimal point even if no more digits follow.
 By default, if no digits follow, no decimal point is written.
 • "0": Left-pads the number with zeroes (0) instead of spaces when padding is specified (see width sub-specifier).
 • (number): Minimum number of characters to be printed. If the value to be printed is shorter than this number,
 the result is padded with blank spaces. The value is not truncated even if the result is larger.
 • "*": The width is not specified in the format string, but as an additional integer value argument preceding
 the argument that has to be formatted.
 • "."(number): For integer specifiers (d, i, o, u, x, X): precision specifies the minimum number of digits to be written.
 If the value to be written is shorter than this number, the result is padded with leading zeros.
 The value is not truncated even if the result is longer. A precision of 0 means that no character is written for the value 0.
 For a, A, e, E, f and F specifiers: this is the number of digits to be printed after the decimal point (by default, this is 6).
 For g and G specifiers: This is the maximum number of significant digits to be printed.
 For s: this is the maximum number of characters to be printed. By default all characters are printed until
 the ending null character is encountered.
 If the period is specified without an explicit value for precision, 0 is assumed.
 • ".*": The precision is not specified in the format string, but as an additional integer value argument preceding
 the argument that has to be formatted.
 
 ---
 
 The length sub-specifier modifies the length of the data type:
 
 length     d i             u o x X                 f F e E g G a A     c       s           p       n
+----------+---------------+-----------------------+-------------------+-------+-----------+-------+---------------+
 (none)     int             unsigned int            double              int     char*       void*	int*
 hh         signed char     unsigned char                                                           signed char*
 h          short int       unsigned short int                                                      short int*
 l          long int        unsigned long int                           wint_t  wchar_t*            long int*
 ll         long long int   unsigned long long int                                                  long long int*
 j          intmax_t        uintmax_t                                                               intmax_t*
 z          size_t          size_t                                                                  size_t*
 t          ptrdiff_t       ptrdiff_t                                                               ptrdiff_t*
 L                                                  long double
 */

// C format

#define FM_int              @"%d"
#define _FM_int             @"d"
#define FM_uint             @"%u"
#define _FM_uint            @"u"
#define FM_uoctal           @"%o"
#define _FM_uoctal          @"o"
#define FM_hex_uint         @"%x"
#define _FM_hex_uint        @"x"
#define FM_HEX_UINT         @"%X"
#define _FM_HEX_UINT        @"X"
#define FM_floating         @"%f" // float & double
#define _FM_floating        @"f"
#define FM_FLOATING         @"%F"
#define _FM_FLOATING        @"F"
#define FM_scientific       @"%e" // float & double
#define _FM_scientific      @"e"
#define FM_SCIENTIFIC       @"%E"
#define _FM_SCIENTIFIC      @"E"
#define FM_shortest_fe      @"%g" // Shortest between %f or %e
#define _FM_shortest_fe     @"g"
#define FM_SHORTEST_FE      @"%G"
#define _FM_SHORTEST_FE     @"G"
#define FM_hex_floating     @"%a" // float & double
#define _FM_hex_floating    @"a"
#define FM_HEX_FLOATING     @"%A"
#define _FM_HEX_FLOATING    @"A"
#define FM_char             @"%c"
#define _FM_char            @"c"
#define FM_string           @"%s"
#define FM_pointer          @"%p"
#define FM_percent_char     @"%%"

// Format for Foundation data (NS...)

#define FM_BOOL     @"%d"
#define _FM_BOOL    @"d"


#if defined(__LP64__) && __LP64__
// NSInteger ~ long
#define FM_NSInteger    @"%ld"
#define _FM_NSInteger   @"ld"
#define FM_NSUInteger   @"%lu"
#define _FM_NSUInteger  @"lu"
// CGFloat ~ double
#define FM_CGFloat      @"%lf"
#define _FM_CGFloat     @"lf"
// Int32 ~ int
#define FM_UInt32       @"%u"
#define _FM_UInt32      @"u"
#define FM_UInt32_hex   @"%x"
#define _FM_UInt32_hex  @"x"
#define FM_UInt32_HEX   @"%X"
#define _FM_UInt32_HEX  @"X"
#define FM_SInt32       @"%d"
#define _FM_SInt32      @"d"
#else
// NSInteger ~ int
#define FM_NSInteger    @"%d"
#define _FM_NSInteger   @"d"
#define FM_NSUInteger   @"%u"
#define _FM_NSUInteger  @"u"
// CGFloat ~ float
#define FM_CGFloat      @"%f"
#define _FM_CGFloat     @"f"
// Int32 ~ long
#define FM_UInt32       @"%lu"
#define _FM_UInt32      @"lu"
#define FM_UInt32_hex   @"%lx"
#define _FM_UInt32_hex  @"lx"
#define FM_UInt32_HEX   @"%lX"
#define _FM_UInt32_HEX  @"lX"
#define FM_SInt32       @"%ld"
#define _FM_SInt32      @"ld"
#endif

// Int8 ~ char
#define FM_UInt8        @"%u"
#define _FM_UInt8       @"u"
#define FM_SInt8        @"%d"
#define _FM_SInt8       @"d"
// Int16 ~ short
#define FM_UInt16       @"%hu"
#define _FM_UInt16      @"hu"
#define FM_UInt16_hex   @"%hx"
#define _FM_UInt16_hex  @"hx"
#define FM_UInt16_HEX   @"%hX"
#define _FM_UInt16_HEX  @"hX"
#define FM_SInt16       @"%hd"
#define _FM_SInt16      @"hd"

#if defined(_MSC_VER) && !defined(__MWERKS__) && defined(_M_IX86)
// Int64 ~ long
#define FM_UInt64       @"%lu"
#define _FM_UInt64      @"lu"
#define FM_UInt64_hex   @"%lx"
#define _FM_UInt64_hex  @"lx"
#define FM_UInt64_HEX   @"%lX"
#define _FM_UInt64_HEX  @"lX"
#define FM_SInt64       @"%ld"
#define _FM_SInt64      @"ld"
#else
// Int64 ~ long long
#define FM_UInt64       @"%llu"
#define _FM_UInt64      @"llu"
#define FM_UInt64_hex   @"%llx"
#define _FM_UInt64_hex  @"llx"
#define FM_UInt64_HEX   @"%llX"
#define _FM_UInt64_HEX  @"llX"
#define FM_SInt64       @"%lld"
#define _FM_SInt64      @"lld"
#endif

#endif
