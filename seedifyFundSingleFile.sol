pragma solidity >=0.4.25;

//OWnABLE contract that define owning functionality
contract Ownable {
  address public owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
  constructor() public {
    owner = msg.sender;
  }

  /**
    * @dev Throws if called by any account other than the owner.
    */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}

//SeedifyFundsContract

contract SeedifyFundsContract is Ownable {

  //token attributes
  string public name = "Seedify.funds"; //name of the contract
  uint public maxCap; // Max cap in BNB
  uint256 public saleStartTime; // start sale time
  uint256 public saleEndTime; // end sale time
  uint256 public totalBnbReceived; // total bnd received

  // tiers limit
  uint public oneTier;  // value in bnb
  uint public twoTier ; // value in bnb
  uint public threeTier;  // value in bnb

  // Structure for tier one
  struct TierOne {
    address _address;
  }
  // Structure for tier two
  struct TierTwo {
    address _address;
  }
  // Structure for tier two
  struct TierThree {
    address _address;
  }

  // different tiers to whitelist address  
  TierOne[] internal whitelistTierOne;
  TierTwo[] internal whitelistTierTwo;
  TierThree[] internal whitelistTierThree;

  bool public isTokenSaleActive = false; // Flag to track the TokenSale active or not
  enum State {
    TokenSale
  }

  // CONSTRUCTOR for Distribution 

  constructor(uint _maxCap, uint256 _saleStartTime, uint256 _saleEndTime,uint _oneTier,uint _twoTier,uint _threeTier) public {
    maxCap = _maxCap;
    saleStartTime = _saleStartTime;
    saleEndTime = _saleEndTime;
    oneTier =_oneTier* 10 ** 18;
    twoTier = _twoTier * 10 ** 18;
    threeTier =_threeTier* 10 ** 18;
  }

  // startTokenSale function use to start the crowdfund
  function startTokenSale() public onlyOwner returns(bool) {
    isTokenSaleActive = !isTokenSaleActive;
    return true;
  }

  // function to end the crowdfund
  function endTokenSale() public onlyOwner returns(bool) {
    if (isTokenSaleActive = true) {
      isTokenSaleActive = false;
      return true;
    }
    return false;
  }

  // function to get the current state of the token sale
  function getState() internal constant returns(State) {
    if (isTokenSaleActive) {
      return State.TokenSale;
    }
  }

  // function to update the tiers value manually
  function updateTierValues(uint256 _tierOneValue, uint256 _tierTwoValue, uint256 _tierThreeValue) external onlyOwner {
    oneTier = _tierOneValue;
    twoTier = _tierTwoValue;
    threeTier = _tierThreeValue;
  }

  // function to transfer the funds to owner account
  function fundTransfer(uint256 weiAmount) internal {
    owner.transfer(weiAmount);
  }

  //add the address in Whitelist tier One to invest
  function addWhitelistOne(address _address) public {
    require(msg.sender == owner, "Only owner has the right to perform this action");
    TierOne memory a = TierOne(_address);
    whitelistTierOne.push(a);
  }

  //add the address in Whitelist tier two to invest
  function addWhitelistTwo(address _address) public {
    require(msg.sender == owner, "Only owner has the right to perform this action");
    TierTwo memory b = TierTwo(_address);
    whitelistTierTwo.push(b);
  }

  //add the address in Whitelist tier three to invest
  function addWhitelistThree(address _address) public {
    require(msg.sender == owner, "Only owner has the right to perform this action");
    TierThree memory c = TierThree(_address);
    whitelistTierThree.push(c);
  }

  // check the address in whitelist tier one
  function getWhitelistOne(address _address) public view returns(bool) {
    uint i;
    for (i = 0; i < whitelistTierOne.length; i++) {
      TierOne memory a = whitelistTierOne[i];
      if (a._address == _address) {
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
      if (b._address == _address) {
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
      if (c._address == _address) {
        return true;
      }
    }
    return false;
  }

  // Invest will check the conditions and distribute the amounts
  function invest(uint256 value) public returns(bool) {
    require(isTokenSaleActive != false);

    if (value <= oneTier) { // smaller and Equal to 1st tier BNB 
      require(getWhitelistOne(msg.sender) == true);
     require(totalBnbReceived + value <= maxCap, "buyTokens: purchase would exceed max cap");
    totalBnbReceived += value;
      fundTransfer(value);
      return true;
    } else if (value > oneTier && value <= twoTier) { // Greater than 1st and smaller/equal to 2nd tier bnb
      require(getWhitelistTwo(msg.sender) == true);
          require(totalBnbReceived + value <= maxCap, "buyTokens: purchase would exceed max cap");
    totalBnbReceived += value;
      fundTransfer(value);
      return true;
    } else if (value > twoTier && value <= threeTier) { // Greater than 2nd and smaller/equal to 3rd tier bnb
      require(getWhitelistThree(msg.sender) == true);
          require(totalBnbReceived + value <= maxCap, "buyTokens: purchase would exceed max cap");
    totalBnbReceived += value;
      fundTransfer(value);
      return true;
    } else {
      revert();
    }
  }

  // send bnb to the contract address
  function() public payable {
    invest(msg.value);
  }
}