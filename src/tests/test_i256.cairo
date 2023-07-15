use integer::BoundedU256;

use types252::types::i256::{i256, I256Trait};

#[test]
#[available_gas(2000000000)]
fn test_i256_new() {
    let mut x = I256Trait::new(0, false);
    assert(x.val == 0 && x.sign == false, 'i256 new(0)');

    x = I256Trait::new(0, true);
    assert(x.val == 0 && x.sign == false, 'i256 new(0)');
}

// #[test]
#[available_gas(2000000000)]
// fn test_i256_is_zero() {

// }

// #[test]
#[available_gas(2000000000)]
// fn test_i256_eq() {

// }

#[test]
#[available_gas(2000000000)]
fn test_i256_eq() {
    let mut x = I256Trait::new(10, false);
    let mut y = I256Trait::new(10, false);
    assert(x == y, 'i256 eq(10, 10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, true);
    assert(x == y, 'i256 eq(-10, -10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, true);
    assert(x != y, 'i256 ne(10, -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, false);
    assert(x != y, 'i256 ne(-10, 10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(20, false);
    assert(x != y, 'i256 ne(10, 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i256_gt() {
    let mut x = I256Trait::new(20, false);
    let mut y = I256Trait::new(10, false);
    assert(x > y, 'i256 cmp(20 > 10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(20, true);
    assert(x > y, 'i256 cmp(-10 > -20)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, true);
    assert(x > y, 'i256 cmp(10 > -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, false);
    assert(!(x > y), 'i256 cmp(-10 > 10)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(10, false);
    assert(!(x < y), 'i256 cmp(20 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i256_lt() {
    let mut x = I256Trait::new(10, false);
    let mut y = I256Trait::new(20, false);
    assert(x < y, 'i256 cmp(10 < 20)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(10, true);
    assert(x < y, 'i256 cmp(-20 < -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, false);
    assert(x < y, 'i256 cmp(-10 < 10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, true);
    assert(!(x < y), 'i256 cmp(10 < -10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, false);
    assert(!(x < y), 'i256 cmp(10 < 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i256_le() {
    let mut x = I256Trait::new(10, false);
    let mut y = I256Trait::new(20, false);
    assert(x <= y, 'i256 cmp(10 <= 20)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(20, false);
    assert(x <= y, 'i256 cmp(20 <= 20)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(10, true);
    assert(x <= y, 'i256 cmp(-20 <= -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, true);
    assert(x <= y, 'i256 cmp(-10 <= -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, false);
    assert(x <= y, 'i256 cmp(-10 <= 10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, true);
    assert(!(x <= y), 'i256 cmp(10 <= -10)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(10, false);
    assert(!(x <= y), 'i256 cmp(20 <= 10)');
}

#[test]
#[available_gas(2000000000)]
fn test_i256_ge() {
    let mut x = I256Trait::new(20, false);
    let mut y = I256Trait::new(10, false);
    assert(x >= y, 'i256 cmp(20 >= 10)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(20, false);
    assert(x >= y, 'i256 cmp(20 >= 20)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(20, true);
    assert(x >= y, 'i256 cmp(-10 >= -20)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, true);
    assert(x >= y, 'i256 cmp(-10 >= -10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(10, true);
    assert(x >= y, 'i256 cmp(10 >= -10)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(10, false);
    assert(!(x >= y), 'i256 cmp(-10 >= 10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(20, false);
    assert(!(x >= y), 'i256 cmp(10 >= 20)');
}

#[test]
#[available_gas(2000000000)]
fn test_i256_add() {
    let mut x = I256Trait::new(10, false);
    let mut y = I256Trait::new(20, false);
    let mut result = x + y;
    assert(result.val == 30 && result.sign == false, 'i256 add(10, 20)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(20, true);
    result = x + y;
    assert(result.val == 30 && result.sign == true, 'i256 add(-10, -20)');

    x = I256Trait::new(30, false);
    y = I256Trait::new(20, true);
    result = x + y;
    assert(result.val == 10 && result.sign == false, 'i256 add(30, -20)');

    x = I256Trait::new(30, true);
    y = I256Trait::new(20, false);
    result = x + y;
    assert(result.val == 10 && result.sign == true, 'i256 add(-30, 20)');

    x = I256Trait::new(0, false);
    y = I256Trait::new(20, false);
    result = x + y;
    assert(result.val == 20 && result.sign == false, 'i256 add(0, 20)');

    x = I256Trait::new(0, true);
    y = I256Trait::new(20, true);
    result = x + y;
    assert(result.val == 20 && result.sign == true, 'i256 add(0, -20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i256_overflowing_add() {
    let x = I256Trait::new(BoundedU256::max(), false);
    let y = I256Trait::new(1, false);
    x + y;
}

#[test]
#[available_gas(2000000000)]
fn test_i256_sub() {
    let mut x = I256Trait::new(30, false);
    let mut y = I256Trait::new(20, false);
    let mut result = x - y;
    assert(result.val == 10 && result.sign == false, 'i256 sub(30, 20)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(30, true);
    result = x - y;
    assert(result.val == 10 && result.sign == false, 'i256 sub(-20, -30)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(30, true);
    result = x - y;
    assert(result.val == 50 && result.sign == false, 'i256 sub(20, -30)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(30, false);
    result = x - y;
    assert(result.val == 50 && result.sign == true, 'i256 sub(-20, 30)');

    x = I256Trait::new(0, false);
    y = I256Trait::new(20, false);
    result = x - y; 
    assert(result.val == 20 && result.sign == true, 'i256 sub(0, 20)');

    x = I256Trait::new(0, true);
    y = I256Trait::new(20, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i256 sub(0, -20)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(0, false);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i256 sub(20, 0)');

    x = I256Trait::new(20, false);
    y = I256Trait::new(0, true);
    result = x - y;
    assert(result.val == 20 && result.sign == false, 'i256 sub(20, -0)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i256_overflowing_sub() {
    let x = I256Trait::new(BoundedU256::max(), true);
    let y = I256Trait::new(1, false);
    x - y;
}

#[test]
#[available_gas(2000000000)]
fn test_i256_mul() {
    let mut x = I256Trait::new(10, false);
    let mut y = I256Trait::new(20, false);
    let mut result = x * y;
    assert(result.val == 200 && result.sign == false, 'i256 mul(10, 20)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == false, 'i256 mul(-10, -20)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(20, true);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i256 mul(10, -20)');

    x = I256Trait::new(10, true);
    y = I256Trait::new(20, false);
    result = x * y;
    assert(result.val == 200 && result.sign == true, 'i256 mul(-10, 20)');

    x = I256Trait::new(0, false);
    y = I256Trait::new(20, false);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i256 mul(0, 20)');

    x = I256Trait::new(0, true);
    y = I256Trait::new(20, true);
    result = x * y;
    assert(result.val == 0 && result.sign == false, 'i256 mul(0, -20)');

    
    x = I256Trait::new(1, false);
    y = I256Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == false, 'i256 mul(1, 20)');

    x = I256Trait::new(1, true);
    y = I256Trait::new(20, false);
    result = x * y;
    assert(result.val == 20 && result.sign == true, 'i256 mul(-1, 20)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i256_overflowing_mul() {
    let x = I256Trait::new(BoundedU256::max(), true);
    let y = I256Trait::new(2, true);
    x * y;
}

#[test]
#[available_gas(2000000000)]
fn test_i256_div() {
    let mut x = I256Trait::new(20, false);
    let mut y = I256Trait::new(10, false);
    let mut result = x / y;
    assert(result.val == 2 && result.sign == false, 'i256 div(20, 10)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == false, 'i256 div(-20, -10)');

    x = I256Trait::new(20, false);  
    y = I256Trait::new(10, true);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i256 div(20, -10)');

    x = I256Trait::new(20, true);
    y = I256Trait::new(10, false);
    result = x / y;
    assert(result.val == 2 && result.sign == true, 'i256 div(-20, 10)');

    x = I256Trait::new(0, false);
    y = I256Trait::new(10, false);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i256 div(0, 10)');

    x = I256Trait::new(0, false);
    y = I256Trait::new(10, true);
    result = x / y;
    assert(result.val == 0 && result.sign == false, 'i256 div(0, -10)');

    x = I256Trait::new(10, false);
    y = I256Trait::new(1, false);
    result = x / y;
    assert(result.val == 10 && result.sign == false, 'i256 div(10, 1)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic]
fn test_i256_div_by_zero() {
    let x = I256Trait::new(10, false);
    let y = I256Trait::new(0, false);
    x / y;
}

// #[test]
// fn test_i256_rem() {

// }

// #[test]
// fn test_i256_conversion() {

// }