use integer::{u256_wide_mul, u512_safe_div_rem_by_u256, u256_try_as_non_zero};
use integer::U256DivRem;
use option::OptionTrait;

// Raises u256 number to the power of exponent using the exponentiation by squaring algorithm.
// 
// # Arguments
// * `base` - The base number.
// * `exp` - The exponent.
//
// # Returns
// * `u256` - The result of the exponentiation.
fn pow(base: u256, exp: u256) -> u256 {
    if exp == 0 {
        1
    } else if exp == 1 {
        base
    }
    else if exp % 2 == 0{
        let half = pow(base, exp / 2);
        half * half
    }
    else {
        base * pow(base, exp - 1)
    }
}

// Multiplies two u256 numbers and divides the result by a third.
//
// # Arguments
// * `a` - The first multiplicand.
// * `b` - The second multiplicand.
// * `c` - The divisor.
//
// # Returns
// * `result` - Result.
fn mul_div(a: u256, b: u256, c: u256) -> u256 {
    let product = u256_wide_mul(a, b);
    let (q, _) = u512_safe_div_rem_by_u256(
        product, 
        u256_try_as_non_zero(c).expect('mul_div by zero')
    );
    assert(q.limb2 == 0 && q.limb3 == 0, 'mul_div u256 overflow');
    u256 { low: q.limb0, high: q.limb1 }
}