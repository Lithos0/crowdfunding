# CrowdChain - Crowdfunding Campaign Platform

**Owner**: Arya Consulting, in association with [Rodrigo Ryan](https://x.com/RodrigoRyan)  
**Version**: 1.0  
**License**: UNLICENSED  

## Overview

CrowdChain is a decentralized crowdfunding platform built using Ethereum smart contracts. It allows creators, businesses, and designers to collaborate and launch crowdfunding campaigns. Investors can support these campaigns and receive a share of the profits based on sales outcomes.

This project leverages Solidity and the ERC20 token standard for its token-based crowdfunding model, built upon OpenZeppelin's library for secure and optimized smart contract management.

## Features

1. **Campaign Creation**:  
   Campaigns can be created by businesses with the help of designers and creators. Campaign details such as duration, target amount, description, and image URL can be specified.

2. **Investment Mechanism**:  
   Investors can invest in active campaigns before a specified deadline. Once the target amount is reached, the campaign moves into the “Running” state.

3. **Revenue Sharing**:  
   Upon successful completion of a campaign, returns are distributed:
   - 20% to the designer
   - 50% to the business
   - 30% shared among investors based on their contribution

4. **Campaign Lifecycle**:
   - Active: Campaign is open for investments.
   - Running: Target amount has been reached, and the campaign is progressing.
   - Finished: Campaign has completed, and returns are distributed.
   - Cancelled: Campaign is closed without reaching its goal.

5. **Sales Reporting**:  
   The business can report sales, and based on the sales revenue, the returns are distributed among the stakeholders.

6. **Track Investments**:  
   Investors can track their contributions and view their potential earnings.

## Contracts Overview

1. **CrowdfundingCampaignFactory**:  
   The factory contract is responsible for deploying new `CrowdfundingCampaign` contracts. It keeps track of all created campaigns and provides functions to retrieve campaign details.

2. **CrowdfundingCampaign**:  
   This contract represents an individual crowdfunding campaign. It manages investments, sales reports, and revenue sharing among the participants.

## Technologies

- **Solidity**: Version 0.8.20
- **OpenZeppelin Contracts**: For secure token and contract development.
- **ERC20 Token Standard**: To manage investments and returns.

## How to Use

### Deployment

1. Deploy the `CrowdfundingCampaignFactory` contract.
2. Use the `generateCampaign` function to create a new campaign by providing:
   - Creator address
   - Designer address and name
   - Business address
   - Campaign duration
   - Target amount
   - Campaign name and description
   - Campaign symbol (token)
   - Campaign image URL

3. Once deployed, investors can fund the campaign using the `invest` function.

### Campaign Lifecycle

- **Investing**:  
  Investors can contribute funds to campaigns as long as the campaign is active and has not reached its deadline.
  
- **Triggering the Campaign**:  
  Once the target amount is raised, the campaign moves to the "Running" state.

- **Ending a Campaign**:  
  A campaign can be ended either manually or after the deadline. If the target is not met, funds are refunded.

- **Distributing Returns**:  
  When sales are reported, the platform automatically calculates and distributes earnings to the designer, business, and investors.

## Testing

1. Set up a local Ethereum test environment (e.g., using Hardhat or Truffle).
2. Deploy the `CrowdfundingCampaignFactory` contract.
3. Use `generateCampaign` to create a new campaign.
4. Test investment and revenue-sharing features.

## Owner

CrowdChain is developed and maintained by **Arya Consulting** in association with [Rodrigo Ryan](https://x.com/RodrigoRyan).

## License

This project is unlicensed and is intended for educational or internal purposes only. Usage in a commercial or production environment is not permitted without proper authorization from Arya Consulting.
