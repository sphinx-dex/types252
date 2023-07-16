use result::ResultTrait;
use array::ArrayTrait;
use option::OptionTrait;

use types252::types::UD47x28::{UD47x28, UD47x28Trait, UD47x28Zeroable};
use types252::types::UD47x28::{ONE, E, PI, MAX_WHOLE_UD47x28, MAX_UD47x28};

use debug::PrintTrait;

////////////////////////////////
// CONSTANTS
////////////////////////////////

const EXP2_MAX_PERMITTED: u256 = 1559999999999999999999999999999;

const SQRT_MAX_PERMITTED: u256 = 361850278866613121369732278309507010552674375171;

////////////////////////////////
// TESTS - EXP2
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_exp2_zero() {
    let x = UD47x28Zeroable::zero();
    let actual = x.exp2();
    let expected = UD47x28Trait::one();
    assert(actual == expected, 'UD47x28 exp2(0)');
}

#[test]
#[available_gas(2000000000)]
fn test_exp2_sets() {
    let mut x = UD47x28Trait::new(1);
    assert(x.exp2() == UD47x28Trait::one(), 'UD47x28 exp2(1e-28)');

    x = UD47x28Trait::new(1000);
    assert(x.exp2().val == 10000000000000000000000000693, 'UD47x28 exp2(1000e-28)');

    x = UD47x28Trait::new(3212000000000000000000000000);
    assert(x.exp2().val == 12493693130120248838337137168, 'UD47x28 exp2(0.3212)');

    x = UD47x28Trait::new(10000000000000000000000000000);
    assert(x.exp2().val == 20000000000000000000000000000, 'UD47x28 exp2(1)');

    x = UD47x28Trait::new(20000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(40000000000000000000000000000), 'UD47x28 exp2(2)');

    x = UD47x28Trait::new(E);
    assert(x.exp2() == UD47x28Trait::new(65808859910179209708515424041), 'UD47x28 exp2(e)');

    x = UD47x28Trait::new(30000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(80000000000000000000000000000), 'UD47x28 exp2(3)');

    x = UD47x28Trait::new(PI);
    assert(x.exp2() == UD47x28Trait::new(88249778270762876238564296043), 'UD47x28 exp2(pi)');

    x = UD47x28Trait::new(40000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(160000000000000000000000000000), 'UD47x28 exp2(4)');

    x = UD47x28Trait::new(118921500000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(38009649333015427545848187960696), 'UD47x28 exp2(11.89215)');

    x = UD47x28Trait::new(160000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(655360000000000000000000000000000), 'UD47x28 exp2(16)');

    x = UD47x28Trait::new(208200000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(18511623540769394346846042698399673), 'UD47x28 exp2(20.82)');

    x = UD47x28Trait::new(333333330000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(108226369091205534917975874356004601288), 'UD47x28 exp2(33.333333)');

    x = UD47x28Trait::new(640000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(184467440737095516160000000000000000000000000000), 'UD47x28 exp2(64)');

    x = UD47x28Trait::new(710020000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(23644588063720104408087046881065825054747353927543), 'UD47x28 exp2(71.002)');  

    x = UD47x28Trait::new(887494000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(5202732501049294792004470828120632650401072415852210539), 'UD47x28 exp2(88.7494)');

    x = UD47x28Trait::new(950000000000000000000000000000);
    assert(x.exp2() == UD47x28Trait::new(396140812571321687967719751680000000000000000000000000000), 'UD47x28 exp2(95)');

    x = UD47x28Trait::new(1270000000000000000000000000000);
    assert(
        x.exp2() == UD47x28Trait::new(1701411834604692317316873037158841057280000000000000000000000000000), 
        'UD47x28 exp2(127)'
    );

    x = UD47x28Trait::new(1529065000000000000000000000000);
    assert(
        x.exp2() == UD47x28Trait::new(107014599871528286360998282546286317974145808181250000000000000000000000000), 
        'UD47x28 exp2(152.9065)'
    );

    x = UD47x28Trait::new(EXP2_MAX_PERMITTED);
    assert(
        x.exp2() == UD47x28Trait::new(913438523331814323877303020385942254084646044230000000000000000000000000000), 
        'UD47x28 exp2(MAX_PERMITTED)'
    );
}

#[test]
#[available_gas(2000000000)]
#[should_panic(expected: ('UD47x28 exp2 overflow', ))]
fn test_exp2_revert_gt_max() {
    let x = UD47x28Trait::new(EXP2_MAX_PERMITTED + 1);
    x.exp2();
}

