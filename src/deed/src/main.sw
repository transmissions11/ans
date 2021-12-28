contract;

use std::hash::*;
use std::storage::*;
use std::constants::*;

const CHAIR: b256 = 0x9299da6c73e6dc03eeabcce242bb347de3f5f56cd1c70926d76526d7ed199b8b;

const OWNER_OF_SLOT: b256 = 0x0000000000000000000000000000000000000000000000000000000000000000;

abi Deed {
    fn flux(gas: u64, coins: u64, asset_id: b256, args: FluxParams);
}

struct FluxParams {
    id: u64,
    from: b256,
    to: b256,
}

impl Deed for Contract {
    fn flux(gas: u64, coins: u64, asset_id: b256, args: FluxParams) {
        // idk how to convert the u64 id into a b256 yet, so just hashing it rn lmao
        let slot = hash_pair(OWNER_OF_SLOT, hash_u64(args.id, HashMethod::Sha256), HashMethod::Sha256);
        
        let hand: b256 = get(slot);

        // just trusting from cuz auth isnt ready yet
        if (args.from == hand || (args.from == CHAIR && hand == ZERO)) {
            store(slot, args.to);
        }
    }
}
