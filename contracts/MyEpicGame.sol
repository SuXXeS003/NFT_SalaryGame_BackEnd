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
        uint hp;
        uint maxHp;
        uint attack;
    }

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attack;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultCharacters;

    BigBoss public bigBoss;

    // We create a mapping from the nft's tokenId => that NFTs attributes.
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs tokenId. Gives me an ez way
    // to store the owner of the NFT and reference it later.
    mapping(address => uint256) public nftHolders;

    event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackComplete(uint newBossHp, uint newPlayerHp);
    event PlayerRevived(address sender, uint tokenId);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterArguments,
        uint[] memory characterPersuasion,
        string memory bossName,
        string memory bossImageURI,
        uint bossIgnorance,
        uint bossHumiliation
    ) 
        ERC721("Worker","WORKER")
    {
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossIgnorance,
            maxHp: bossIgnorance,
            attack: bossHumiliation
        });
        
        console.log("Done initializing boss %s", bigBoss.name);

        for(uint i = 0; i < characterNames.length;i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterArguments[i],
                maxHp: characterArguments[i],
                attack: characterPersuasion[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s with %s Arguments, img %s", c.name, c.hp, c.imageURI);
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
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attack: defaultCharacters[_characterIndex].attack
        });

        console.log("Minted NFT with tokenId %s and characterIndex %s", newItemId, _characterIndex);
        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strArguments = Strings.toString(charAttributes.hp);
        string memory strMaxArguments = Strings.toString(charAttributes.maxHp);
        string memory strPersuasion = Strings.toString(charAttributes.attack);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        ' -- NFT #: ',
                        Strings.toString(_tokenId),
                        '", "description": "Try to get more Money", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Arguments", "value": ',strArguments,', "max_value":',strMaxArguments,'}, { "trait_type": "Persuasion", "value": ',
                        strPersuasion,'} ]}'
                    )
                )
            )
        );

        console.log('JSON:', json);

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }

    function requestSalaryIncrease() public {
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("\nPlayer with character %s is about to request.", player.name);
        console.log("%s is listening", bigBoss.name);

        require (
            player.hp > 0,
            "Error: character must have arguments to request salary increasse."
        );

        require (
            bigBoss.hp > 0,
            "Error: boss must have ignorance."
        );

        if (bigBoss.hp < player.attack) {
            bigBoss.hp = 0;
        } else {
            bigBoss.hp = bigBoss.hp - player.attack;
        }

        if (player.hp < bigBoss.attack) {
            player.hp = 0;
        } else {
            player.hp = player.hp - bigBoss.attack;
        }

        emit AttackComplete(bigBoss.hp, player.hp);
        
        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);
    }

    function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
        uint256 userNftTokenId = nftHolders[msg.sender];

        if (userNftTokenId > 0) {
            return nftHolderAttributes[userNftTokenId];
        } else {
            CharacterAttributes memory emptyStruct;
            return emptyStruct;
        }
    }

    function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
        return defaultCharacters;
    }

    function getBigBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }

    function reviveCharacter() public {
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        
        require(player.hp == 0, "Revive only possible if you are dead");
        player.hp = player.maxHp;

        emit PlayerRevived(msg.sender, nftTokenIdOfPlayer);
    }

}