////////////////////////////////
// TESTS - LOG2
////////////////////////////////

#[test]
#[available_gas(2000000000)]
#[should_panic(expected: ('UD47x28 log2 underflow', ))]
fn test_log2_revert_when_lt_one() {
    let x = UD47x28Trait::new(ONE - 1);
    x.log2();
}

#[test]
#[available_gas(2000000000)]
fn test_log2_power_of_two_sets() {
    let mut x = UD47x28Trait::one();
    assert(x.log2() == UD47x28Zeroable::zero(), 'UD47x28 log2(1)');

    x = UD47x28Trait::new(20000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::one(), 'UD47x28 log2(2)');

    x = UD47x28Trait::new(40000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(2 * ONE), 'UD47x28 log2(4)');

    x = UD47x28Trait::new(80000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(3 * ONE), 'UD47x28 log2(8)');

    x = UD47x28Trait::new(160000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(4 * ONE), 'UD47x28 log2(16)');

    x = UD47x28Trait::new(913438523331814323877303020447676887284957839360000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(156 * ONE), 'UD47x28 log2(2 ** 156)');
}

#[test]
#[available_gas(2000000000)]
fn test_log2_not_power_of_two_sets() {
    let mut x = UD47x28Trait::new(11250000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(1699250014423123629074778866), 'UD47x28 log2(1.125)');

    x = UD47x28Trait::new(E);
    assert(x.log2() == UD47x28Trait::new(14426950408889634073599246792), 'UD47x28 log2(e)');

    x = UD47x28Trait::new(PI);
    assert(x.log2() == UD47x28Trait::new(16514961294723187980432792935), 'UD47x28 log2(pi)');

    x = UD47x28Trait::new(10000000000000000000000000000000000);
    assert(x.log2() == UD47x28Trait::new(199315685693241740872219165754), 'UD47x28 log2(1000000)');

    x = UD47x28Trait::new(MAX_WHOLE_UD47x28);
    assert(x.log2() == UD47x28Trait::new(1579860133431538543021765642266), 'UD47x28 log2(MAX_WHOLE_UD47x28)');

    x = UD47x28Trait::new(MAX_UD47x28);
    assert(x.log2() == UD47x28Trait::new(1579860133431538543021765642266), 'UD47x28 log2(MAX_UD47x28)');
}

////////////////////////////////
// TESTS - POW
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_pow_base_zero_exp_zero() {
    let x: UD47x28 = UD47x28Zeroable::zero();
    let y: UD47x28 = UD47x28Zeroable::zero();
    let actual = x.pow(y);
    let expected = UD47x28Trait::one();
    assert(actual == expected, 'UD47x28 pow(0, 0)');
}

#[test]
#[available_gas(2000000000)]
fn test_pow_base_zero_exp_not_zero() {
    let x: UD47x28 = UD47x28Zeroable::zero();
    let y: UD47x28 = UD47x28Trait::new(PI);
    let actual = x.pow(y);
    let expected = UD47x28Zeroable::zero();
    assert(actual == expected, 'UD47x28 pow(0, pi)');
}

#[test]
#[available_gas(2000000000)]
fn test_pow_base_one() {
    let x: UD47x28 = UD47x28Trait::one();
    let y: UD47x28 = UD47x28Trait::new(PI);
    let actual = x.pow(y);
    let expected = UD47x28Trait::one();
    assert(actual == expected, 'UD47x28 pow(1, pi)');
}

#[test]
#[available_gas(2000000000)]
fn test_pow_exponent_zero() {
    let x: UD47x28 = UD47x28Trait::new(PI);
    let y: UD47x28 = UD47x28Zeroable::zero();
    let actual = x.pow(y);
    let expected = UD47x28Trait::one();
    assert(actual == expected, 'UD47x28 pow(pi, 0)');
}

#[test]
#[available_gas(2000000000)]
fn test_pow_exponent_one() {
    let x: UD47x28 = UD47x28Trait::new(PI);
    let y: UD47x28 = UD47x28Trait::one();
    let actual = x.pow(y);
    let expected = UD47x28Trait::new(PI);
    assert(actual == expected, 'UD47x28 pow(pi, 1)');
}

