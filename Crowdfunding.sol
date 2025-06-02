// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Crowdfunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint goal;
        uint pledged;
        uint deadline;
        bool claimed;
        mapping(address => uint) contributions;
    }

    uint public campaignCount;
    mapping(uint => Campaign) public campaigns;

    event CampaignCreated(uint campaignId, address owner, string title, uint goal, uint deadline);
    event Pledged(uint campaignId, address contributor, uint amount);
    event FundsClaimed(uint campaignId);

    function createCampaign(string calldata _title, string calldata _description, uint _goal, uint _duration) external {
        campaignCount++;
        Campaign storage c = campaigns[campaignCount];
        c.owner = msg.sender;
        c.title = _title;
        c.description = _description;
        c.goal = _goal;
        c.deadline = block.timestamp + _duration;
        emit CampaignCreated(campaignCount, msg.sender, _title, _goal, c.deadline);
    }

    function pledge(uint _campaignId) external payable {
        Campaign storage c = campaigns[_campaignId];
        require(block.timestamp < c.deadline, "Campaign ended");
        c.contributions[msg.sender] += msg.value;
        c.pledged += msg.value;
        emit Pledged(_campaignId, msg.sender, msg.value);
    }

    function claimFunds(uint _campaignId) external {
        Campaign storage c = campaigns[_campaignId];
        require(msg.sender == c.owner, "Not owner");
        require(block.timestamp >= c.deadline, "Campaign ongoing");
        require(c.pledged >= c.goal, "Goal not reached");
        require(!c.claimed, "Already claimed");
        c.claimed = true;
        payable(c.owner).transfer(c.pledged);
        emit FundsClaimed(_campaignId);
    }

    function getContribution(uint _campaignId, address _contributor) external view returns (uint) {
        return campaigns[_campaignId].contributions[_contributor];
    }
}
