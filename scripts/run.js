const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Worker 1", "Worker 2", "Worker 3"],
        ["QmPxTHphqKCfto3m3f2g6KSgGeonC78FTS2VABBndMtG7C",
        "QmPJ6jV4gcTRcHCfX4absUC3YniSqRzao7pAv5w5ePYwMg",
        "QmQzujPLr2RMjHEJH6ou9bzhLPC3gcrpN3qFbmtrRjcY5E"],
        [100, 200, 300],
        [100, 50, 25],
        "Big Boss",
        "QmZgJXxHdkjALHTgZByUkcf2UE9MqTtjBGHbd6Tr38wve6",
        10000,
        50
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();

    txn = await gameContract.requestSalaryIncrease();
    await txn.wait();

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