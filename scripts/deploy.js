const main = async () => {
  const chainTalesFactory = await hre.ethers.getContractFactory('ChainTales');
  const talesContract = await chainTalesFactory.deploy();
  
  await talesContract.deployed();
  console.log("Contract deployed to:", talesContract.address);


  const metaContractFactory = await hre.ethers.getContractFactory('ChainTalesMetadata');
  const metaContract = await metaContractFactory.deploy();
  
  await metaContract.deployed();
  console.log("Contract metadata deployed to:", metaContract.address);

  let txn1;
  txn1 = await talesContract.setMetadataAddress(metaContract.address);
  await txn1.wait();


  let txn;
  txn = await talesContract.claim({ value: ethers.utils.parseEther("0.001") });
  await txn.wait();

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
