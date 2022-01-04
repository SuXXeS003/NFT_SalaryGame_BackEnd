const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Worker 1", "Worker 2", "Worker 3"],
        ["https://cloudflare-ipfs.com/ipfs/QmPxTHphqKCfto3m3f2g6KSgGeonC78FTS2VABBndMtG7C",
        "https://cloudflare-ipfs.com/ipfs/QmPJ6jV4gcTRcHCfX4absUC3YniSqRzao7pAv5w5ePYwMg",
        "https://cloudflare-ipfs.com/ipfs/QmQzujPLr2RMjHEJH6ou9bzhLPC3gcrpN3qFbmtrRjcY5E"],
        [100, 20, 300],
        [100, 50, 25],
        "Big Boss",
        "https://cloudflare-ipfs.com/ipfs/QmZgJXxHdkjALHTgZByUkcf2UE9MqTtjBGHbd6Tr38wve6",
        10000,
        50
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
    
    let txn;
    let receipt;
    txn = await gameContract.mintCharacterNFT(1);
    receipt = await txn.wait();

    console.log('################################################');
    console.log('Round 1');
    console.log('Fight');
    console.log('################################################');

    txn = await gameContract.requestSalaryIncrease();

    receipt = await txn.wait();

    // try to get events
    const events = receipt.events;
    console.log("Deathtime:::", new Date(1000 * (events[0].args[1].toNumber())).toISOString());
    //spits the blocktime of death in ISO: 2022-01-04T14:03:55.000Z

    // Player should be dead, so we test a revive call

    console.log('################################################');
    console.log('Player Dead');
    console.log('Revive');
    console.log('################################################');

    
    txn = await gameContract.reviveCharacter();
    receipt = await txn.wait();

    let returnedTokenUri = await gameContract.tokenURI(1);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();