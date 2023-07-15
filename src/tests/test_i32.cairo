use integer::BoundedU32;

use types252::types::i32::{i32, I32Trait};

#[test]
#[available_gas(2000000000)]
fn test_i32_new() {
    let mut x = I32Trait::new(0, false);
    assert(x.val == 0 && x.sign == false, 'i32 new(0)');

    x = I32Trait::new(0, true);
    assert(x.val == 0 && x.sign == false, 'i32 new(0)');
}

// #[test]
#[available_gas(2000000000)]
// fn test_i32_is_zero() {

// }

// #[test]
#[available_gas(2000000000)]
// fn test_i32_eq() {

// }

#[test]
#[available_gas(2000000000)]
fn test_i32_eq() {
    let mut x = I32Trait::new(10, false);
    let mut y = I32Trait::new(10, false);
    assert(x == y, 'i32 eq(10, 10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, true);
    assert(x == y, 'i32 eq(-10, -10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, true);
    assert(x != y, 'i32 ne(10, -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, false);
    assert(x != y, 'i32 ne(-10, 10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(20, false);
    assert(x != y, 'i32 ne(10, 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i32_gt() {
    let mut x = I32Trait::new(20, false);
    let mut y = I32Trait::new(10, false);
    assert(x > y, 'i32 cmp(20 > 10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(20, true);
    assert(x > y, 'i32 cmp(-10 > -20)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, true);
    assert(x > y, 'i32 cmp(10 > -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, false);
    assert(!(x > y), 'i32 cmp(-10 > 10)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(10, false);
    assert(!(x < y), 'i32 cmp(20 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i32_lt() {
    let mut x = I32Trait::new(10, false);
    let mut y = I32Trait::new(20, false);
    assert(x < y, 'i32 cmp(10 < 20)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(10, true);
    assert(x < y, 'i32 cmp(-20 < -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, false);
    assert(x < y, 'i32 cmp(-10 < 10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, true);
    assert(!(x < y), 'i32 cmp(10 < -10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, false);
    assert(!(x < y), 'i32 cmp(10 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i32_le() {
    let mut x = I32Trait::new(10, false);
    let mut y = I32Trait::new(20, false);
    assert(x <= y, 'i32 cmp(10 <= 20)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(20, false);
    assert(x <= y, 'i32 cmp(20 <= 20)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(10, true);
    assert(x <= y, 'i32 cmp(-20 <= -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, true);
    assert(x <= y, 'i32 cmp(-10 <= -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, false);
    assert(x <= y, 'i32 cmp(-10 <= 10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, true);
    assert(!(x <= y), 'i32 cmp(10 <= -10)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(10, false);
    assert(!(x <= y), 'i32 cmp(20 <= 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i32_ge() {
    let mut x = I32Trait::new(20, false);
    let mut y = I32Trait::new(10, false);
    assert(x >= y, 'i32 cmp(20 >= 10)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(20, false);
    assert(x >= y, 'i32 cmp(20 >= 20)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(20, true);
    assert(x >= y, 'i32 cmp(-10 >= -20)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, true);
    assert(x >= y, 'i32 cmp(-10 >= -10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(10, true);
    assert(x >= y, 'i32 cmp(10 >= -10)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(10, false);
    assert(!(x >= y), 'i32 cmp(-10 >= 10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(20, false);
    assert(!(x >= y), 'i32 cmp(10 >= 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i32_add() {
    let mut x = I32Trait::new(10, false);
    let mut y = I32Trait::new(20, false);
    let mut result = x + y;
    assert(result.val == 30 && result.sign == false, 'i32 add(10, 20)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(20, true);
    result = x + y;
    assert(result.val == 30 && result.sign == true, 'i32 add(-10, -20)');

    x = I32Trait::new(30, false);
    y = I32Trait::new(20, true);
    result = x + y;
    assert(result.val == 10 && result.sign == false, 'i32 add(30, -20)');

    x = I32Trait::new(30, true);
    y = I32Trait::new(20, false);
    result = x + y;
    assert(result.val == 10 && result.sign == true, 'i32 add(-30, 20)');

    x = I32Trait::new(0, false);
    y = I32Trait::new(20, false);
    result = x + y;
    assert(result.val == 20 && result.sign == false, 'i32 add(0, 20)');

    x = I32Trait::new(0, true);
    y = I32Trait::new(20, true);
    result = x + y;
    assert(result.val == 20 && result.sign == true, 'i32 add(0, -20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i32_overflowing_add() {
    let x = I32Trait::new(BoundedU32::max(), false);
    let y = I32Trait::new(1, false);
    x + y;
}

#[test]
#[available_gas(2000000000)]
fn test_i32_sub() {
    let mut x = I32Trait::new(30, false);
    let mut y = I32Trait::new(20, false);
    let mut result = x - y;
    assert(result.val == 10 && result.sign == false, 'i32 sub(30, 20)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(30, true);
    result = x - y;
    assert(result.val == 10 && result.sign == false, 'i32 sub(-20, -30)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(30, true);
    result = x - y;
    assert(result.val == 50 && result.sign == false, 'i32 sub(20, -30)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(30, false);
    result = x - y;
    assert(result.val == 50 && result.sign == true, 'i32 sub(-20, 30)');

    x = I32Trait::new(0, false);
    y = I32Trait::new(20, false);
    result = x - y; 
    assert(result.val == 20 && result.sign == true, 'i32 sub(0, 20)');

    x = I32Trait::new(0, true);
    y = I32Trait::new(20, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i32 sub(0, -20)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(0, false);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i32 sub(20, 0)');

    x = I32Trait::new(20, false);
    y = I32Trait::new(0, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i32 sub(20, -0)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i32_overflowing_sub() {
    let x = I32Trait::new(BoundedU32::max(), true);
    let y = I32Trait::new(1, false);
    x - y;
}

#[test]
#[available_gas(2000000000)]
fn test_i32_mul() {
    let mut x = I32Trait::new(10, false);
    let mut y = I32Trait::new(20, false);
    let mut result = x * y;
    assert(result.val == 200 && result.sign == false, 'i32 mul(10, 20)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == false, 'i32 mul(-10, -20)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i32 mul(10, -20)');

    x = I32Trait::new(10, true);
    y = I32Trait::new(20, false);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i32 mul(-10, 20)');

    x = I32Trait::new(0, false);
    y = I32Trait::new(20, false);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i32 mul(0, 20)');

    x = I32Trait::new(0, true);
    y = I32Trait::new(20, true);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i32 mul(0, -20)');

    
    x = I32Trait::new(1, false);
    y = I32Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == false, 'i32 mul(1, 20)');

    x = I32Trait::new(1, true);
    y = I32Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == true, 'i32 mul(-1, 20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i32_overflowing_mul() {
    let x = I32Trait::new(BoundedU32::max(), true);
    let y = I32Trait::new(2, true);
    x * y;
}

#[test]
#[available_gas(2000000000)]
fn test_i32_div() {
    let mut x = I32Trait::new(20, false);
    let mut y = I32Trait::new(10, false);
    let mut result = x / y;
    assert(result.val == 2 && result.sign == false, 'i32 div(20, 10)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == false, 'i32 div(-20, -10)');

    x = I32Trait::new(20, false);  
    y = I32Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i32 div(20, -10)');

    x = I32Trait::new(20, true);
    y = I32Trait::new(10, false);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i32 div(-20, 10)');

    x = I32Trait::new(0, false);
    y = I32Trait::new(10, false);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i32 div(0, 10)');

    x = I32Trait::new(0, false);
    y = I32Trait::new(10, true);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i32 div(0, -10)');

    x = I32Trait::new(10, false);
    y = I32Trait::new(1, false);
    result = x / y;
    assert(result.val == 10 && result.sign == false, 'i32 div(10, 1)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i32_div_by_zero() {
    let x = I32Trait::new(10, false);
    let y = I32Trait::new(0, false);
    x / y;
}

// #[test]
// #[available_gas(2000000000)]
// fn test_i32_rem() {

// }

// #[test]
// #[available_gas(2000000000)]
// fn test_i32_conversion() {

// }