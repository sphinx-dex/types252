// A partial implementation of UD47x28 fixed point, inspired by https://github.com/PaulRBerg/prb-math.
// A 47.28-bit fixed point number stores 47 bits for the integer part and 28 bits for the fractional part.
// It can be stored inside a single felt252.

use clone::Clone;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use cmp::min;
use integer::Felt252IntoU256;
use integer::{u256_wide_mul, u512_safe_div_rem_by_u256, u256_as_non_zero, u256_try_as_non_zero};

use types252::math::{bit_math, math, fixed_point_math};
use types252::math::fixed_point_math::{Q128, Q100, Q64, Q32, Q16};
use types252::constants::{
    ONE, HALF, ONE_SQUARED, BP, MAX_UD47x28, MAX_UNSCALED_UD47x28, MAX_WHOLE_UD47x28, MAX_EXP2_INPUT, LOG2_1_0001, E, PI
};

use debug::PrintTrait;

////////////////////////////////
// TYPE
////////////////////////////////

// Represents a UD47x28 fixed point number.
#[derive(Serde, Drop, Copy, storage_access::StorageAccess)]
struct UD47x28 {
    val: felt252,
}

////////////////////////////////
// METHODS
////////////////////////////////

trait UD47x28Trait {
    fn new(val: u256) -> UD47x28;
    fn new_unscaled(val: u256) -> UD47x28;
    fn one() -> UD47x28;
    fn pow(self: UD47x28, exp: UD47x28) -> UD47x28;
    fn pow_int(self: UD47x28, exp: UD47x28) -> UD47x28;
    fn exp2(self: UD47x28) -> UD47x28;
    fn sqrt(self: UD47x28) -> UD47x28;
    fn round(self: UD47x28) -> UD47x28;
    fn ceil(self: UD47x28) -> UD47x28;
    fn floor(self: UD47x28) -> UD47x28;
    fn log2(self: UD47x28) -> UD47x28;
}

impl UD47x28Impl of UD47x28Trait {
    // Creates new from u256 representation of a UD47x28 number.
    #[inline(always)]
    fn new(val: u256) -> UD47x28 {
        UD47x28 { val: _to_felt(val) }
    }

    // Creates new from u256.
    #[inline(always)]
    fn new_unscaled(val: u256) -> UD47x28 {
        assert(val.into() <= MAX_UNSCALED_UD47x28, 'Unscaled overflow');
        UD47x28 { val: _to_felt(val * ONE) }
    }

    // Returns ONE.
    #[inline(always)]
    fn one() -> UD47x28 {
        UD47x28 { val: _to_felt(ONE) }
    }

    // Raises number to the power of exponent.
    fn pow(self: UD47x28, exp: UD47x28) -> UD47x28 {
        let base: u256 = self.val.into();
        let exponent: u256 = exp.val.into();

        // If both `base` and `exponent` are zero, return `ONE`. If just `exponent` is zero, return 0.
        if base == 0 {
            return if exponent == 0 { UD47x28Trait::one() } else { UD47x28Zeroable::zero() };
        }
        // If `base` is `ONE`, return `ONE`.
        else if base == ONE {
            return UD47x28Trait::one();
        }

        // If `exponent` is zero, return `ONE`.
        if (exponent == 0) {
            return UD47x28Trait::one();
        }
        // If `exponent` is `ONE`, return `base`.
        else if (exponent == ONE) {
            return self;
        }

        // If `base` is greater than `ONE`, use the standard formula.
        if (base > ONE) {
            (self.log2() * exp).exp2()
        }
        // Conversely, if `base` is less than `ONE`, use the equivalent formula.
        else {
            let i = UD47x28Trait::new(ONE_SQUARED / base);
            let w = (i.log2() * exp).exp2();
            UD47x28Trait::new(ONE_SQUARED / w.val.into())
        }
    }

    // Raises number to the power of exponent, where the exponent is an integer.
    fn pow_int(self: UD47x28, exp: UD47x28) -> UD47x28 {
        assert(exp.val.into() % ONE == 0, 'UD47x28 pow_int exp not int');
        _pow_int_helper(self, exp)
    }

