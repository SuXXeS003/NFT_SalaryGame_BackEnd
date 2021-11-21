const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Worker 1", "Worker 2", "Worker 3"],
        ["https://images.pexels.com/photos/7155779/pexels-photo-7155779.jpeg",
        "https://images.pexels.com/photos/5414000/pexels-photo-5414000.jpeg",
        "https://images.pexels.com/photos/2382665/pexels-photo-2382665.jpeg"],
        [100, 200, 300],
        [100, 50, 25]
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