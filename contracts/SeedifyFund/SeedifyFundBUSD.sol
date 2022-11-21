/*
 *Seedify.fund
 *Decentralized Incubator
 *A disruptive blockchain incubator program / decentralized seed stage fund, empowered through DAO based community-involvement mechanisms
 */
pragma solidity ^0.8.17;

// SPDX-License-Identifier: UNLICENSED

import "../ERC20/IERC20.sol";
import "../Ownable/Context.sol";
import "../Ownable/Ownable.sol";
import "../ERC20/SafeERC20.sol";

//SeedifyFundsContract

contract SeedifyFundsContract is Ownable {
    using SafeERC20 for IERC20;

    //token attributes
    string public constant NAME = "Seedify.funds"; //name of the contract
    uint256 public immutable maxCap; // Max cap in BUSD
    uint256 public immutable saleStartTime; // start sale time
    uint256 public immutable saleEndTime; // end sale time
    uint256 public totalBUSDReceivedInAllTier; // total bnd received
    uint256[9] public totalBUSDInTiers; // total BUSD for tiers
    uint256 public totalparticipants; // total participants in ido
    uint256 public numberOfParticipants; // number of participants in ido
    address payable public immutable projectOwner; // project Owner
    uint256 public tokensPerBUSD;
    uint256 public refundThresholdTime;

    // max cap per tier
    uint256[9] public tiersMaxCap;

    //total users per tier
    uint256[9] public totalUserInTiers;

    //number of users per tier
    uint256[9] public numberOfUserInTiers;

    //max allocations per user in a tier
    uint256[9] public maxAllocaPerUserInTiers;

    //min allocation per user in a tier
    uint256[9] public minAllocaPerUserInTiers;

    // address array for tier one whitelist
    address[] private whitelistTierOne;

    // address array for tier two whitelist
    address[] private whitelistTierTwo;

    // address array for tier three whitelist
    address[] private whitelistTierThree;

    // address array for tier Four whitelist
    address[] private whitelistTierFour;

    // address array for tier Five whitelist
    address[] private whitelistTierFive;

    // address array for tier Six whitelist
    address[] private whitelistTierSix;

    // address array for tier Seven whitelist
    address[] private whitelistTierSeven;

    // address array for tier Eight whitelist
    address[] private whitelistTierEight;

    // address array for tier Nine whitelist
    address[] private whitelistTierNine;

    IERC20 public ERC20Interface;
    address public tokenAddress;
    address public IGOTokenAddress;
    IERC20 public IGOTokenInterface;

    struct FundUser {
        uint256 amountBUSD;
        uint256 amountIGOToken;
    }

    mapping(address => FundUser) public fundUser;

    //mapping the user purchase per tier
    mapping(address => uint256) public buyInOneTier;
    mapping(address => uint256) public buyInTwoTier;
    mapping(address => uint256) public buyInThreeTier;
    mapping(address => uint256) public buyInFourTier;
    mapping(address => uint256) public buyInFiveTier;
    mapping(address => uint256) public buyInSixTier;
    mapping(address => uint256) public buyInSevenTier;
    mapping(address => uint256) public buyInEightTier;
    mapping(address => uint256) public buyInNineTier;

    // CONSTRUCTOR
    constructor(
        uint256 _maxCap,
        uint256 _saleStartTime,
        uint256 _saleEndTime,
        address payable _projectOwner,
        uint256[9] memory _tiersValue,
        uint256 _totalparticipants,
        address _tokenAddress,
        address _IGOTokenAddress
    ) public {
        maxCap = _maxCap;

        require(
            _saleStartTime < _saleEndTime,
            "Sale start time should be less than sale end time"
        );
        saleStartTime = _saleStartTime;
        saleEndTime = _saleEndTime;

        require(_projectOwner != address(0), "Invalid project owner address");
        projectOwner = _projectOwner;

        for (uint256 i = 0; i < 9; i++) {
            require(_tiersValue[i] > 0, "Zero tier value");
            tiersMaxCap[i] = _tiersValue[i];
        }

        minAllocaPerUserInTiers[0] = 10000000000000;
        minAllocaPerUserInTiers[1] = 20000000000000;
        minAllocaPerUserInTiers[2] = 30000000000000;
        minAllocaPerUserInTiers[3] = 40000000000000;
        minAllocaPerUserInTiers[4] = 50000000000000;
        minAllocaPerUserInTiers[5] = 60000000000000;
        minAllocaPerUserInTiers[6] = 70000000000000;
        minAllocaPerUserInTiers[7] = 80000000000000;
        minAllocaPerUserInTiers[8] = 90000000000000;

        totalUserInTiers[0] = 5;
        totalUserInTiers[1] = 5;
        totalUserInTiers[2] = 5;
        totalUserInTiers[3] = 5;
        totalUserInTiers[4] = 5;
        totalUserInTiers[5] = 5;
        totalUserInTiers[6] = 5;
        totalUserInTiers[7] = 5;
        totalUserInTiers[8] = 5;

        for (uint256 i = 0; i < 9; i++) {
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];
            require(
                maxAllocaPerUserInTiers[i] >= minAllocaPerUserInTiers[i],
                "maxAllocPerUserInTiers should be always greater than or equal to minAllocaPerUserInTiers"
            );
        }

        totalparticipants = _totalparticipants;
        refundThresholdTime = block.timestamp + 86400; // 24 hours in seconds
        tokensPerBUSD = 10;

        require(_tokenAddress != address(0), "Zero token address"); //Adding token to the contract
        tokenAddress = _tokenAddress;
        ERC20Interface = IERC20(tokenAddress);

        require(_IGOTokenAddress != address(0), "Zero IGO token address"); //Adding token to the contract
        IGOTokenAddress = _IGOTokenAddress;
        IGOTokenInterface = IERC20(IGOTokenAddress);
    }

    // function to update the tiers value manually
    function updateTierValues(uint256[9] memory _tiersValue)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < 9; i++) {
            require(_tiersValue[i] > 0, "Zero tier value");

            tiersMaxCap[i] = _tiersValue[i];
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];

            require(
                maxAllocaPerUserInTiers[i] >= minAllocaPerUserInTiers[i],
                "maxAllocPerUserInTiers should be always greater than or equal to minAllocaPerUserInTiers"
            );
        }
    }

    // function to update the tiers users value manually
    function updateTierUsersValue(uint256[9] memory _tiersUsersValue)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < 9; i++) {
            require(_tiersUsersValue[i] > 0, "Zero tier user value");

            totalUserInTiers[i] = _tiersUsersValue[i];
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];

            require(
                maxAllocaPerUserInTiers[i] >= minAllocaPerUserInTiers[i],
                "maxAllocPerUserInTiers should be always greater than or equal to minAllocaPerUserInTiers"
            );
        }
    }

    //add the address in Whitelist tier to invest
    function addWhitelist(uint256 _tier, address _address) external onlyOwner {
        require(_tier >= 1 && _tier <= 9, "Invalid Tier. Try (1-9)");
        require(_address != address(0), "Invalid address");

        if (getWhitelist(_tier, _address))
        {
            revert("Already whitelisted");
        }
        else
        {
            require(
                numberOfParticipants + 1 <= totalparticipants,
                "Participants max limit reached"
            );
            require(
                numberOfUserInTiers[_tier - 1] + 1 <= totalUserInTiers[_tier - 1],
                "Tier max limit reached"
            );

            if (_tier == 1) whitelistTierOne.push(_address);
            else if (_tier == 2) whitelistTierTwo.push(_address);
            else if (_tier == 3) whitelistTierThree.push(_address);
            else if (_tier == 4) whitelistTierFour.push(_address);
            else if (_tier == 5) whitelistTierFive.push(_address);
            else if (_tier == 6) whitelistTierSix.push(_address);
            else if (_tier == 7) whitelistTierSeven.push(_address);
            else if (_tier == 8) whitelistTierEight.push(_address);
            else if (_tier == 9) whitelistTierNine.push(_address);

            numberOfParticipants += 1;
            numberOfUserInTiers[_tier - 1] += 1;
        }
    }

    // check the address in whitelist tier
    function getWhitelist(uint256 _tier, address _address)
        public
        view
        returns (bool)
    {
        require(_tier >= 1 && _tier <= 9, "Invalid Tier. Try (1-9)");
        require(_address != address(0), "Invalid address");

        address[] memory _whitelistTier;

        if (_tier == 1) _whitelistTier = whitelistTierOne;
        else if (_tier == 2) _whitelistTier = whitelistTierTwo;
        else if (_tier == 3) _whitelistTier = whitelistTierThree;
        else if (_tier == 4) _whitelistTier = whitelistTierFour;
        else if (_tier == 5) _whitelistTier = whitelistTierFive;
        else if (_tier == 6) _whitelistTier = whitelistTierSix;
        else if (_tier == 7) _whitelistTier = whitelistTierSeven;
        else if (_tier == 8) _whitelistTier = whitelistTierEight;
        else if (_tier == 9) _whitelistTier = whitelistTierNine;

        for (uint256 i = 0; i < _whitelistTier.length; i++) {
            address _addressArr = _whitelistTier[i];
            if (_addressArr == _address) {
                return true;
            }
        }
        return false;
    }

    modifier _hasAllowance(address allower, uint256 amount) {
        // Make sure the allower has provided the right allowance.
        // ERC20Interface = IERC20(tokenAddress);
        uint256 ourAllowance = ERC20Interface.allowance(allower, address(this));
        require(amount <= ourAllowance, "Make sure to add enough allowance");
        _;
    }

    function buyTokens(uint256 tier, uint256 amount)
        external
        _hasAllowance(msg.sender, amount)
        returns (bool)
    {
        require(tier >= 1 && tier <= 9, "Invalid Tier. Try (1-9)");
        require(amount > 0, "Amount should be greater than zero");

        require(
            block.timestamp >= saleStartTime,
            "The sale is not started yet "
        );
        require(block.timestamp <= saleEndTime, "The sale is closed");
        require(
            totalBUSDReceivedInAllTier + amount <= maxCap,
            "buyTokens: purchase would exceed max cap"
        );

        uint256 tokensToBuy = amount * tokensPerBUSD;

        // Check owner's token balance
        uint256 ownerBalance = IGOTokenInterface.balanceOf(projectOwner);
        require(ownerBalance >= tokensToBuy, "Owner has insufficient tokens");

        // Check contract token allowance
        uint256 allowance = IGOTokenInterface.allowance(
            projectOwner,
            address(this)
        );
        require(
            tokensToBuy <= allowance,
            "Make sure to add enough allowance from owner to contract"
        );

        uint256 buyInTierAmount;

        if (getWhitelist(tier, msg.sender)) {
            if (tier == 1) {
                buyInOneTier[msg.sender] += amount;
                buyInTierAmount = buyInOneTier[msg.sender];
            }
            else if (tier == 2) {
                buyInTwoTier[msg.sender] += amount;
                buyInTierAmount = buyInTwoTier[msg.sender];
            }
            else if (tier == 3) {
                buyInThreeTier[msg.sender] += amount;
                buyInTierAmount = buyInThreeTier[msg.sender];
            }
            else if (tier == 4) {
                buyInFourTier[msg.sender] += amount;
                buyInTierAmount = buyInFourTier[msg.sender];
            }
            else if (tier == 5) {
                buyInFiveTier[msg.sender] += amount;
                buyInTierAmount = buyInFiveTier[msg.sender];
            }
            else if (tier == 6) {
                buyInSixTier[msg.sender] += amount;
                buyInTierAmount = buyInSixTier[msg.sender];
            }
            else if (tier == 7) {
                buyInSevenTier[msg.sender] += amount;
                buyInTierAmount = buyInSevenTier[msg.sender];
            }
            else if (tier == 8) {
                buyInEightTier[msg.sender] += amount;
                buyInTierAmount = buyInEightTier[msg.sender];
            }
            else if (tier == 9) {
                buyInNineTier[msg.sender] += amount;
                buyInTierAmount = buyInNineTier[msg.sender];
            }

            require(
                buyInTierAmount >= minAllocaPerUserInTiers[tier - 1],
                "your purchasing Power is so Low"
            );

            require(
                buyInTierAmount <= maxAllocaPerUserInTiers[tier - 1],
                "buyTokens:You are investing more than your tier limit!"
            );

            require(
                totalBUSDInTiers[tier - 1] + amount <= tiersMaxCap[tier - 1],
                "buyTokens: purchase would exceed Tier one max cap"
            );

            totalBUSDReceivedInAllTier += amount;
            totalBUSDInTiers[tier - 1] += amount;
            fundUser[msg.sender].amountBUSD += amount;
            fundUser[msg.sender].amountIGOToken += tokensToBuy;
            ERC20Interface.safeTransferFrom(msg.sender, projectOwner, amount); //transfer BUSD to owner
            IGOTokenInterface.safeTransferFrom(projectOwner, msg.sender, tokensToBuy); //transfer tokens to msg.sender
        } else {
            revert("Not whitelisted");
        }
        return true;
    }

    function setRefundThresholdTime(uint256 _refundThresholdTime)
        external
        onlyOwner
    {
        refundThresholdTime = _refundThresholdTime;
    }

    function refund() external {
        require(block.timestamp < refundThresholdTime, "Refund not allowed");
        
        uint256 tokens = fundUser[msg.sender].amountIGOToken;
        require(tokens > 0, "Insufficient Tokens");

        uint256 allowance = IGOTokenInterface.allowance(msg.sender,address(this));
        require( allowance >= tokens, "IGOTokenInterface: Check the token allowance");

        uint256 amount = tokens / tokensPerBUSD;

        uint256 balance = ERC20Interface.balanceOf(projectOwner);
        require(balance >= amount, "Insufficient Balance");

        uint256 ownerAllowance = ERC20Interface.allowance(projectOwner,address(this));
        require(ownerAllowance >= amount, "ERC20Interface: Check the amount allowance");

        if(buyInOneTier[msg.sender] > 0)
        {
            totalBUSDInTiers[0] -= buyInOneTier[msg.sender];
            buyInOneTier[msg.sender] = 0;
        }
        else if(buyInTwoTier[msg.sender] > 0)
        {
            totalBUSDInTiers[1] -= buyInTwoTier[msg.sender];
            buyInTwoTier[msg.sender] = 0;
        }
        else if(buyInThreeTier[msg.sender] > 0)
        {
            totalBUSDInTiers[2] -= buyInThreeTier[msg.sender];
            buyInThreeTier[msg.sender] = 0;
        }
        else if(buyInFourTier[msg.sender] > 0)
        {
            totalBUSDInTiers[3] -= buyInFourTier[msg.sender];
            buyInFourTier[msg.sender] = 0;
        }
        else if(buyInFiveTier[msg.sender] > 0)
        {
            totalBUSDInTiers[4] -= buyInFiveTier[msg.sender];
            buyInFiveTier[msg.sender] = 0;
        }
        else if(buyInSixTier[msg.sender] > 0)
        {
            totalBUSDInTiers[5] -= buyInSixTier[msg.sender];
            buyInSixTier[msg.sender] = 0;
        }
        else if(buyInSevenTier[msg.sender] > 0)
        {
            totalBUSDInTiers[6] -= buyInSevenTier[msg.sender];
            buyInSevenTier[msg.sender] = 0;
        }
        else if(buyInEightTier[msg.sender] > 0)
        {
            totalBUSDInTiers[7] -= buyInEightTier[msg.sender];
            buyInEightTier[msg.sender] = 0;
        }
        else if(buyInNineTier[msg.sender] > 0)
        {
            totalBUSDInTiers[8] -= buyInNineTier[msg.sender];
            buyInNineTier[msg.sender] = 0;
        }
        
        totalBUSDReceivedInAllTier -= amount;
        fundUser[msg.sender].amountBUSD = 0;
        fundUser[msg.sender].amountIGOToken = 0;
        IGOTokenInterface.safeTransferFrom(msg.sender,projectOwner,tokens); //transfer tokens to owner
        ERC20Interface.safeTransferFrom(projectOwner, msg.sender, amount); //transfer BUSD to msg.sender
    }
}