    // Calculates the binary exponent of number using the binary fraction method.
    fn exp2(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();

        // Numbers greater than or equal to 155e30 don't fit in the 156.100-bit format.
        assert(x <= MAX_EXP2_INPUT, 'UD47x28 exp2 overflow');

        // Convert x to the 156.100-bit fixed-point format.
        let x_156x100 = math::mul_div(x, Q100, ONE);

        // Pass x to the _exp2 function, which uses the 156.100-bit fixed-point number representation.
        UD47x28Trait::new(fixed_point_math::exp2(x_156x100))
    }

    // Calculates the square root of x using the Babylonian method.
    // Result is rounded toward zero. 
    fn sqrt(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();

        // Result must be less than MAX_UD47x28 / ONE.
        assert(x <= MAX_UD47x28 / ONE, 'UD47x28 sqrt overflow');

        // Calculate the square root of x using the Babylonian method.
        UD47x28Trait::new(fixed_point_math::sqrt(x * ONE))
    }

    fn round(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();
        assert(x < MAX_WHOLE_UD47x28, 'UD47x28 round overflow');

        let remainder: u256 = x % ONE;

        if remainder >= HALF {
            self + UD47x28Trait::new(ONE - remainder)
        } else {
            self - UD47x28Trait::new(remainder)
        }
    }

    // Yields the smallest whole number greater than or equal to x.
    fn ceil(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();
        assert(x <= MAX_WHOLE_UD47x28, 'UD47x28 ceil overflow');

        let remainder: u256 = x % ONE;

        let delta = ONE - remainder; 

        self + if remainder > 0 { UD47x28Trait::new(delta) } else { UD47x28Zeroable::zero() }
    }

    // Yields the largest whole number less than or equal to x.
    fn floor(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();

        let remainder: u256 = x % ONE;

        self - if remainder > 0 { UD47x28Trait::new(remainder) } else { UD47x28Zeroable::zero() }
    }

    // Calculates the binary logarithm of x using the iterative approximation algorithm.
    fn log2(self: UD47x28) -> UD47x28 {
        let x: u256 = self.val.into();

        assert(x >= ONE, 'UD47x28 log2 underflow');

        // Calculate the integer part of the logarithm.
        let n: u256 = bit_math::msb(x / ONE).into();

        // This is the integer part of the logarithm as a UD47x28 number. The operation can't overflow because n
        // n is at most 255 and UNIT is 1e18.
        let result_uint = n * ONE;

        // Calculate $y = x * 2^{-n}$.
        let y = x / math::pow(2, n);

        // If y is the unit number, the fractional part is zero.
        if (y == ONE) {
            return UD47x28Trait::new(result_uint);
        }

        // Calculate the fractional part via the iterative approximation.
        let delta = HALF;

        let final_result_uint = _log2_helper(y, result_uint, delta);
        
        UD47x28Trait::new(final_result_uint)
    }
}

impl UD47x28Add of Add<UD47x28> {
    #[inline(always)]
    fn add(lhs: UD47x28, rhs: UD47x28) -> UD47x28 {
        UD47x28 { val: lhs.val + rhs.val }
    }
}

impl UD47x28Sub of Sub<UD47x28> {
    #[inline(always)]
    fn sub(lhs: UD47x28, rhs: UD47x28) -> UD47x28 {
        UD47x28 { val: lhs.val - rhs.val }
    }
}

impl UD47x28Mul of Mul<UD47x28> {
    #[inline(always)]
    fn mul(lhs: UD47x28, rhs: UD47x28) -> UD47x28 {
        let product = u256_wide_mul(lhs.val.into(), rhs.val.into());
        let (q, _) = u512_safe_div_rem_by_u256(
            product, 
            u256_as_non_zero(ONE)
        );
        assert(q.limb2 == 0 && q.limb3 == 0, 'UD47x28 mul overflow');
        UD47x28 { val: _to_felt(u256 { low: q.limb0, high: q.limb1 }) }
    }
}

impl UD47x28Div of Div<UD47x28> {
    #[inline(always)]
    fn div(lhs: UD47x28, rhs: UD47x28) -> UD47x28 {
        let product = u256_wide_mul(lhs.val.into(), ONE);
        let (q, _) = u512_safe_div_rem_by_u256(
            product, 
            u256_try_as_non_zero(rhs.val.into()).expect('UD47x28 div by zero')
        );
        UD47x28 { val: _to_felt(u256 { low: q.limb0, high: q.limb1 }) }
    }
}

