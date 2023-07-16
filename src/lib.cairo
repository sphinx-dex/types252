mod types;
mod math;

use types::i32::{i32, I32Trait, I32Zeroable};
use types::i128::{i128, I128Trait, I128Zeroable};
use types::i256::{i256, I256Trait, I256Zeroable};
use types::UD47x28::{UD47x28, UD47x28Trait, UD47x28Zeroable};
use types::UD47x28::{
    ONE, HALF, ONE_SQUARED, BP, MAX_UD47x28, MAX_UNSCALED_UD47x28, MAX_WHOLE_UD47x28, MAX_EXP2_INPUT, LOG2_1_0001, E, PI
};

#[cfg(test)]
mod tests;