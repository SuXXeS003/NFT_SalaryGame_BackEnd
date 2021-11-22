// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract MyEpicGame is ERC721 {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint arguments;
        uint maxArguments;
        uint persuasion;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    // We create a mapping from the nft's tokenId => that NFTs attributes.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs tokenId. Gives me an ez way
    // to store the owner of the NFT and reference it later.
    mapping(address => uint256) public nftHolders;


    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterArguments,
        uint[] memory characterPersuasion
    ) 
        ERC721("Worker","WORKER")
    {
        for(uint i = 0; i < characterNames.length;i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                arguments: characterArguments[i],
                maxArguments: characterArguments[i],
                persuasion: characterPersuasion[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s with %s Arguments, img %s", c.name, c.arguments, c.imageURI);
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            arguments: defaultCharacters[_characterIndex].arguments,
            maxArguments: defaultCharacters[_characterIndex].maxArguments,
            persuasion: defaultCharacters[_characterIndex].persuasion
        });

        console.log("Minted NFT with tokenId %s and characterIndex %s", newItemId, _characterIndex);
        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strArguments = Strings.toString(charAttributes.arguments);
        string memory strMaxArguments = Strings.toString(charAttributes.maxArguments);
        string memory strPersuasion = Strings.toString(charAttributes.persuasion);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        ' -- NFT #: ',
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game Get More Money", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Arguments", "value": ',strArguments,', "max_value":',strMaxArguments,'}, { "trait_type": "Persuasion", "value": ',
                        strPersuasion,'} ]}'
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}

