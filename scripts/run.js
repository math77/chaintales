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

  /*
  let txn;
  // We only have three characters.
  // an NFT w/ the character at index 2 of our array.
  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();
  
  txn = await gameContract.attackBoss();
  await txn.wait();
  */

  let txn;
  txn = await talesContract.claim({ value: ethers.utils.parseEther("0.5") });
  await txn.wait();

  
  txn = await talesContract.claim({ value: ethers.utils.parseEther("0.5") });
  await txn.wait();


  txn = await talesContract.claim({ value: ethers.utils.parseEther("0.5") });
  await txn.wait();

  // Get the value of the NFT's URI.
  let returnedTokenUri = await talesContract.tokenURI(1);
  let returnedTokenUri2 = await talesContract.tokenURI(2);
  let returnedTokenUri3 = await talesContract.tokenURI(3);
  console.log("Token URI 1:", returnedTokenUri);
  console.log("Token URI 2:", returnedTokenUri2);
  console.log("Token URI 3:", returnedTokenUri3);

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