impl UD47x28Rem of Rem<UD47x28> {
    #[inline(always)]
    fn rem(lhs: UD47x28, rhs: UD47x28) -> UD47x28 {
        let floor = (lhs / rhs).floor();
        lhs - floor * rhs
    }
}

impl UD47x28AddEq of AddEq<UD47x28> {
    #[inline(always)]
    fn add_eq(ref self: UD47x28, other: UD47x28) {
        self = UD47x28Add::add(self, other)
    }
}

impl UD47x28SubEq of SubEq<UD47x28> {
    #[inline(always)]
    fn sub_eq(ref self: UD47x28, other: UD47x28) {
        self = UD47x28Sub::sub(self, other)
    }
}

impl UD47x28Zeroable of Zeroable<UD47x28> {
    #[inline(always)]
    fn zero() -> UD47x28 {
        UD47x28Trait::new(0)
    }

    #[inline(always)]
    fn is_zero(self: UD47x28) -> bool {
        self.val == 0
    }
    
    #[inline(always)]
    fn is_non_zero(self: UD47x28) -> bool {
        self.val != 0
    }
}

impl UD47x28PartialEq of PartialEq<UD47x28> {
    #[inline(always)]
    fn eq(lhs: @UD47x28, rhs: @UD47x28) -> bool {
        lhs.val == rhs.val
    }
    #[inline(always)]
    fn ne(lhs: @UD47x28, rhs: @UD47x28) -> bool {
        lhs.val != rhs.val
    }
}

impl UD47x28IntoU256 of Into<UD47x28, u256> {
    #[inline(always)]
    fn into(self: UD47x28) -> u256 {
        self.val.into() / ONE
    }
}

impl UD47x28IntoFelt252 of Into<UD47x28, felt252> {
    #[inline(always)]
    fn into(self: UD47x28) -> felt252 {
        _to_felt(self.val.into() / ONE)
    }
}

impl Felt252IntoUD47x28 of Into<felt252, UD47x28> {
    #[inline(always)]
    fn into(self: felt252) -> UD47x28 {
        UD47x28Trait::new_unscaled(self.into())
    }
}

impl U256IntoUD47x28 of Into<u256, UD47x28> {
    #[inline(always)]
    fn into(self: u256) -> UD47x28 {
        UD47x28Trait::new_unscaled(self)
    }
}

impl U64IntoUD47x28 of Into<u64, UD47x28> {
    #[inline(always)]
    fn into(self: u64) -> UD47x28 {
        UD47x28Trait::new_unscaled(
            u256 { low: self.into(), high: 0 }
        )
    }
}

impl U32IntoUD47x28 of Into<u32, UD47x28> {
    #[inline(always)]
    fn into(self: u32) -> UD47x28 {
        UD47x28Trait::new_unscaled(
            u256 { low: self.into(), high: 0 }
        )
    }
}

impl U16IntoUD47x28 of Into<u16, UD47x28> {
    #[inline(always)]
    fn into(self: u16) -> UD47x28 {
        UD47x28Trait::new_unscaled(
            u256 { low: self.into(), high: 0 }
        )
    }
}

////////////////////////////////
// INTERNAL
////////////////////////////////

// Helper function to recursively calculate the power.
fn _pow_int_helper(self: UD47x28, exp: UD47x28) -> UD47x28 {
    if exp.val == 0 {
        UD47x28Trait::one()
    } else if exp.val.into() == ONE {
        self
    } else if exp % UD47x28Trait::new_unscaled(2) == UD47x28Zeroable::zero() {
        let half = _pow_int_helper(self, exp / UD47x28Trait::new_unscaled(2));
        half * half
    } else {
        self * _pow_int_helper(self, exp - UD47x28Trait::one())
    }
}

// Helper function to recursively calculate the logarithm.
fn _log2_helper(
    y: u256,
    result_uint: u256,
    delta: u256,
) -> u256 {
    if delta <= 0 {
        result_uint
    } else {
        let mut y = (y * y) / ONE;
        let mut result_uint = result_uint;
        if y >= 2 * ONE {
            result_uint += delta;
            y /= 2;
        }
        _log2_helper(y, result_uint, delta / 2)
    }
    
}

// Helper function to unwrap UD47x28 representation in u256 to felt252.
fn _to_felt(val: u256) -> felt252 {
    val.try_into().expect('to_felt overflow')
}