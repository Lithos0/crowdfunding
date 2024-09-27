// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdfundingCampaignFactory {
    // Define a struct to hold campaign details
    struct CampaignDetails {
        address campaignAddress;
        string name;
        string url;
        string campaignStatus;
    }

    // Array to keep track of all deployed campaigns
    CampaignDetails[] public deployedCampaigns;

    // Event to emit when a new campaign is created
    event CampaignCreated(address campaignAddress, string name, string url);

    // Function to generate a new CrowdfundingCampaign contract
    function generateCampaign(
        address payable _creatorAddress, 
        address payable _designerAddress, 
        string memory _designerName,
        address payable _businessAddress, 
        uint256 _duration, 
        uint256 _targetAmount, 
        string memory _name,
        string memory _campaignDescription,
        string memory _symbol,
        string memory _imageUrl
    ) public {
        // Creating a new CrowdfundingCampaign contract instance
        CrowdfundingCampaign campaign = new CrowdfundingCampaign(
            _creatorAddress, 
            _designerAddress, 
            _designerName,
            _businessAddress, 
            _duration, 
            _targetAmount, 
            _name,
            _campaignDescription,
            _symbol,
            _imageUrl
        );
        
        // Storing the campaign details
        deployedCampaigns.push(CampaignDetails({
            campaignAddress: address(campaign),
            name: _name,
            url: _imageUrl,
            campaignStatus: "Created"
        }));

        // Emitting an event with the new campaign's address and name
        emit CampaignCreated(address(campaign), _name, _imageUrl);
    }

    // Function to get the deployed campaign details by address
    function getDeployedCampaignDetails(address _campaignAddress) public view returns (
        string memory campaignName,
        string memory campaignDescription, 
        string memory designerName, 
        string memory campaignStatus,
        uint256 deadline,
        uint256 targetAmount,
        uint256 raisedAmount,
        uint256 sales,
        uint256 units,
        string memory url
    ) {
        for (uint i = 0; i < deployedCampaigns.length; i++) {
            if (deployedCampaigns[i].campaignAddress == _campaignAddress) {
                CrowdfundingCampaign campaign = CrowdfundingCampaign(_campaignAddress);
                return (
                    campaign.getCampaignName(),
                    campaign.getCampaignDescription(),
                    campaign.getDesignerName(),
                    campaign.getCampaignStatus(),
                    campaign.getDeadline(),
                    campaign.getTargetAmount(),
                    campaign.getRaisedAmount(),
                    campaign.getSalesAmount(),
                    campaign.getUnitsSold(),
                    campaign.getImageURL()
                );
            }
        }
        revert("Campaign not found");
    }

    // Function to get the count of deployed campaigns
    function getDeployedCampaignsCount() public view returns (uint) {
        return deployedCampaigns.length;
    }

    // Function to return all deployed campaign details
    // This function should be used with caution, as it could run out of gas
    // if the array becomes very large.
    function getAllDeployedCampaignsDetails() public view returns (CampaignDetails[] memory) {
        CampaignDetails[] memory details = new CampaignDetails[](deployedCampaigns.length);

        for (uint i = 0; i < deployedCampaigns.length; i++) {
            // Fetch the stored campaign details
            CampaignDetails storage storedDetails = deployedCampaigns[i];

            // Fetch the CrowdfundingCampaign contract
            CrowdfundingCampaign campaign = CrowdfundingCampaign(storedDetails.campaignAddress);

            // Get the status as a string
            string memory statusString = campaign.getCampaignStatus();

            // Construct the CampaignDetails object
            details[i] = CampaignDetails({
                campaignAddress: storedDetails.campaignAddress,
                name: storedDetails.name,
                url: storedDetails.url,
                campaignStatus: statusString
            });
        }

        return details;
    }

    function getInvestedCampaignsByAddress(address investorAddress) public view returns (CampaignDetails[] memory){
        
        uint count = 0;

        // Count how many campaigns the investor has invested in  
        for (uint i = 0; i < deployedCampaigns.length; i++) {
            CrowdfundingCampaign campaign = CrowdfundingCampaign(deployedCampaigns[i].campaignAddress);
            if (campaign.investedInCampaign(investorAddress)) {
                count++;
            }
        }
        
        CampaignDetails[] memory campanasInvertidas = new CampaignDetails[](count);
        uint index = 0;

        for (uint i = 0; i < deployedCampaigns.length; i++) {

            // Fetch the stored campaign details
            CampaignDetails storage storedDetails = deployedCampaigns[i];

            // Fetch the CrowdfundingCampaign contract
            CrowdfundingCampaign campaignObj = CrowdfundingCampaign(storedDetails.campaignAddress);

            // Get the status as a string
            string memory statusString = campaignObj.getCampaignStatus();

            if(campaignObj.investedInCampaign(investorAddress)){
            campanasInvertidas[index] = CampaignDetails({
                campaignAddress: storedDetails.campaignAddress,
                name: storedDetails.name,
                url: storedDetails.url,
                campaignStatus: statusString
            });
            index++;
            }
        }

        return campanasInvertidas;
    }

    function getAllCampaignsAsDesigner(address _designerAddress) public view returns (CampaignDetails[] memory){
        
        uint count = 0;

        // Count how many campaigns the investor has invested in  
        for (uint i = 0; i < deployedCampaigns.length; i++) {
            CrowdfundingCampaign campaign = CrowdfundingCampaign(deployedCampaigns[i].campaignAddress);
            if (campaign.getDesignerAddress() == _designerAddress) {
                count++;
            }
        }
        
        CampaignDetails[] memory campanasInvertidas = new CampaignDetails[](count);
        uint index = 0;

        for (uint i = 0; i < deployedCampaigns.length; i++) {

            // Fetch the stored campaign details
            CampaignDetails storage storedDetails = deployedCampaigns[i];

            // Fetch the CrowdfundingCampaign contract
            CrowdfundingCampaign campaignObj = CrowdfundingCampaign(storedDetails.campaignAddress);

            // Get the status as a string
            string memory statusString = campaignObj.getCampaignStatus();

            if(campaignObj.getDesignerAddress() == _designerAddress){
            campanasInvertidas[index] = CampaignDetails({
                campaignAddress: storedDetails.campaignAddress,
                name: storedDetails.name,
                url: storedDetails.url,
                campaignStatus: statusString
            });
            index++;
            }
        }

        return campanasInvertidas;
    }

}

