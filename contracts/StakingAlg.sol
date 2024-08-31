// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20Metadata.sol";

contract StakingAlg {
    IERC20Metadata public rewardsToken;
    IERC20Metadata public stakingToken;

    uint public rewardRate = 10;
    uint public lastUpdateTime;
    uint public rewardPerTokenStored;


    mapping (address staker => uint reward) public userRewardPerTokenPaid;
    mapping (address staker => uint reward) public rewards;

    mapping(address => uint) private _balances;
    uint private _totalSupply;

    constructor(address _stakingToken, address _rewardsToken) {
        stakingToken = IERC20Metadata(_stakingToken);
        rewardsToken = IERC20Metadata(_rewardsToken);
    }

    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        rewards[_account] = earned(_account);
        userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        _;
    }

    function stake(uint _amount) external updateReward(msg.sender) {
        _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender){
        require(_balances[msg.sender] >= _amount, "amount to withdraw is more than token balance");
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function getReward() external updateReward(msg.sender){
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);

    }

    function rewardPerToken() public view returns(uint) {
        if(_totalSupply == 0) {
            return 0;
        }
        return rewardPerTokenStored + ((rewardRate * (block.timestamp - lastUpdateTime)) * 1e18) / _totalSupply;
    }

    function earned(address _account) public view returns (uint) {
        return (_balances[msg.sender] * (rewardPerToken() - userRewardPerTokenPaid[_account]) / 1e18 ) + rewards[_account];
    }
}