#[test]
#[available_gas(2000000000)]
fn test_pow_base_gt_unit_sets() {
    let mut x = UD47x28Trait::new(10000000000000000000000000001);
    let mut y = UD47x28Trait::new(20000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(10000000000000000000000000001), 'UD47x28 pow(1 + 1e-28, 2)');

    x = UD47x28Trait::new(20000000000000000000000000000);
    y = UD47x28Trait::new(15000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(28284271247461900976033774484), 'UD47x28 pow(2, 1.5)');

    x = UD47x28Trait::new(E);
    y = UD47x28Trait::new(16697600000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(53108930298880376453546904286), 'UD47x28 pow(e, 1.66976)');

    x = UD47x28Trait::new(E);
    y = UD47x28Trait::new(E);
    assert(x.pow(y) == UD47x28Trait::new(151542622414792641897604302214), 'UD47x28 pow(e, e)');

    x = UD47x28Trait::new(PI);
    y = UD47x28Trait::new(PI);
    assert(x.pow(y) == UD47x28Trait::new(364621596072079117709908258933), 'UD47x28 pow(pi, pi)');

    x = UD47x28Trait::new(110000000000000000000000000000);
    y = UD47x28Trait::new(285000000000000000000000000000);
    assert(
        x.pow(y) == UD47x28Trait::new(4782902491063836292584921301222131339132401149777384929961), 
        'UD47x28 pow(11, 28.5)'
    );

    x = UD47x28Trait::new(321500000000000000000000000000);
    y = UD47x28Trait::new(239900000000000000000000000000);
    assert(
        x.pow(y) == UD47x28Trait::new(14363875906274487725445987112648622339199794646119698882102966308), 
        'UD47x28 pow(32.15, 23.99)'
    );

    x = UD47x28Trait::new(4060000000000000000000000000000);
    y = UD47x28Trait::new(2500000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(44888129477190163282704426643), 'UD47x28 pow(406, 0.25)');

    x = UD47x28Trait::new(17290000000000000000000000000000);
    y = UD47x28Trait::new(9800000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(14894951499222569308120767523232), 'UD47x28 pow(1729, 0.98)');

    x = UD47x28Trait::new(334410000000000000000000000000000);
    y = UD47x28Trait::new(21891000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(80186215896819234203354847687000612445), 'UD47x28 pow(33441, 2.1891)');

    x = UD47x28Trait::new(3402823669209384634633746074317682114550000000000000000000000000000);
    y = UD47x28Trait::new(10000000000000000000000000001);
    assert(
        x.pow(y) == UD47x28Trait::new(3402823669209384634633746097429974876160000000000000000000000000000), 
        'UD47x28 pow(Q128, 1 + 1e-28)'
    );

    x = UD47x28Trait::new(913438523331814323877303020447676887284957839359999999999999999999999999999);
    y = UD47x28Trait::new(9999999999999999999999999999);
    assert(
        x.pow(y) == UD47x28Trait::new(913438523331814323877303008734949874092078072430000000000000000000000000000), 
        'UD47x28 pow(Q156, 1 - 1e-28)'
    );
}

#[test]
#[available_gas(2000000000)]
fn test_pow_base_lt_unit_sets() {
    let mut x = UD47x28Trait::new(100);
    let mut y = UD47x28Trait::new(17800000000000000000000000000);
    assert(x.pow(y) == UD47x28Zeroable::zero(), 'UD47x28 pow(1e-28, 1.78)');

    x = UD47x28Trait::new(100000000000000000000000000);
    y = UD47x28Trait::new(E);
    assert(x.pow(y) == UD47x28Trait::new(36596229553091118596020), 'UD47x28 pow(0.01, e)');

    x = UD47x28Trait::new(1250000000000000000000000000);
    y = UD47x28Trait::new(PI);
    assert(x.pow(y) == UD47x28Trait::new(14549870613941865682117610), 'UD47x28 pow(0.125, pi)');

    x = UD47x28Trait::new(2500000000000000000000000000);
    y = UD47x28Trait::new(30000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(156250000000000000000000000), 'UD47x28 pow(0.25, 3)');

    x = UD47x28Trait::new(4500000000000000000000000000);
    y = UD47x28Trait::new(22000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(1726106270767747284172501393), 'UD47x28 pow(0.45, 2.2)');

    x = UD47x28Trait::new(5000000000000000000000000000);
    y = UD47x28Trait::new(4810000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(7164808251865499113537864868), 'UD47x28 pow(0.5, 0.481)');

    x = UD47x28Trait::new(6000000000000000000000000000);
    y = UD47x28Trait::new(9500000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(6155221527236961661434849087), 'UD47x28 pow(0.6, 0.95)');

    x = UD47x28Trait::new(7000000000000000000000000000);
    y = UD47x28Trait::new(31000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(3309816556260974400680285531), 'UD47x28 pow(0.7, 3.1)');

    x = UD47x28Trait::new(7500000000000000000000000000);
    y = UD47x28Trait::new(40000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(3164062500000000000000000014), 'UD47x28 pow(0.75, 4)');

    x = UD47x28Trait::new(8000000000000000000000000000);
    y = UD47x28Trait::new(50000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(3276800000000000000000000019), 'UD47x28 pow(0.8, 5)');

    x = UD47x28Trait::new(9000000000000000000000000000);
    y = UD47x28Trait::new(25000000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::new(7684334714209161776757311334), 'UD47x28 pow(0.9, 2.5)');

    x = UD47x28Trait::new(9999999999999999999999999999);
    y = UD47x28Trait::new(800000000000000000000000000);
    assert(x.pow(y) == UD47x28Trait::one(), 'UD47x28 pow(1 - 1e-28, 0.08)');
}

