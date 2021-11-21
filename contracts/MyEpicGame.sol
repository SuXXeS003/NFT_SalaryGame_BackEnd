// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract MyEpicGame {

    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint arguments;
        uint maxArguments;
        uint attackDamage;
    }

    CharacterAttributes[] defaultCharacters;


    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterArguments,
        uint[] memory characterAttackDmg
    ) 
    {
        for(uint i = 0; i < characterNames.length;i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                arguments: characterArguments[i],
                maxArguments: characterArguments[i],
                attackDamage: characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s with %s Arguments, img %s", c.name, c.arguments, c.imageURI);
        }
    }
}

