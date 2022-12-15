const hre = require("hardhat");
import {
    expandTo18Decimals,
    expandTo6Decimals,
  } from "../test/utilities/utilities";

async function main() {

    console.log("after");
  
    await hre.run("verify:verify", {
        address: "0xCd7A4B51b1b21235E18290FDF1874A1f6d20eA4A",
        constructorArguments: ["0x69015912AA33720b842dCD6aC059Ed623F28d9f7"],
        contract: "contracts/SwapToken.sol:SwapToken",
      });
    
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});