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

    // Define naximum supply, mint price and maximum mint per transactions of NFT
    uint256 MAX_SUPPLY = 100;
    uint mintPrice = 0.01 ether;
    uint maxPerTransaction = 5;


    constructor() ERC721("Cutie", "CUTE") {}

    function safeMint(address to, string memory uri, uint256 mintAmount) public payable {        
        require(mintAmount > 0);
        require(mintAmount <= maxPerTransaction);
        require(supply + mintAmount <= maxSupply);
        require(msg.value >= mintPrice * mintAmount);

        for (uint256 i = 1; i <= mintAmount; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(to, supply + i);
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
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
