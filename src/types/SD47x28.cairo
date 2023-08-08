use clone::Clone;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use cmp::min;
use integer::Felt252IntoU256;
use integer::{u256_wide_mul, u512_safe_div_rem_by_u256, u256_as_non_zero, u256_try_as_non_zero};
use integer::{U256Mul, U256Div, U256Rem};

use types252::math::{bit_math, math, fixed_point_math};
use types252::math::fixed_point_math::{Q128, Q100, Q64, Q32, Q16};
use types252::constants::ONE;

use debug::PrintTrait;

////////////////////////////////
// TYPE
////////////////////////////////

// Represents a SD47x28 fixed point number.
#[derive(Serde, Drop, Copy, storage_access::StorageAccess)]
struct SD47x28 {
    val: felt252,
    sign: bool,
}

////////////////////////////////
// METHODS
////////////////////////////////

trait SD47x28Trait {
    fn new(val: u256, sign: bool) -> SD47x28;
    fn one() -> SD47x28;
}

impl SD47x28Zeroable of Zeroable<SD47x28> {
    #[inline(always)]
    fn zero() -> SD47x28 {
        SD47x28Trait::new(0_u256, false)
    }

    #[inline(always)]
    fn is_zero(self: SD47x28) -> bool {
        self.val == 0
    }
    
    #[inline(always)]
    fn is_non_zero(self: SD47x28) -> bool {
        self.val != 0
    }
}

impl SD47x28Impl of SD47x28Trait {
    #[inline(always)]
    fn new(val: u256, sign: bool) -> SD47x28 {
        SD47x28 { val: _to_felt(val), sign: if val == 0 { false } else { sign } }
    }

    #[inline(always)]
    fn one() -> SD47x28 {
        SD47x28 { val: _to_felt(ONE), sign: false }
    }
}

impl SD47x28PartialEq of PartialEq<SD47x28> {
    #[inline(always)]
    fn eq(lhs: @SD47x28, rhs: @SD47x28) -> bool {
        lhs.sign == rhs.sign && lhs.val == rhs.val
    }
    #[inline(always)]
    fn ne(lhs: @SD47x28, rhs: @SD47x28) -> bool {
        lhs.sign != rhs.sign || lhs.val != rhs.val
    }
}

impl SD47x28Add of Add<SD47x28> {
    #[inline(always)]
    fn add(lhs: SD47x28, rhs: SD47x28) -> SD47x28 {
        if lhs.sign == rhs.sign {
            SD47x28 { val: lhs.val + rhs.val, sign: lhs.sign }
        } else if lhs.sign {
            if Felt252IntoU256::into(lhs.val) > rhs.val.into() {
                SD47x28 { val: lhs.val - rhs.val, sign: true }
            } else {
                SD47x28 { val: rhs.val - lhs.val, sign: false }
            }
        } else {
            if Felt252IntoU256::into(lhs.val) >= rhs.val.into() {
                SD47x28 { val: lhs.val - rhs.val, sign: false }
            } else {
                SD47x28 { val: rhs.val - lhs.val, sign: true }
            }
        }
    }
}

impl SD47x28Sub of Sub<SD47x28> {
    #[inline(always)]
    fn sub(lhs: SD47x28, rhs: SD47x28) -> SD47x28 {
        if lhs.sign == rhs.sign {
            if Felt252IntoU256::into(lhs.val) > rhs.val.into() {
                SD47x28 { val: lhs.val - rhs.val, sign: lhs.sign }
            } else if Felt252IntoU256::into(lhs.val) < rhs.val.into() {
                SD47x28 { val: rhs.val - lhs.val, sign: !lhs.sign }
            } else {
                SD47x28 { val: 0, sign: false }
            }
        } else if lhs.sign {
            SD47x28 { val: lhs.val + rhs.val, sign: true }
        } else {
            SD47x28 { val: lhs.val + rhs.val, sign: false }
        }
    }
}

impl SD47x28Mul of Mul<SD47x28> {
    #[inline(always)]
    fn mul(lhs: SD47x28, rhs: SD47x28) -> SD47x28 {
        let res_sign: bool = lhs.sign ^ rhs.sign;
        let mag: u256 = U256Mul::mul(lhs.val.into(), rhs.val.into());
        SD47x28Trait::new(mag, res_sign)
    }
}

impl SD47x28Div of Div<SD47x28> {
    #[inline(always)]
    fn div(lhs: SD47x28, rhs: SD47x28) -> SD47x28 {
        let res_sign = lhs.sign ^ rhs.sign;
        let mag: u256 = U256Div::div(lhs.val.into(), rhs.val.into());
        SD47x28Trait::new(mag, res_sign)
    }
}

impl SD47x28Rem of Rem<SD47x28> {
    #[inline(always)]
    fn rem(lhs: SD47x28, rhs: SD47x28) -> SD47x28 {
        let res_sign = lhs.sign;
        let mag: u256 = U256Rem::rem(lhs.val.into(), rhs.val.into());
        SD47x28Trait::new(mag, res_sign)
    }
}

impl SD47x28AddEq of AddEq<SD47x28> {
    #[inline(always)]
    fn add_eq(ref self: SD47x28, other: SD47x28) {
        self = SD47x28Add::add(self, other)
    }
}

impl SD47x28SubEq of SubEq<SD47x28> {
    #[inline(always)]
    fn sub_eq(ref self: SD47x28, other: SD47x28) {
        self = SD47x28Sub::sub(self, other)
    }
}

impl I25MulEq of MulEq<SD47x28> {
    #[inline(always)]
    fn mul_eq(ref self: SD47x28, other: SD47x28) {
        self = SD47x28Mul::mul(self, other)
    }
}

impl SD47x28DivEq of DivEq<SD47x28> {
    #[inline(always)]
    fn div_eq(ref self: SD47x28, other: SD47x28) {
        self = SD47x28Div::div(self, other)
    }
}

// Helper function to unwrap UD47x28 representation in u256 to felt252.
fn _to_felt(val: u256) -> felt252 {
    val.try_into().expect('to_felt overflow')
}