use integer::BoundedU128;

use types252::types::i128::{i128, I128Trait};

#[test]
#[available_gas(2000000000)]
fn test_i128_new() {
    let mut x = I128Trait::new(0, false);
    assert(x.val == 0 && x.sign == false, 'i128 new(0)');

    x = I128Trait::new(0, true);
    assert(x.val == 0 && x.sign == false, 'i128 new(0)');
}

// #[test]
#[available_gas(2000000000)]
// fn test_i128_is_zero() {

// }

// #[test]
#[available_gas(2000000000)]
// fn test_i128_eq() {

// }

#[test]
#[available_gas(2000000000)]
fn test_i128_eq() {
    let mut x = I128Trait::new(10, false);
    let mut y = I128Trait::new(10, false);
    assert(x == y, 'i128 eq(10, 10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, true);
    assert(x == y, 'i128 eq(-10, -10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, true);
    assert(x != y, 'i128 ne(10, -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, false);
    assert(x != y, 'i128 ne(-10, 10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(20, false);
    assert(x != y, 'i128 ne(10, 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i128_gt() {
    let mut x = I128Trait::new(20, false);
    let mut y = I128Trait::new(10, false);
    assert(x > y, 'i128 cmp(20 > 10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(20, true);
    assert(x > y, 'i128 cmp(-10 > -20)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, true);
    assert(x > y, 'i128 cmp(10 > -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, false);
    assert(!(x > y), 'i128 cmp(-10 > 10)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(10, false);
    assert(!(x < y), 'i128 cmp(20 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i128_lt() {
    let mut x = I128Trait::new(10, false);
    let mut y = I128Trait::new(20, false);
    assert(x < y, 'i128 cmp(10 < 20)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(10, true);
    assert(x < y, 'i128 cmp(-20 < -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, false);
    assert(x < y, 'i128 cmp(-10 < 10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, true);
    assert(!(x < y), 'i128 cmp(10 < -10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, false);
    assert(!(x < y), 'i128 cmp(10 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i128_le() {
    let mut x = I128Trait::new(10, false);
    let mut y = I128Trait::new(20, false);
    assert(x <= y, 'i128 cmp(10 <= 20)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(20, false);
    assert(x <= y, 'i128 cmp(20 <= 20)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(10, true);
    assert(x <= y, 'i128 cmp(-20 <= -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, true);
    assert(x <= y, 'i128 cmp(-10 <= -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, false);
    assert(x <= y, 'i128 cmp(-10 <= 10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, true);
    assert(!(x <= y), 'i128 cmp(10 <= -10)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(10, false);
    assert(!(x <= y), 'i128 cmp(20 <= 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i128_ge() {
    let mut x = I128Trait::new(20, false);
    let mut y = I128Trait::new(10, false);
    assert(x >= y, 'i128 cmp(20 >= 10)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(20, false);
    assert(x >= y, 'i128 cmp(20 >= 20)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(20, true);
    assert(x >= y, 'i128 cmp(-10 >= -20)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, true);
    assert(x >= y, 'i128 cmp(-10 >= -10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(10, true);
    assert(x >= y, 'i128 cmp(10 >= -10)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(10, false);
    assert(!(x >= y), 'i128 cmp(-10 >= 10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(20, false);
    assert(!(x >= y), 'i128 cmp(10 >= 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i128_add() {
    let mut x = I128Trait::new(10, false);
    let mut y = I128Trait::new(20, false);
    let mut result = x + y;
    assert(result.val == 30 && result.sign == false, 'i128 add(10, 20)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(20, true);
    result = x + y;
    assert(result.val == 30 && result.sign == true, 'i128 add(-10, -20)');

    x = I128Trait::new(30, false);
    y = I128Trait::new(20, true);
    result = x + y;
    assert(result.val == 10 && result.sign == false, 'i128 add(30, -20)');

    x = I128Trait::new(30, true);
    y = I128Trait::new(20, false);
    result = x + y;
    assert(result.val == 10 && result.sign == true, 'i128 add(-30, 20)');

    x = I128Trait::new(0, false);
    y = I128Trait::new(20, false);
    result = x + y;
    assert(result.val == 20 && result.sign == false, 'i128 add(0, 20)');

    x = I128Trait::new(0, true);
    y = I128Trait::new(20, true);
    result = x + y;
    assert(result.val == 20 && result.sign == true, 'i128 add(0, -20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i128_overflowing_add() {
    let x = I128Trait::new(BoundedU128::max(), false);
    let y = I128Trait::new(1, false);
    x + y;
}

#[test]
#[available_gas(2000000000)]
fn test_i128_sub() {
    let mut x = I128Trait::new(30, false);
    let mut y = I128Trait::new(20, false);
    let mut result = x - y;
    assert(result.val == 10 && result.sign == false, 'i128 sub(30, 20)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(30, true);
    result = x - y;
    assert(result.val == 10 && result.sign == false, 'i128 sub(-20, -30)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(30, true);
    result = x - y;
    assert(result.val == 50 && result.sign == false, 'i128 sub(20, -30)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(30, false);
    result = x - y;
    assert(result.val == 50 && result.sign == true, 'i128 sub(-20, 30)');

    x = I128Trait::new(0, false);
    y = I128Trait::new(20, false);
    result = x - y; 
    assert(result.val == 20 && result.sign == true, 'i128 sub(0, 20)');

    x = I128Trait::new(0, true);
    y = I128Trait::new(20, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i128 sub(0, -20)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(0, false);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i128 sub(20, 0)');

    x = I128Trait::new(20, false);
    y = I128Trait::new(0, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i128 sub(20, -0)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i128_overflowing_sub() {
    let x = I128Trait::new(BoundedU128::max(), true);
    let y = I128Trait::new(1, false);
    x - y;
}

#[test]
#[available_gas(2000000000)]
fn test_i128_mul() {
    let mut x = I128Trait::new(10, false);
    let mut y = I128Trait::new(20, false);
    let mut result = x * y;
    assert(result.val == 200 && result.sign == false, 'i128 mul(10, 20)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == false, 'i128 mul(-10, -20)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i128 mul(10, -20)');

    x = I128Trait::new(10, true);
    y = I128Trait::new(20, false);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i128 mul(-10, 20)');

    x = I128Trait::new(0, false);
    y = I128Trait::new(20, false);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i128 mul(0, 20)');

    x = I128Trait::new(0, true);
    y = I128Trait::new(20, true);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i128 mul(0, -20)');

    
    x = I128Trait::new(1, false);
    y = I128Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == false, 'i128 mul(1, 20)');

    x = I128Trait::new(1, true);
    y = I128Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == true, 'i128 mul(-1, 20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i128_overflowing_mul() {
    let x = I128Trait::new(BoundedU128::max(), true);
    let y = I128Trait::new(2, true);
    x * y;
}

#[test]
#[available_gas(2000000000)]
fn test_i128_div() {
    let mut x = I128Trait::new(20, false);
    let mut y = I128Trait::new(10, false);
    let mut result = x / y;
    assert(result.val == 2 && result.sign == false, 'i128 div(20, 10)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == false, 'i128 div(-20, -10)');

    x = I128Trait::new(20, false);  
    y = I128Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i128 div(20, -10)');

    x = I128Trait::new(20, true);
    y = I128Trait::new(10, false);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i128 div(-20, 10)');

    x = I128Trait::new(0, false);
    y = I128Trait::new(10, false);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i128 div(0, 10)');

    x = I128Trait::new(0, false);
    y = I128Trait::new(10, true);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i128 div(0, -10)');

    x = I128Trait::new(10, false);
    y = I128Trait::new(1, false);
    result = x / y;
    assert(result.val == 10 && result.sign == false, 'i128 div(10, 1)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i128_div_by_zero() {
    let x = I128Trait::new(10, false);
    let y = I128Trait::new(0, false);
    x / y;
}

// #[test]
// fn test_i128_rem() {

// }

// #[test]
// fn test_i128_conversion() {

// }