/*
 *Seedify.fund
 *Decentralized Incubator
 *A disruptive blockchain incubator program / decentralized seed stage fund, empowered through DAO based community-involvement mechanisms
 */
pragma solidity ^0.8.17;

// SPDX-License-Identifier: UNLICENSED

import "../Ownable/Ownable.sol";

//SeedifyFundsContract

contract SeedifyFundsContract is Ownable {
    //token attributes
    string public constant NAME = "Seedify.funds"; //name of the contract
    uint256 public immutable maxCap; // Max cap in BNB
    uint256 public immutable saleStartTime; // start sale time
    uint256 public immutable saleEndTime; // end sale time
    uint256 public totalBnbReceivedInAllTier; // total bnd received
    uint256[9] public totalBNBInTiers; // total BNB for tiers
    uint256 public totalparticipants; // total participants in ido
    address payable public projectOwner; // project Owner

        // max cap per tier
    uint256[9] public tiersMaxCap;

    //total users per tier
    uint256[9] public totalUserInTiers;

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

    // address array for tier three whitelist
    address[] private whitelistTierFive;

    // address array for tier three whitelist
    address[] private whitelistTierSix;

    // address array for tier three whitelist
    address[] private whitelistTierSeven;

    // address array for tier three whitelist
    address[] private whitelistTierEight;

    // address array for tier three whitelist
    address[] private whitelistTierNine;

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

    //mapping the user purchase per tier
    mapping(address => uint256) public minBuyInOneTier;
    mapping(address => uint256) public minBuyInTwoTier;
    mapping(address => uint256) public minBuyInThreeTier;
    mapping(address => uint256) public minBuyInFourTier;
    mapping(address => uint256) public minBuyInFiveTier;
    mapping(address => uint256) public minBuyInSixTier;
    mapping(address => uint256) public minBuyInSevenTier;
    mapping(address => uint256) public minBuyInEightTier;
    mapping(address => uint256) public minBuyInNineTier;

    // CONSTRUCTOR
    constructor(
        uint256 _maxCap,
        uint256 _saleStartTime,
        uint256 _saleEndTime,
        address payable _projectOwner,
        uint256[9] memory _tiersValue,
        uint256 _totalparticipants
    ) public {
        maxCap = _maxCap;
        saleStartTime = _saleStartTime;
        saleEndTime = _saleEndTime;

        projectOwner = _projectOwner;
        
        for (uint256 i = 0; i < 9; i++) {
            tiersMaxCap[i] = _tiersValue[i];
        }

        minAllocaPerUserInTiers[0] = 10000000000000;
        minAllocaPerUserInTiers[1] = 10000000000000;
        minAllocaPerUserInTiers[2] = 10000000000000;
        minAllocaPerUserInTiers[3] = 10000000000000;
        minAllocaPerUserInTiers[4] = 10000000000000;
        minAllocaPerUserInTiers[5] = 10000000000000;
        minAllocaPerUserInTiers[6] = 10000000000000;
        minAllocaPerUserInTiers[7] = 10000000000000;
        minAllocaPerUserInTiers[8] = 10000000000000;

        totalUserInTiers[0] = 669;
        totalUserInTiers[1] = 494;
        totalUserInTiers[2] = 1;
        totalUserInTiers[3] = 1;
        totalUserInTiers[4] = 1;
        totalUserInTiers[5] = 1;
        totalUserInTiers[6] = 1;
        totalUserInTiers[7] = 1;
        totalUserInTiers[8] = 1;

        for (uint256 i = 0; i < 9; i++) {
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];
        }

        totalparticipants = _totalparticipants;
    }

    // function to update the tiers value manually
    function updateTierValues(
        uint256[9] memory _tiersValue
    ) external onlyOwner {
        for (uint256 i = 0; i < 9; i++) {
            tiersMaxCap[i] = _tiersValue[i];
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];
        }
    }

    // function to update the tiers users value manually
    function updateTierUsersValue(
        uint256[9] memory _tiersUsersValue
    ) external onlyOwner {
        for (uint256 i = 0; i < 9; i++) {
            totalUserInTiers[i] = _tiersUsersValue[i];
            maxAllocaPerUserInTiers[i] = tiersMaxCap[i] / totalUserInTiers[i];
        }
    }

    //add the address in Whitelist tier to invest
    function addWhitelist(uint256 _tier, address _address) external onlyOwner {
        require(_tier >= 1 && _tier <= 9, "Invalid Tier. Try (1-9)");
        require(_address != address(0), "Invalid address");

        if (_tier == 1) whitelistTierOne.push(_address);
        else if (_tier == 2) whitelistTierTwo.push(_address);
        else if (_tier == 3) whitelistTierThree.push(_address);
        else if (_tier == 4) whitelistTierFour.push(_address);
        else if (_tier == 5) whitelistTierFive.push(_address);
        else if (_tier == 6) whitelistTierSix.push(_address);
        else if (_tier == 7) whitelistTierSeven.push(_address);
        else if (_tier == 8) whitelistTierEight.push(_address);
        else if (_tier == 9) whitelistTierNine.push(_address);
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
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    // send bnb to the contract address
    receive() external payable {
        require(block.timestamp >= saleStartTime, "The sale is not started yet "); // solhint-disable
        require(block.timestamp <= saleEndTime, "The sale is closed"); // solhint-disable
        require(
            totalBnbReceivedInAllTier + msg.value <= maxCap,
            "buyTokens: purchase would exceed max cap"
        );

        if (getWhitelist(1, msg.sender)) {
            minBuyInOneTier[msg.sender] += msg.value;
            require(
                minBuyInOneTier[msg.sender] >= minAllocaPerUserInTiers[0],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[0] + msg.value <= tiersMaxCap[0],
                "buyTokens: purchase would exceed Tier one max cap"
            );
            require(
                buyInOneTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[0],
                "buyTokens:You are investing more than your tier-1 limit!"
            );

            buyInOneTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[0] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(2, msg.sender)) {
            minBuyInTwoTier[msg.sender] += msg.value;
            require(
                minBuyInTwoTier[msg.sender] >= minAllocaPerUserInTiers[1],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[1] + msg.value <= tiersMaxCap[1],
                "buyTokens: purchase would exceed Tier two max cap"
            );
            require(
                buyInTwoTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[1],
                "buyTokens:You are investing more than your tier-2 limit!"
            );

            buyInTwoTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[1] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(3, msg.sender)) {
            minBuyInThreeTier[msg.sender] += msg.value;
            require(
                minBuyInThreeTier[msg.sender] >= minAllocaPerUserInTiers[2],
                "your purchasing Power is so Low"
            );
            require(
                buyInThreeTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[2],
                "buyTokens:You are investing more than your tier-3 limit!"
            );
            require(
                totalBNBInTiers[2] + msg.value <= tiersMaxCap[2],
                "buyTokens: purchase would exceed Tier three max cap"
            );

            buyInThreeTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[2] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(4, msg.sender)) {
            minBuyInFourTier[msg.sender] += msg.value;
            require(
                minBuyInFourTier[msg.sender] >= minAllocaPerUserInTiers[3],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[3] + msg.value <= tiersMaxCap[3],
                "buyTokens: purchase would exceed Tier Four max cap"
            );
            require(
                buyInFourTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[3],
                "buyTokens:You are investing more than your tier-4 limit!"
            );
            buyInFourTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[3] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(5, msg.sender)) {
            minBuyInFiveTier[msg.sender] += msg.value;
            require(
                minBuyInFiveTier[msg.sender] >= minAllocaPerUserInTiers[4],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[4] + msg.value <= tiersMaxCap[4],
                "buyTokens: purchase would exceed Tier Five max cap"
            );
            require(
                buyInFiveTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[4],
                "buyTokens:You are investing more than your tier-5 limit!"
            );
            buyInFiveTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[4] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(6, msg.sender)) {
            minBuyInSixTier[msg.sender] += msg.value;
            require(
                minBuyInSixTier[msg.sender] >= minAllocaPerUserInTiers[5],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[5] + msg.value <= tiersMaxCap[5],
                "buyTokens: purchase would exceed Tier Six max cap"
            );
            require(
                buyInSixTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[5],
                "buyTokens:You are investing more than your tier-6 limit!"
            );
            buyInSixTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[5] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(7, msg.sender)) {
            minBuyInSevenTier[msg.sender] += msg.value;
            require(
                minBuyInSevenTier[msg.sender] >= minAllocaPerUserInTiers[6],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[6] + msg.value <= tiersMaxCap[6],
                "buyTokens: purchase would exceed Tier Seven max cap"
            );
            require(
                buyInSevenTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[6],
                "buyTokens:You are investing more than your tier-7 limit!"
            );
            buyInSevenTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[6] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(8, msg.sender)) {
            minBuyInEightTier[msg.sender] += msg.value;
            require(
                minBuyInEightTier[msg.sender] >= minAllocaPerUserInTiers[7],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[7] + msg.value <= tiersMaxCap[7],
                "buyTokens: purchase would exceed Tier Eight max cap"
            );
            require(
                buyInEightTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[7],
                "buyTokens:You are investing more than your tier-8 limit!"
            );
            buyInEightTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[7] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else if (getWhitelist(9, msg.sender)) {
            minBuyInNineTier[msg.sender] += msg.value;
            require(
                minBuyInNineTier[msg.sender] >= minAllocaPerUserInTiers[8],
                "your purchasing Power is so Low"
            );
            require(
                totalBNBInTiers[8] + msg.value <= tiersMaxCap[8],
                "buyTokens: purchase would exceed Tier Nine max cap"
            );
            require(
                buyInNineTier[msg.sender] + msg.value <= maxAllocaPerUserInTiers[8],
                "buyTokens:You are investing more than your tier-9 limit!"
            );
            buyInNineTier[msg.sender] += msg.value;
            totalBnbReceivedInAllTier += msg.value;
            totalBNBInTiers[8] += msg.value;
            sendValue(projectOwner, address(this).balance);
        } else {
            revert();
        }
    }
}
