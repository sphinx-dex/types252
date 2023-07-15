use traits::{Into, TryInto, Rem};
use integer::{U32Mul, U32Div, U32Rem, u32_try_from_felt252, u32_overflowing_sub};
use option::OptionTrait;
use result::ResultTrait;
use hash::LegacyHash;

use types252::math::felt_math::{felt_abs, felt_sign};

////////////////////////////////
// TYPES
////////////////////////////////

#[derive(Copy, Drop, Serde, storage_access::StorageAccess)]
struct i32 {
    val: u32,
    sign: bool
}

////////////////////////////////
// METHODS
////////////////////////////////

trait I32Trait {
    fn new(val: u32, sign: bool) -> i32;
    fn one() -> i32;
}

impl I32Zeroable of Zeroable<i32> {
    #[inline(always)]
    fn zero() -> i32 {
        I32Trait::new(0_u32, false)
    }

    #[inline(always)]
    fn is_zero(self: i32) -> bool {
        self.val == 0_u32
    }
    
    #[inline(always)]
    fn is_non_zero(self: i32) -> bool {
        self.val != 0_u32
    }
}

impl I32Impl of I32Trait {
    #[inline(always)]
    fn new(val: u32, sign: bool) -> i32 {
        i32 { val, sign: if val == 0 { false } else { sign } }
    }

    #[inline(always)]
    fn one() -> i32 {
        I32Trait::new(1_u32, false)
    }
}

impl I32IntoFelt252 of Into<i32, felt252> {
    #[inline(always)]
    fn into(self: i32) -> felt252 {
        let mag_felt: felt252 = self.val.into();
        if self.sign {
            mag_felt * -1
        } else {
            mag_felt
        }
    }
}

impl Felt252TryIntoI32 of TryInto<felt252, i32> {
    #[inline(always)]
    fn try_into(self: felt252) -> Option<i32> {
        let option: Option<u32> = felt_abs(self).try_into();
        match option {
            Option::Some(val) => Option::Some(
                I32Trait::new(option.unwrap(), felt_sign(self))
            ),
            Option::None(()) => Option::<i32>::None(())
        }
    }
}

impl I32PartialOrd of PartialOrd<i32> {
    #[inline(always)]
    fn le(lhs: i32, rhs: i32) -> bool {
        if rhs.sign != lhs.sign {
            lhs.sign
        } else {
            if lhs.sign {
                lhs.val >= rhs.val
            } else {
                lhs.val <= rhs.val
            }
        }
    }
    #[inline(always)]
    fn ge(lhs: i32, rhs: i32) -> bool {
        if lhs.sign != rhs.sign {
            !lhs.sign
        } else {
            if lhs.sign {
                lhs.val <= rhs.val
            } else {
                lhs.val >= rhs.val
            }
        }
    }
    #[inline(always)]
    fn lt(lhs: i32, rhs: i32) -> bool {
        if lhs.sign != rhs.sign {
            lhs.sign
        } else {
            if lhs.sign {
                lhs.val > rhs.val
            } else {
                lhs.val < rhs.val
            }
        }
    }
    #[inline(always)]
    fn gt(lhs: i32, rhs: i32) -> bool {
        if lhs.sign != rhs.sign {
            !lhs.sign
        } else {
            if lhs.sign {
                lhs.val < rhs.val
            } else {
                lhs.val > rhs.val
            }
        }
    }
}

impl I32PartialEq of PartialEq<i32> {
    #[inline(always)]
    fn eq(lhs: @i32, rhs: @i32) -> bool {
        lhs.sign == rhs.sign && lhs.val == rhs.val
    }
    #[inline(always)]
    fn ne(lhs: @i32, rhs: @i32) -> bool {
        lhs.sign != rhs.sign || lhs.val != rhs.val
    }
}

impl LegacyHashI32 of LegacyHash<i32> {
    #[inline(always)]
    fn hash(state: felt252, value: i32) -> felt252 {
        LegacyHash::<felt252>::hash(state, value.into())
    }
}

impl I32Add of Add<i32> {
    #[inline(always)]
    fn add(lhs: i32, rhs: i32) -> i32 {
        if lhs.sign == rhs.sign {
            i32 { val: lhs.val + rhs.val, sign: lhs.sign }
        } else if lhs.sign {
            if lhs.val > rhs.val {
                i32 { val: lhs.val - rhs.val, sign: true }
            } else {
                i32 { val: rhs.val - lhs.val, sign: false }
            }
        } else {
            if lhs.val >= rhs.val {
                i32 { val: lhs.val - rhs.val, sign: false }
            } else {
                i32 { val: rhs.val - lhs.val, sign: true }
            }
        }
    }
}

impl I32Sub of Sub<i32> {
    #[inline(always)]
    fn sub(lhs: i32, rhs: i32) -> i32 {
        if lhs.sign == rhs.sign {
            if lhs.val > rhs.val {
                i32 { val: lhs.val - rhs.val, sign: lhs.sign }
            } else if lhs.val < rhs.val {
                i32 { val: rhs.val - lhs.val, sign: !lhs.sign }
            } else {
                i32 { val: 0, sign: false }
            }
        } else if lhs.sign {
            i32 { val: lhs.val + rhs.val, sign: true }
        } else {
            i32 { val: lhs.val + rhs.val, sign: false }
        }
    }
}

impl I32Mul of Mul<i32> {
    #[inline(always)]
    fn mul(lhs: i32, rhs: i32) -> i32 {
        let res_sign: bool = lhs.sign ^ rhs.sign;
        let mag: u32 = U32Mul::mul(lhs.val, rhs.val);
        I32Trait::new(mag, res_sign)
    }
}

impl I32Div of Div<i32> {
    #[inline(always)]
    fn div(lhs: i32, rhs: i32) -> i32 {
        let res_sign = lhs.sign ^ rhs.sign;
        let mag: u32 = U32Div::div(lhs.val, rhs.val);
        I32Trait::new(mag, res_sign)
    }
}

impl I32Rem of Rem<i32> {
    #[inline(always)]
    fn rem(lhs: i32, rhs: i32) -> i32 {
        let res_sign = lhs.sign;
        let mag: u32 = U32Rem::rem(lhs.val, rhs.val);
        I32Trait::new(mag, res_sign)
    }
}

impl I32AddEq of AddEq<i32> {
    #[inline(always)]
    fn add_eq(ref self: i32, other: i32) {
        self = I32Add::add(self, other)
    }
}

impl I32SubEq of SubEq<i32> {
    #[inline(always)]
    fn sub_eq(ref self: i32, other: i32) {
        self = I32Sub::sub(self, other)
    }
}