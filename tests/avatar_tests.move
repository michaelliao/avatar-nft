 
#[test_only]
module avatar::avatar_tests {
    use sui::tx_context::{Self, TxContext};
    use avatar::avatar;

    #[test]
    fun test_avatar() {
        let mut ctx = tx_context::dummy();
        avatar::mint_to_sender( 
            b"CryptoKitty",
            b"The Crypto Kitty NFT",
            b"https://michaelliao.github.io/avatar-nft/public/kitty.png",
            &mut ctx
        );
    }
} 
