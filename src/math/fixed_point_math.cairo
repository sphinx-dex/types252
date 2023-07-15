use traits::Into;
use clone::Clone;
use cmp::min;

use types252::math::math;

//////////////////////////////
// CONSTANTS
//////////////////////////////

const Q128: u256 = 340282366920938463463374607431768211456;

const Q100: u256 = 1267650600228229401496703205376;

const Q64: u256 = 18446744073709551616;

const Q32: u256 = 4294967296;

const Q16: u256 = 65536;

const ONE: u256 = 10000000000000000000000000000;

//////////////////////////////
// FUNCTIONS
//////////////////////////////

// Calculates the binary exponent of 156.100-bit fixed-point number using the binary fraction method.
//
// # Arguments
// * `x` - The number to exponentiate encoded as 156.100-bit fixed point.
fn exp2(x: u256) -> u256 {
    // Start from 0.5 in the 156.100-bit fixed-point format.
    let mut result: u256 = 0x800000000000000000000000000000000000000;

    // Iterate through each bit, multiplying the result by sqrt(2^-i) when the bit at position i is initialized.
    if x & 0xFF00000000000000000000000 > 0 { 
        if x & 0x8000000000000000000000000 > 0 {
            result = math::mul_div(result, 0x16A09E667F3BCC908B2FB1366F, Q100);
        }
        if x & 0x4000000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1306FE0A31B7152DE8D5A46306, Q100);
        }
        if x & 0x2000000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1172B83C7D517ADCDF7C8C50EB, Q100);
        }
        if x & 0x1000000000000000000000000 > 0 {
            result = math::mul_div(result, 0x10B5586CF9890F6298B92B7184, Q100);
        }
        if x & 0x800000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1059B0D31585743AE7C548EB69, Q100);
        }
        if x & 0x400000000000000000000000 > 0 {
            result = math::mul_div(result, 0x102C9A3E778060EE6F7CACA4F8, Q100);
        }
        if x & 0x200000000000000000000000 > 0 {
            result = math::mul_div(result, 0x10163DA9FB33356D84A66AE337, Q100); 
        }
        if x & 0x100000000000000000000000 > 0 {
            result = math::mul_div(result, 0x100B1AFA5ABCBED6129AB13EC1, Q100); 
        }
    }

    if x & 0xFF000000000000000000000 > 0 {
        if x & 0x80000000000000000000000 > 0 {
            result = math::mul_div(result, 0x10058C86DA1C09EA1FF19D294D, Q100); 
        }
        if x & 0x40000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1002C605E2E8CEC506D21BFC8A, Q100);
        }
        if x & 0x20000000000000000000000 > 0 {
            result = math::mul_div(result, 0x100162F3904051FA128BCA9C56, Q100);
        }
        if x & 0x10000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000B175EFFDC76BA38E31671D, Q100);
        }
        if x & 0x8000000000000000000000 > 0 {
            result = math::mul_div(result, 0x100058BA01FB9F96D6CACD4B18, Q100);
        }
        if x & 0x4000000000000000000000 > 0 {
            result = math::mul_div(result, 0x10002C5CC37DA9491D0985C349, Q100);
        }
        if x & 0x2000000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000162E525EE054754457D599, Q100);
        }
        if x & 0x1000000000000000000000 > 0 {
            result = math::mul_div(result, 0x10000B17255775C040618BF4A5, Q100);
        }
    }

    if x & 0xFF0000000000000000000 > 0 {
        if x & 0x800000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000058B91B5BC9AE2EED81E9B, Q100);
        }
        if x & 0x400000000000000000000 > 0 {
            result = math::mul_div(result, 0x100002C5C89D5EC6CA4D7C8ACC, Q100); 
        }
        if x & 0x200000000000000000000 > 0 {
            result = math::mul_div(result, 0x10000162E43F4F831060E02D84, Q100); 
        }
        if x & 0x100000000000000000000 > 0 {
            result = math::mul_div(result, 0x100000B1721BCFC99D9F890EA0, Q100);
        }
        if x & 0x80000000000000000000 > 0 {
            result = math::mul_div(result, 0x10000058B90CF1E6D97F9CA14E, Q100); 
        }
        if x & 0x40000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000002C5C863B73F016468F6C, Q100);
        }
        if x & 0x20000000000000000000 > 0 {
            result = math::mul_div(result, 0x100000162E430E5A18F6119E3C, Q100);
        }
        if x & 0x10000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000B1721835514B86E6D97, Q100); 
        }
    }

    if x & 0xFF00000000000000000 > 0 {
        if x & 0x8000000000000000000 > 0 {
            result = math::mul_div(result, 0x100000058B90C0B48C6BE5DF84, Q100);
        }
        if x & 0x4000000000000000000 > 0 {
            result = math::mul_div(result, 0x10000002C5C8601CC6B9E94214, Q100);
        }
        if x & 0x2000000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000162E42FFF037DF38AA3, Q100);
        }
        if x & 0x1000000000000000000 > 0 {
            result = math::mul_div(result, 0x10000000B17217FBA9C739AA58, Q100);
        }
        if x & 0x800000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000058B90BFCDEE5ACD3C2, Q100);
        }
        if x & 0x400000000000000000 > 0 {
            result = math::mul_div(result, 0x100000002C5C85FE31F35A6A31, Q100);
        }
        if x & 0x200000000000000000 > 0 {
            result = math::mul_div(result, 0x10000000162E42FF0999CE3542, Q100);
        }
        if x & 0x100000000000000000 > 0 {
            result = math::mul_div(result, 0x100000000B17217F80F4EF5AAE, Q100);
        }
    }

    if x & 0xFF000000000000000 > 0 {
        if x & 0x80000000000000000 > 0 {
            result = math::mul_div(result, 0x10000000058B90BFBF8479BD5B, Q100);
        }
        if x & 0x40000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000002C5C85FDF84BD62AE, Q100);
        }
        if x & 0x20000000000000000 > 0 {
            result = math::mul_div(result, 0x100000000162E42FEFB2FED257, Q100);
        }
        if x & 0x10000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000B17217F7D5A7716C, Q100);
        }
        if x & 0x8000000000000000 > 0 {
            result = math::mul_div(result, 0x100000000058B90BFBE9DDBAC6, Q100);
        }
        if x & 0x4000000000000000 > 0 {
            result = math::mul_div(result, 0x10000000002C5C85FDF4B15DE7, Q100);
        }
        if x & 0x2000000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000162E42FEFA494F14, Q100);
        }
        if x & 0x1000000000000000 > 0 {
            result = math::mul_div(result, 0x10000000000B17217F7D20CF92, Q100);
        }
    }

    if x & 0xFF0000000000000 > 0 {
        if x & 0x800000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000058B90BFBE8F71CB, Q100);
        }
        if x & 0x400000000000000 > 0 {
            result = math::mul_div(result, 0x100000000002C5C85FDF477B66, Q100);
        }
        if x & 0x200000000000000 > 0 {
            result = math::mul_div(result, 0x10000000000162E42FEFA3AE53, Q100);
        }
        if x & 0x100000000000000 > 0 {
            result = math::mul_div(result, 0x100000000000B17217F7D1D352, Q100);
        }
        if x & 0x80000000000000 > 0 {
            result = math::mul_div(result, 0x10000000000058B90BFBE8E8B3, Q100);
        }
        if x & 0x40000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000002C5C85FDF4741C, Q100);
        }
        if x & 0x20000000000000 > 0 {
            result = math::mul_div(result, 0x100000000000162E42FEFA39FF, Q100);
        }
        if x & 0x10000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000B17217F7D1CFB, Q100);
        }
    }

    if x & 0xFF00000000000 > 0 {
        if x & 0x8000000000000 > 0 {
            result = math::mul_div(result, 0x100000000000058B90BFBE8E7D, Q100);
        }
        if x & 0x4000000000000 > 0 {
            result = math::mul_div(result, 0x10000000000002C5C85FDF473E, Q100);
        }
        if x & 0x2000000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000162E42FEFA39F, Q100);
        }
        if x & 0x1000000000000 > 0 {
            result = math::mul_div(result, 0x10000000000000B17217F7D1CF, Q100);
        }
        if x & 0x800000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000058B90BFBE8E8, Q100);
        }
        if x & 0x400000000000 > 0 {
            result = math::mul_div(result, 0x100000000000002C5C85FDF474, Q100);
        }
        if x & 0x200000000000 > 0 {
            result = math::mul_div(result, 0x10000000000000162E42FEFA3A, Q100);
        }
        if x & 0x100000000000 > 0 {
            result = math::mul_div(result, 0x100000000000000B17217F7D1D, Q100);
        }
    }

    if x & 0xFF000000000 > 0 {
        if x & 0x80000000000 > 0 {
            result = math::mul_div(result, 0x10000000000000058B90BFBE8E, Q100);
        }
        if x & 0x40000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000002C5C85FDF47, Q100);
        }
        if x & 0x20000000000 > 0 {
            result = math::mul_div(result, 0x100000000000000162E42FEFA4, Q100);
        }
        if x & 0x10000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000B17217F7D2, Q100);
        }
        if x & 0x8000000000 > 0 {
            result = math::mul_div(result, 0x100000000000000058B90BFBE9, Q100);
        }
        if x & 0x4000000000 > 0 {
            result = math::mul_div(result, 0x10000000000000002C5C85FDF4, Q100);
        }
        if x & 0x2000000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000162E42FEFA, Q100);
        }
        if x & 0x1000000000 > 0 {
            result = math::mul_div(result, 0x10000000000000000B17217F7D, Q100);
        }
    }

    if x & 0xFF0000000 > 0 {
        if x & 0x800000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000058B90BFBF, Q100);
        }
        if x & 0x400000000 > 0 {
            result = math::mul_div(result, 0x100000000000000002C5C85FDF, Q100);
        }
        if x & 0x200000000 > 0 {
            result = math::mul_div(result, 0x10000000000000000162E42FF0, Q100);
        }
        if x & 0x100000000 > 0 {
            result = math::mul_div(result, 0x100000000000000000B17217F8, Q100);
        }
        if x & 0x80000000 > 0 {
            result = math::mul_div(result, 0x10000000000000000058B90BFC, Q100);
        }
        if x & 0x40000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000002C5C85FE, Q100);
        }
        if x & 0x20000000 > 0 {
            result = math::mul_div(result, 0x100000000000000000162E42FF, Q100);
        }
        if x & 0x10000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000B17217F, Q100);
        }
    }

    if x & 0xFF00000 > 0 {
        if x & 0x8000000 > 0 {
            result = math::mul_div(result, 0x100000000000000000058B90C0, Q100);
        }
        if x & 0x4000000 > 0 {
            result = math::mul_div(result, 0x10000000000000000002C5C860, Q100);
        }
        if x & 0x2000000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000162E430, Q100);
        }
        if x & 0x1000000 > 0 {
            result = math::mul_div(result, 0x10000000000000000000B17218, Q100);
        }
        if x & 0x800000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000058B90C, Q100);
        }
        if x & 0x400000 > 0 {
            result = math::mul_div(result, 0x100000000000000000002C5C86, Q100);
        }
        if x & 0x200000 > 0 {
            result = math::mul_div(result, 0x10000000000000000000162E43, Q100);
        }
        if x & 0x100000 > 0 {
            result = math::mul_div(result, 0x100000000000000000000B1721, Q100);
        }
    }

    if x & 0xFF000 > 0 {
        if x & 0x80000 > 0 {
            result = math::mul_div(result, 0x10000000000000000000058B91, Q100);
        }
        if x & 0x40000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000002C5C8, Q100);
        }
        if x & 0x20000 > 0 {
            result = math::mul_div(result, 0x100000000000000000000162E4, Q100);
        }
        if x & 0x10000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000000B172, Q100);
        }
        if x & 0x8000 > 0 {
            result = math::mul_div(result, 0x100000000000000000000058B9, Q100);
        }
        if x & 0x4000 > 0 {
            result = math::mul_div(result, 0x10000000000000000000002C5D, Q100);
        }
        if x & 0x2000 > 0 {
            result = math::mul_div(result, 0x1000000000000000000000162E, Q100);
        }
        if x & 0x1000 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000B17, Q100);
        }
    }

    if x & 0xFF0 > 0 {
        if x & 0x800 > 0 {
            result = math::mul_div(result, 0x1000000000000000000000058C, Q100);
        }
        if x & 0x400 > 0 {
            result = math::mul_div(result, 0x100000000000000000000002C6, Q100);
        }
        if x & 0x200 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000163, Q100);
        }
        if x & 0x100 > 0 {
            result = math::mul_div(result, 0x100000000000000000000000B1, Q100);
        }
        if x & 0x80 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000059, Q100);
        }
        if x & 0x40 > 0 {
            result = math::mul_div(result, 0x1000000000000000000000002C, Q100);
        }
        if x & 0x20 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000016, Q100);
        }
        if x & 0x10 > 0 {
            result = math::mul_div(result, 0x1000000000000000000000000B, Q100);
        }
    }

    if x & 0xF > 0 {
        if x & 0x8 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000006, Q100);
        }
        if x & 0x4 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000003, Q100);
        }
        if x & 0x2 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000001, Q100);
        }
        if x & 0x1 > 0 {
            result = math::mul_div(result, 0x10000000000000000000000001, Q100);
        }
    }

    // Convert back into an unsigned 60.18-decimal fixed-point format.
    result = math::mul_div(result, ONE, math::pow(2, 155 - (x / Q100)));
    result
}