////////////////////////////////
// TESTS - SQRT
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_sqrt_zero() {
    let x: UD47x28 = UD47x28Zeroable::zero();
    let actual = x.sqrt();
    let expected = UD47x28Zeroable::zero();
    assert(actual == expected, 'UD47x28 sqrt(0)');
}

#[test]
#[available_gas(2000000000)]
fn test_sqrt_sets_1() {
    let mut x = UD47x28Trait::new(1);
    assert(x.sqrt() == UD47x28Trait::new(100000000000000), 'UD47x28 sqrt(1e-28)');

    x = UD47x28Trait::new(1000);
    assert(x.sqrt() == UD47x28Trait::new(3162277660168379), 'UD47x28 sqrt(1e-25)');

    x = UD47x28Trait::one();
    assert(x.sqrt() == UD47x28Trait::one(), 'UD47x28 sqrt(1)');

    x = UD47x28Trait::new(2 * ONE);
    assert(x.sqrt() == UD47x28Trait::new(14142135623730950488016887242), 'UD47x28 sqrt(2)');

    x = UD47x28Trait::new(E);
    assert(x.sqrt() == UD47x28Trait::new(16487212707001281468486507878), 'UD47x28 sqrt(e)');

    x = UD47x28Trait::new(3 * ONE);
    assert(x.sqrt() == UD47x28Trait::new(17320508075688772935274463415), 'UD47x28 sqrt(3)');

    x = UD47x28Trait::new(PI);
    assert(x.sqrt() == UD47x28Trait::new(17724538509055160272981674833), 'UD47x28 sqrt(pi)');

    x = UD47x28Trait::new(4 * ONE);
    assert(x.sqrt() == UD47x28Trait::new(2 * ONE), 'UD47x28 sqrt(4)');
}

