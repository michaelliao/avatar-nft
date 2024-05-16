module avatar::avatar {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// An example NFT that can be minted by anybody
    public struct AvatarNFT has key, store {
        id: UID,
        /// Name for the token 代币（NFT）名
        name: string::String,
        /// Description of the token
        description: string::String,
        /// URL for the token 代币（NFT）链接
        url: Url,
        // TODO: allow custom attributes 
    }

    // ===== Events ===== 事件
    public struct NFTMinted has copy, drop {
        // The Object ID of the NFT 新铸造的NFT的ID
        object_id: ID,
        // The creator of the NFT 新铸造的NFT的创造者
        creator: address,
        // The name of the NFT 新铸造的NFT的名
        name: string::String,
    }

    // ===== Public view functions =====

    /// 获取NFT名称
    public fun name(nft: &AvatarNFT): &string::String {
        &nft.name
    }

    /// 获取NFT描述
    public fun description(nft: &AvatarNFT): &string::String {
        &nft.description
    }

    /// 获取NFT链接
    public fun url(nft: &AvatarNFT): &Url {
        &nft.url
    }

    // ===== Entrypoints =====

    /// 创建新的NFT
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = AvatarNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }

    /// 转移NFT
    public entry fun transfer(
        nft: AvatarNFT, recipient: address, _: &mut TxContext
    ) {
        transfer::public_transfer(nft, recipient)
    }

    /// 更新NFT
    public entry fun update_description(
        nft: &mut AvatarNFT,
        new_description: vector<u8>,
        _: &mut TxContext
    ) {
        nft.description = string::utf8(new_description)
    }

    /// 删除NFT
    public entry fun burn(nft: AvatarNFT, _: &mut TxContext) {
        let AvatarNFT { id, name: _, description: _, url: _ } = nft;
        object::delete(id)
    }
}