contract CrowdfundingCampaign is ERC20{

    struct CampaignInvestments {
        address recipient;
        uint256 amount;
    }
    
    address payable creatorAddress; // The public address of the manager who owns and creates this campaign
    address payable designerAddress; // The public address of the designer who creates the design for this campaign
    string designerName; // The designer name that will be associated with the designer Address
    address payable businessAddress; // The public address of the business who owns and creates this campaign
    //uint256 public minimumContribution; // The minimum ammount required to contribute to the campaign (Not required)
    uint256 deadline; // Symbolizes the time from when the campaign is deployed until it is triggered
    uint256 targetAmount; // The target ammount required to trigger the campaign
    uint256 raisedAmount; // The amount raised for this campaign
    uint campaignStatus; // 0 = Cancelled, 1 = Active, 2 = Running, 3 = Finished
    uint256 salesAmount; // The amount of sales informed by the business
    uint64 unitAmount; // The amount of units saled informed by the business
    mapping(address => uint256) investors; // Investors pool addresses => amount invested
    mapping(uint => uint256) sales; // To be defined
    string public campaignDescription; // Used to store the campaign description
    address payable[] investorAddresses; // Array to store investor addresses
    string public imageUrl; //Used to store the image URL from the campaign

    error TransferFailed(); //Used to handle transfer errors

    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _to, uint256 amount);

    constructor (
        address payable _creatorAddress, 
        address payable _designerAddress, 
        string memory _designerName,
        address payable _businessAddress, 
        uint256 _durationInDays, // Parameter will be received in seconds and calculated in days to then store it
        uint256 _targetAmount, 
        string memory _name,
        string memory _campaignDescription,
        string memory _symbol,
        string memory _imageUrl
    ) ERC20(_name, _symbol) {
        creatorAddress = _creatorAddress;
        designerAddress = _designerAddress;
        designerName = _designerName;
        businessAddress = _businessAddress;
        deadline = block.timestamp + (_durationInDays * 1 days); // Convert duration from days to seconds
        targetAmount = _targetAmount;
        imageUrl = _imageUrl;
        raisedAmount = 0;
        campaignStatus = 1;
        salesAmount = 0;
        campaignDescription = _campaignDescription;
    }


    //To fund the contract in order to pay returns
    function fund() payable external {
        // require (msg.sender == businessAddress, "You are not the business");
        require (msg.value >= getRemainingFunding());
        emit TransferReceived(msg.sender, msg.value);
    }

    //Function to allow investors to deposit funds into an Active campaign and register them internally
    function invest() payable external {
        require(msg.value > 0, "Amount needs to be more than zero");
        require(block.timestamp < deadline, "The campaign has finished");
        require(campaignStatus == 1, "The campaign is not active");
        if (investors[msg.sender] == 0) {
            // If this is the first time the investor is contributing, add them to the array
            investorAddresses.push(payable(msg.sender));
        }
        investors[msg.sender] += msg.value; // Add amount to investor's balance
        raisedAmount += msg.value; // Add amount to campaign's raised amount
        emit TransferReceived(msg.sender, msg.value);
    }

    function triggerCampaign() internal {
        // require (msg.sender == businessAddress || msg.sender == creatorAddress, "You are not the business or administrator");
        if (raisedAmount >= targetAmount)
            campaignStatus = 2;
        //There should be a logic to return exceeding targeted funds to inverstors?
    }

    function endCampaign() payable external {
        // require(msg.sender == businessAddress, "You are not the Business owner of the campaign");
        if (campaignStatus == 1 && deadline > block.timestamp){
            for (uint256 i = 0; i < investorAddresses.length; i++) {
                uint256 value = investors[investorAddresses[i]];
                payable(investorAddresses[i]).transfer(value);
            }
        }
        campaignStatus = 0;
    }

    // Allows the business owner to withdraw the invested funds once the target is reached
    function withdrawInvested() payable public {
        // require(msg.sender == businessAddress, "You are not the Business owner of the campaign");
        require(raisedAmount >= targetAmount, "The campaign has not reached its target");

        //Triggers campaign
        triggerCampaign();

       // Transfer the target amount of tokens from the contract's balance to the business owner
       payable(businessAddress).transfer(raisedAmount);
       emit TransferSent(address(this), businessAddress, raisedAmount);
    }

    // Pays returns to each party involved
    function payReturns() payable public {
        // require(msg.sender == businessAddress || msg.sender == creatorAddress, "Only the creator or business can distribute returns");
        require(campaignStatus == 2, "Campaign is not Running");
        require(salesAmount > 0, "No sales registered");
        require(address(this).balance >= salesAmount, "Insufficient funds in contract");

        uint256 designerShare = (salesAmount * 20) / 100; // 20% of the total raised amount
        uint256 businessShare = (salesAmount * 50) / 100; // 50% of the total raised amount
        uint256 investorsSharePool = (salesAmount * 30) / 100; // 30% of the total raised amount for investors

        // Pays returns to Designer
        payable(designerAddress).transfer(designerShare);
        emit TransferSent(address(this), designerAddress, designerShare);

        // Pays returns to Business
        payable(businessAddress).transfer(businessShare);
        emit TransferSent(address(this), businessAddress, businessShare);
        
        // Pays returns to each Investor
        for (uint256 i = 0; i < investorAddresses.length; i++) {
            address payable investor = investorAddresses[i];
            uint256 value = investors[investor];
            uint256 investorsShare = (value * investorsSharePool) / raisedAmount;
            payable(investor).transfer(investorsShare);
            emit TransferSent(address(this), investor, investorsShare);
        }
        campaignStatus = 3;
    }

    //Allows the business to inform the amount of sales and the quantity of units sold
    function informSales(uint256 amount, uint64 units) public{
        // require (msg.sender == businessAddress || msg.sender == creatorAddress, "You are not the business or administrator");
        salesAmount += amount;
        unitAmount += units;
    }

    function getSalesAmount() view public returns (uint256){
        // require (msg.sender == businessAddress || msg.sender == creatorAddress, "You are not the business or administrator");
        return salesAmount;
    }

    function getUnitsSold() view public returns (uint256){
        // require (msg.sender == businessAddress || msg.sender == creatorAddress, "You are not the business or administrator");
        return unitAmount;
    }

    function getRaisedAmount() view public returns (uint256){
        // require (msg.sender == businessAddress || msg.sender == creatorAddress, "You are not the business or administrator");
        return raisedAmount;
    }

    //Returns the balance invested by the Investor (Address) that summons this function
    function getInvestedBalance() public view returns (uint256){
        return investors[msg.sender];
    }

    //Returns the balance required for the campaign to be launched
    function getTargetAmount() public view returns (uint256){
        return targetAmount;
    }


    // Returns the balance that an investor is entitled to based on their investment
    function getEarningBalance() public view returns (uint256) {
        require(campaignStatus == 2, "Campaign is not Running");
        if (msg.sender == designerAddress)
        return (salesAmount * 20) / 100; // 20% of the total raised amount
        else if (msg.sender == businessAddress)
        return (salesAmount * 50) / 100; // 50% of the total raised amount
        else{
            uint256 totalInvestorSharePool = (salesAmount * 30) / 100; // 30% of total sales amount for investors
            uint256 investorContribution = investors[msg.sender]; // Amount the investor has contributed

            // Calculate the investor's share proportionally
            uint256 investorsShare = (investorContribution * totalInvestorSharePool) / raisedAmount;

            return investorsShare;
        }
    }

    // Getter for the Campaign Status
    function getCampaignStatus() view public returns (string memory){
        string memory status;
        if (campaignStatus == 0) //0 = Cancelled, 1 = Active, 2 = Running, 3 = Finished
            status = "Cancelled";
        if (campaignStatus == 1)
            status = "Active";
        if (campaignStatus == 2)
            status = "Running";
        if (campaignStatus == 3)
            status = "Finished";
        return (status);
    }

    // Function to get the campaign earnings
    function getCampaignEarnings() view public returns (CampaignInvestments[] memory) {
        require(campaignStatus == 2, "Campaign is not Running");

        CampaignInvestments[] memory investments = new CampaignInvestments[](3);
        uint256 designersShare = (salesAmount * 20) / 100; // 20% of the total raised amount  
        uint256 businessShare = (salesAmount * 50) / 100; // 50% of the total raised amount  
        uint256 totalInvestorSharePool = (salesAmount * 30) / 100; // 30% of total sales amount for investors

        investments[0] = CampaignInvestments({
            recipient: businessAddress,
            amount: businessShare  
        });

        investments[1] = CampaignInvestments({
            recipient: designerAddress,
            amount: designersShare  
        });

        investments[2] = CampaignInvestments({
            recipient: address(0), // No specific recipient for the investors pool  
            amount: totalInvestorSharePool  
        });

        return investments;
    }

    //Returns true if an investor has invested in this campaign or not
    function investedInCampaign(address investorAddress) public view returns (bool) {
        for (uint i = 0; i < investorAddresses.length; i++)
            if (investorAddresses[i] == investorAddress)
            return true;
        return false;
    }

    // Getter for remaining funding before paying returns
    function getRemainingFunding() public view returns (uint256) {
        return getSalesAmount()-address(this).balance;
    }

    // Getter for the designer's address
    function getDesignerAddress() public view returns (address) {
        return designerAddress;
    }

    // Getter for the designer's name
    function getDesignerName() public view returns (string memory) {
        return designerName;
    }

    // Getter for the business address
    function getBusinessAddress() public view returns (address) {
        return businessAddress;
    }
    
    // Getter for the creator's address
    function getCreatorAddress() public view returns (address) {
        return creatorAddress;
    }

    // Getter for the deadline, returns the amount of seconds in UNIX Timestamp
    function getDeadline() public view returns (uint256) {
        return deadline;
    }

    // Getter for campaign name
    function getCampaignName() public view returns (string memory) {
        return name();
    }

    // Getter for campaign description
    function getCampaignDescription() public view returns (string memory) {
        return campaignDescription;
    }

    // Getter for campaign image url
    function getImageURL() public view returns (string memory) {
        return imageUrl;
    }

}