#[test]
#[available_gas(2000000000)]
fn test_sqrt_sets_2() {
    let mut x = UD47x28Trait::new(16 * ONE);
    assert(x.sqrt() == UD47x28Trait::new(4 * ONE), 'UD47x28 sqrt(16)');

    x = UD47x28Trait::new(100000000000000000000000000000000000000000000000);
    assert(x.sqrt() == UD47x28Trait::new(31622776601683793319988935444327185337), 'UD47x28 sqrt(1e17)');

    x = UD47x28Trait::new(12489131238983290393813123784889921092801);
    assert(x.sqrt() == UD47x28Trait::new(11175478172759897791045222095936630), 'UD47x28 sqrt(12489..)');

    x = UD47x28Trait::new(361850278866613121369732278309507010552674375171);
    assert(x.sqrt() == UD47x28Trait::new(60153992292001128773238055242035448131), 'UD47x28 sqrt(36185..)');

    x = UD47x28Trait::new(10000000000000000000000000000000000000000000000);
    assert(x.sqrt() == UD47x28Trait::new(10000000000000000000000000000000000000), 'UD47x28 sqrt(1e16)');

    x = UD47x28Trait::new(50000000000000000000000000000000000000000000000);
    assert(x.sqrt() == UD47x28Trait::new(22360679774997896964091736687312762354), 'UD47x28 sqrt(5e16)');

    x = UD47x28Trait::new(SQRT_MAX_PERMITTED);
    assert(x.sqrt() == UD47x28Trait::new(60153992292001128773238055242035448131), 'UD47x28 sqrt(MAX_PERMITTED)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic(expected: ('UD47x28 sqrt overflow', ))]
fn test_revert_when_gt_max() {
    let x: UD47x28 = UD47x28Trait::new(SQRT_MAX_PERMITTED + 1);
    x.sqrt();
}

////////////////////////////////
// TESTS - ROUND
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_round_sets() {
    let mut x = UD47x28Trait::new(1);
    assert(x.round() == UD47x28Zeroable::zero(), 'UD47x28 round(1e-28)');

    x = UD47x28Zeroable::zero();
    assert(x.round() == UD47x28Zeroable::zero(), 'UD47x28 round(0)');

    x = UD47x28Trait::new(ONE + 1);
    assert(x.round() == UD47x28Trait::one(), 'UD47x28 round(1 + 1e-28)');

    x = UD47x28Trait::new(PI);
    assert(x.round() == UD47x28Trait::new(3 * ONE), 'UD47x28 round(pi)');

    x = UD47x28Trait::new(5 * ONE);
    assert(x.round() == UD47x28Trait::new(5 * ONE), 'UD47x28 round(5)');
    
    x = UD47x28Trait::new(381233000000000000000000000000);
    assert(x.round() == UD47x28Trait::new(38 * ONE), 'UD47x28 round(38.1233)');

    let x = UD47x28Trait::new(MAX_WHOLE_UD47x28 - 1);
    assert(x.round() == UD47x28Trait::new(MAX_WHOLE_UD47x28), 'UD47x28 round(MAX_WHOLE)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic(expected: ('UD47x28 round overflow', ))]
fn test_round_expect_overflow() {
    let x = UD47x28Trait::new(MAX_WHOLE_UD47x28);
    x.round();
}

////////////////////////////////
// TESTS - CEIL
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_ceil_sets() {
    let mut x = UD47x28Trait::new(1);
    assert(x.ceil() == UD47x28Trait::one(), 'UD47x28 ceil(1e-28)');

    x = UD47x28Trait::new(ONE);
    assert(x.ceil() == UD47x28Trait::one(), 'UD47x28 ceil(1)');

    x = UD47x28Zeroable::zero();
    assert(x.round() == UD47x28Zeroable::zero(), 'UD47x28 ceil(0)');

    x = UD47x28Trait::new(PI);
    assert(x.ceil() == UD47x28Trait::new(4 * ONE), 'UD47x28 ceil(pi)');
    
    x = UD47x28Trait::new(381233000000000000000000000000);
    assert(x.ceil() == UD47x28Trait::new(39 * ONE), 'UD47x28 ceil(38.1233)');

    let x = UD47x28Trait::new(MAX_WHOLE_UD47x28 - 1);
    assert(x.ceil() == UD47x28Trait::new(MAX_WHOLE_UD47x28), 'UD47x28 ceil(MAX_WHOLE)');
}

#[test]
#[available_gas(2000000000)]
#[should_panic(expected: ('UD47x28 ceil overflow', ))]
fn test_ceil_expect_overflow() {
    let x = UD47x28Trait::new(MAX_WHOLE_UD47x28 + 1);
    x.ceil();
}

////////////////////////////////
// TESTS - FLOOR
////////////////////////////////

#[test]
#[available_gas(2000000000)]
fn test_floor_sets() {
    let mut x = UD47x28Trait::new(1);
    assert(x.round() == UD47x28Zeroable::zero(), 'UD47x28 floor(1e-28)');

    x = UD47x28Trait::new(ONE - 1);
    assert(x.floor() == UD47x28Zeroable::zero(), 'UD47x28 floor(1 - 1e-28)');

    x = UD47x28Trait::new(PI);
    assert(x.floor() == UD47x28Trait::new(3 * ONE), 'UD47x28 floor(pi)');

    x = UD47x28Trait::new(5 * ONE);
    assert(x.floor() == UD47x28Trait::new(5 * ONE), 'UD47x28 floor(5)');
    
    x = UD47x28Trait::new(381233000000000000000000000000);
    assert(x.floor() == UD47x28Trait::new(38 * ONE), 'UD47x28 floor(38.1233)');

    let x = UD47x28Trait::new(MAX_WHOLE_UD47x28 - 1);
    assert(x.floor() == UD47x28Trait::new(MAX_WHOLE_UD47x28 - ONE), 'UD47x28 floor(MAX_WHOLE)');
}