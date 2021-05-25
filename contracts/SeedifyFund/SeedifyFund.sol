/*
*Seedify.fund
*Decentralized Incubator
*A disruptive blockchain incubator program / decentralized seed stage fund, empowered through DAO based community-involvement mechanisms
*/
pragma solidity ^0.6.0;

// SPDX-License-Identifier: MIT

import "../Ownable/Ownable.sol";

//SeedifyFundsContract

contract SeedifyFundsContract is Ownable {

  //token attributes
  string public constant NAME = "Seedify.funds"; //name of the contract
  uint public immutable maxCap; // Max cap in BNB
  uint256 public immutable saleStartTime; // start sale time
  uint256 public immutable saleEndTime; // end sale time
  uint256 public totalBnbReceived; // total bnd received
  address payable public projectOwner;
  // tiers limit
  uint public oneTier;  // value in bnb
  uint public twoTier ; // value in bnb
  uint public threeTier;  // value in bnb
  // tiers Aarry length
  uint public oneTierArrLength = 0;  // Aarry length of tier one
  uint public twoTierArrLength = 0; // Aarry length of tier two
  uint public threeTierArrLength = 0;  // Aarry length of tier three
 
  // address array for tier one whitelist
  address[] private whitelistTierOne; 
  
  // address array for tier two whitelist
  address[] private whitelistTierTwo; 
  
  // address array for tier three whitelist
  address[] private whitelistTierThree; 


  // CONSTRUCTOR  
  constructor(uint _maxCap, uint256 _saleStartTime, uint256 _saleEndTime,uint _oneTier,uint _twoTier,uint _threeTier, address payable _projectOwner) public {
    maxCap = _maxCap* 10 ** 18;
    saleStartTime = _saleStartTime;
    saleEndTime = _saleEndTime;
    oneTier =_oneTier* 10 ** 18;
    twoTier = _twoTier * 10 ** 18;
    threeTier =_threeTier* 10 ** 18;
    projectOwner = _projectOwner;
  }

  // function to update the tiers value manually
  function updateTierValues(uint256 _tierOneValue, uint256 _tierTwoValue, uint256 _tierThreeValue) external onlyOwner {
    oneTier =_tierOneValue* 10 ** 18;
    twoTier = _tierTwoValue * 10 ** 18;
    threeTier =_tierThreeValue* 10 ** 18;
  }

  //add the address in Whitelist tier One to invest
  function addWhitelistOne(address _address) external onlyOwner {
    require(_address != address(0), "Invalid address");
    whitelistTierOne.push(_address);
    oneTierArrLength += 1;
  }

  //add the address in Whitelist tier two to invest
  function addWhitelistTwo(address _address) external onlyOwner {
    require(_address != address(0), "Invalid address");
    whitelistTierTwo.push(_address);
    twoTierArrLength += 1;
  }

  //add the address in Whitelist tier three to invest
  function addWhitelistThree(address _address) external onlyOwner {
    require(_address != address(0), "Invalid address");
    whitelistTierThree.push(_address);
    threeTierArrLength += 1;
  }

  // check the address in whitelist tier one
  function getWhitelistOne(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < oneTierArrLength; i++) {
      address _addressArr = whitelistTierOne[i];
      if (_addressArr == _address) {
        return true;
      }
    }
    return false;
  }

  // check the address in whitelist tier two
  function getWhitelistTwo(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < twoTierArrLength; i++) {
      address _addressArr = whitelistTierTwo[i];
      if (_addressArr == _address) {
        return true;
      }
    }
    return false;
  }

  // check the address in whitelist tier three
  function getWhitelistThree(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < threeTierArrLength; i++) {
      address _addressArr = whitelistTierThree[i];
      if (_addressArr == _address) {
        return true;
      }
    }
    return false;
  }
    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
  // send bnb to the contract address
  receive() external payable {
     require(now >= saleStartTime, "The sale is not started yet "); // solhint-disable
     require(now <= saleEndTime, "The sale is closed"); // solhint-disable
     
    if (msg.value <= oneTier) { // smaller and Equal to 1st tier BNB 
      require(getWhitelistOne(msg.sender), 'This address is not whitelisted');
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      sendValue(projectOwner, address(this).balance);
      
    } else if (msg.value > oneTier && msg.value <= twoTier) { // Greater than 1st and smaller/equal to 2nd tier bnb
      require(getWhitelistTwo(msg.sender) == true);
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      sendValue(projectOwner, address(this).balance);
      
    } else if (msg.value > twoTier && msg.value <= threeTier) { // Greater than 2nd and smaller/equal to 3rd tier bnb
      require(getWhitelistThree(msg.sender) == true);
      require(totalBnbReceived + msg.value <= maxCap, "buyTokens: purchase would exceed max cap");
      totalBnbReceived += msg.value;
      sendValue(projectOwner, address(this).balance);
      
    } else {
      revert();
    }
  }
}