// Calculates the square root of x.
//
// # Arguments
// * `x` - The number to calculate the square root of.
//
// # Returns
// * `result` - The square root of x.
fn sqrt(x: u256) -> u256 {
    if x == 0 {
        return 0;
    }

    let mut x_aux = x.clone();
    let mut result = 1;
    if x_aux >= Q128 {
        x_aux /= Q128;
        result *= Q64;
    }
    if x_aux >= Q64 {
        x_aux /= Q64;
        result *= Q32;
    }
    if (x_aux >= Q32) {
        x_aux /= Q32;
        result *= Q16;
    }
    if (x_aux >= Q16) {
        x_aux /= Q16;
        result *= 256;
    }
    if (x_aux >= 256) {
        x_aux /= 256;
        result *= 16;
    }
    if (x_aux >= 16) {
        x_aux /= 16;
        result *= 4;
    }
    if (x_aux >= 4) {
        result *= 2;
    }

    result = (result + x / result) / 2;
    result = (result + x / result) / 2;
    result = (result + x / result) / 2;
    result = (result + x / result) / 2;
    result = (result + x / result) / 2;
    result = (result + x / result) / 2;
    result = (result + x / result) / 2;

    // If x is not a perfect square, round the result toward zero.
    let rounded_result = x / result;
    
    min(result, rounded_result)
}