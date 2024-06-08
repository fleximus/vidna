module idna

import encoding.utf8
import math

const (
	max_int = 2147483647  // 0x7FFFFFFF
	base = 36
	t_min = 1
	t_max = 26
	skew = 38
	damp = 700
	initial_bias = 72
	initial_n = 128  // 0x80
	delimiter = '-'  // '\x2D'
)

pub fn encode(input2 string) string {
    mut output := ''
    mut basic_output := ''

    input := ucs2decode(input2)

    // Copy all basic code points to the output
    for c in input {
        if c < 0x80 {
            basic_output += u8(c).ascii_str()
        }
    }

    basic_output_len := basic_output.len
    output += basic_output

    if basic_output_len > 0 {
        output += delimiter
    }

    mut n := initial_n
    mut delta := 0
    mut bias := initial_bias
    mut h := basic_output_len

    for h < input.len {
        mut m := max_int

        for c in input {
            if c >= n && c < m {
                m = c
            }
        }

        // @TODO: Guard against overflow here!
        if (m - n) > math.floor((max_int - delta) / (h + 1)) {
            error('overflow')
        }

        delta += (m - n) * (h + 1)
        n = m

        for c in input {
            if c < n && delta + 1 > max_int {
                error("overflow")
            }

            if c < n {
                delta += 1
            }

            if c == n {
                mut q := delta
                mut k := base

                for {
                    t := if k <= bias { t_min } else if k >= bias + t_max { t_max } else { k - bias }

                    if q < t {
                        break
                    }

                    mut q_minus_t := q -t
                    mut base_minus_t := base - t

                    output += digit_to_basic(t + q_minus_t % base_minus_t, 0).ascii_str()
                    q = int(math.floor(q_minus_t / base_minus_t))
                    k += base
                }

                output += digit_to_basic(q, 0).ascii_str()
                bias = adapt(delta, h+1, h == basic_output_len)

                delta = 0
                h += 1
            }
        }

        delta += 1
        n += 1
    }

    return output
}

pub fn decode(input_raw string) string {
    mut input := input_raw
    mut output := []rune{}
    mut n := u16(initial_n)
    mut i := 0
    mut bias := initial_bias

    mut basic := input.index_u8_last('-'[0])
    if basic == -1 {
        basic = 0
    }

    for j in 0..basic {
        if input[j] >= 0x80 {
            error('not-basic')
        }
        output << input[j]
    }

    mut index := if basic > 0 { basic + 1 } else { 0 }

    for index < input.runes().len {
        old_i := i

        mut w := 1
        mut k := base
        
        for {
            if index >= input.len {
                error('invalid-input-index')
            }

            digit := basic_to_digit(input[index])
            index += 1
            
            if digit >= base {
                error('invalid-input-digit')
            }

            if digit > (max_int - i) / w {
                error('overflow-d')
            }

            i += digit * w
            t := if k <= bias { t_min } else { if k >= bias + t_max { t_max } else { k - bias }  }

            if digit < t {
                break
            }

            if w > max_int / (base - t) {
                error('overflow-w')
            }

            w *= (base - t)
            k += base
        }

        out := output.len + 1
        bias = adapt(i - old_i, out, old_i == 0)

        if i / out > max_int - n {
            error('overflow')
        }

        n += u16(i / out)
        i %= out
        output.insert(i, n)
        i += 1
    }

    return output.string()
}

@[inline]
fn adapt(delta int, num_points int, first_time bool) int {
    mut d := delta

    if first_time {
        d /= damp
    } else {
        d /= 2
    }

    d += d / num_points
    mut k := 0

    for d > (base - t_min) * t_max / 2 {
        d /= (base - t_min)
        k += base
    }

    return k + (base - t_min + 1) * d / (d + skew)
}

fn decode_digit(digit int) int {
    if digit < 26 {
        return digit + 26
    }

    return digit - 26
}

fn digit_to_basic(digit int, flag int) u8 {
    return u8(digit + 22 + 75 * u8(digit < 26) - (u8(flag != 0) << 5))
}

// @TODO: works with 'cafè', but not with 'café.com' - splitting not working as desired
pub fn to_unicode(input string) string {
    if input.len >= 4 && input[0..4] == "xn--" {
        return map_domain_decode(input[4..input.len].to_lower())
    }

    return map_domain_decode(input.to_lower())
}

pub fn to_ascii(input string) string {
    return "xn--" + map_domain(input)
}

fn ucs2decode(input string) []int {
    mut output := []int{}
    mut c := 0
    mut i := 0

    for r in input.runes() {
        c = utf8.get_uchar(input, i)
        output << c
        i += r.str().len
    }

    return output
}

fn map_domain(domain string) string {
    parts := domain.split('@')

    mut result := ''
    mut d := domain

    if parts.len > 1 {
        result = parts[0] + '@'
        d = parts[1]
    }

    d = d.replace_each([
        '\u3002', '\x2E',
        '\uFF0E', '\x2E',
        '\uFF61', '\x2E'
    ])

    labels := d.split('.')

    encode_only_non_ascii := fn (s string) string {
        if non_ascii_check(s) {
            return encode(s)
        }

        return s
    }

    encoded := labels.map(encode_only_non_ascii(it)).join('.')
    return result + encoded
}

fn map_domain_decode(domain string) string {
    parts := domain.split('@')

    mut result := ''
    mut d := domain

    if parts.len > 1 {
        result = parts[0] + '@'
        d = parts[1]
    }

    d = d.replace_each([
        '\u3002', '\x2E',
        '\uFF0E', '\x2E',
        '\uFF61', '\x2E'
    ])

    labels := d.split('.')
    decoded := labels.map(decode(it)).join('.')

    return result + decoded
}

fn non_ascii_check(input string) bool {
    for c in input {
        if c > initial_n {
            return true
        }
    }

    return false
}

fn basic_to_digit(codepoint u8) u8 {
  	if codepoint >= 0x30 && codepoint < 0x3A {
		return 26 + (codepoint - 0x30)
	}

	if codepoint >= 0x41 && codepoint < 0x5B {
		return codepoint - 0x41
	}

	if codepoint >= 0x61 && codepoint < 0x7B {
		return codepoint - 0x61
	}
	
    return base
}
