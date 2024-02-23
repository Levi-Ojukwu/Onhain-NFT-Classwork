// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract OnchainNFT is ERC721URIStorage {
    using Strings for uint256;
    
    uint256 private _tokenIds;

    mapping(uint256 => uint256) public tokenIdtoLevels;


    constructor() ERC721("Onchain NFT", "OCNFT") {

    }

    function generateCharacter(uint256 _tokenId) public pure returns(string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
   '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>'
   '<rect width="100%" height="100%" fill="black" />'
   '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">Warrior</text>'
   '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">Levels: getLevels(_tokenId)</text>'
 '</svg>'
        );

        return string (
            abi.encodePacked(
                "data:image/svg+xlm;base64,",
                Base64.encode(svg)
            )
        );
    }

    function getLevels(uint256 _tokenId) public view returns(string memory) {
        uint256 levels = tokenIdtoLevels[_tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 _tokenId) public pure returns(string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{'
                '"name": "Onchain NFT #",',
                '"description": "description",',
                '"image": "', generateCharacter(_tokenId), '"', 
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() external {
       uint256 newItemId = _tokenIds++;

        // uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        tokenIdtoLevels[newItemId] = 0;

        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 _tokenId) external {
        // require(_exists(_tokenId), "Please use an existing token ID");

        require(ownerOf(_tokenId) == msg.sender, "You must own this token to train it");

        uint256 currentLevel = tokenIdtoLevels[_tokenId];

        tokenIdtoLevels[_tokenId] = currentLevel + 1;

        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }
}