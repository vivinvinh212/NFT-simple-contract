// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Cutie is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string public constant TOKEN_URI = "ipfs://QmZvBFsTFhfR75bEVitGVHcqCCkR5WgYmgHVNihH5nmejN";

    // Define naximum supply, mint price and maximum mint per transactions of NFT
    uint256 MAX_SUPPLY = 100;
    uint mintPrice = 0.01 ether;
    uint maxPerTransaction = 5;


    constructor() ERC721("Cutie", "CUTE") {
    }

    function safeMint(uint256 mintAmount) public payable { 
           
        require(mintAmount > 0, "Must mint at least 1");
        require(mintAmount <= maxPerTransaction, "Maximum 5 nfts allowed in a transaction");
        require(tokenId + mintAmount <= maxSupply, "Supply is not enough");
        require(msg.value >= mintPrice * mintAmount; "Insufficient balance");

        for (uint256 i = 1; i <= mintAmount; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current(); 
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, uri);
        }
        return tokenId;
    }

    function withdraw() public payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not enough balance");
        (bool status, ) = (msg.sender).call{value: balance}("");
        require(status, "Withdraw failed");
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
