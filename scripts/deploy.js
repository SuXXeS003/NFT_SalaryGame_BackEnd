const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Worker 1", "Worker 2", "Worker 3"],
        ["https://cloudflare-ipfs.com/ipfs/QmPxTHphqKCfto3m3f2g6KSgGeonC78FTS2VABBndMtG7C",
        "https://cloudflare-ipfs.com/ipfs/QmPJ6jV4gcTRcHCfX4absUC3YniSqRzao7pAv5w5ePYwMg",
        "https://cloudflare-ipfs.com/ipfs/QmQzujPLr2RMjHEJH6ou9bzhLPC3gcrpN3qFbmtrRjcY5E"],
        [100, 200, 300],
        [100, 50, 25],
        "Big Boss",
        "https://cloudflare-ipfs.com/ipfs/QmZgJXxHdkjALHTgZByUkcf2UE9MqTtjBGHbd6Tr38wve6",
        10000,
        50
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);
    
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