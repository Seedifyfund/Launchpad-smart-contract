// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
import "../Ownable/Ownable.sol";

//SeedifyFundsContract

contract SeedifyFundsContract is Ownable {

  //token attributes
  string public name = "Seedify.funds"; //name of the contract
  uint public maxCap = 10000; // Max cap in BNB
  uint256 public saleStartTime; // start sale time
  uint256 public saleEndTime; // end sale time
  uint256 public totalBnbReceived; // total bnd received
  address payable public projectOwner;
  // tiers limit
  uint public oneTier;  // value in bnb
  uint public twoTier ; // value in bnb
  uint public threeTier;  // value in bnb

  // Structure for tier one
  struct TierOne {
    address[] _address;
  }
  // Structure for tier two
  struct TierTwo {
    address[] _address;
  }
  // Structure for tier two
  struct TierThree {
    address[] _address;
  }

  // different tiers to whitelist address  
  TierOne[] internal whitelistTierOne;
  TierTwo[] internal whitelistTierTwo;
  TierThree[] internal whitelistTierThree;


  // CONSTRUCTOR  

  // CONSTRUCTOR  
  constructor() public {
    maxCap = 100000 * 10**18;
    saleStartTime = now;
    saleEndTime = now + 86400;
    oneTier = 1; // 1 bnb
    twoTier = 3; // 3 bnb
    threeTier = 5; // 5 bnb
    projectOwner = 0x5AedaE68CcCd22dA73D62A732FAf5f5F8304B7B6;
  }

  // function to update the tiers value manually
  function updateTierValues(uint256 _tierOneValue, uint256 _tierTwoValue, uint256 _tierThreeValue) external onlyOwner {
    oneTier =_tierOneValue* 10 ** 18;
    twoTier = _tierTwoValue * 10 ** 18;
    threeTier =_tierThreeValue* 10 ** 18;
  }

  //add the address in Whitelist tier One to invest
  function addWhitelistOne(address[] memory _address) external onlyOwner {
    uint i;
    for(i= 1; i<= _address.length ; i++){
    TierOne memory a = TierOne(_address);
    whitelistTierOne.push(a);
    }
  }

  //add the address in Whitelist tier two to invest
  function addWhitelistTwo(address[] memory _address) external onlyOwner {
    uint i;
    for(i= 1; i<= _address.length ; i++){
    TierTwo memory b = TierTwo(_address);
    whitelistTierTwo.push(b);
    }
  }

  //add the address in Whitelist tier three to invest
  function addWhitelistThree(address[] memory _address) external onlyOwner {
    uint i;
    for(i= 1; i<= _address.length ; i++){
    TierThree memory c = TierThree(_address);
    whitelistTierThree.push(c);
    }
  }

  // check the address in whitelist tier one
  function getWhitelistOne(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < whitelistTierOne.length; i++) {
      TierOne memory a = whitelistTierOne[i];
      if (a._address[i] == _address) {
        return true;
      }
    }
    return false;
  }

  // check the address in whitelist tier two
  function getWhitelistTwo(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < whitelistTierTwo.length; i++) {
      TierTwo memory b = whitelistTierTwo[i];
      if (b._address[i] == _address) {
        return true;
      }
    }
    return false;
  }

  // check the address in whitelist tier three
  function getWhitelistThree(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < whitelistTierThree.length; i++) {
      TierThree memory c = whitelistTierThree[i];
      if (c._address[i] == _address) {
        return true;
      }
    }
    return false;
  }

  // send bnb to the contract address
  receive() external payable {
     require(now >= saleStartTime, "The sale is not started yet "); // solhint-disable
     require(now <= saleEndTime, "The sale is closed"); // solhint-disable
     
    if (msg.value <= oneTier) { // smaller and Equal to 1st tier BNB 
      require(getWhitelistOne(msg.sender) == true);
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      projectOwner.transfer(address(this).balance);
      
    } else if (msg.value > oneTier && msg.value <= twoTier) { // Greater than 1st and smaller/equal to 2nd tier bnb
      require(getWhitelistTwo(msg.sender) == true);
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      projectOwner.transfer(address(this).balance);
      
    } else if (msg.value > twoTier && msg.value <= threeTier) { // Greater than 2nd and smaller/equal to 3rd tier bnb
      require(getWhitelistThree(msg.sender) == true);
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      projectOwner.transfer(address(this).balance);
      
    } else {
      revert();
    }
  }
}