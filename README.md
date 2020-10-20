# Simple ERC-20 Token


- 28M tokens total supply

- Initial Rate 3500 Tokens per 1 ETH

- 40% preminted (11.2M to owner account), 60 % for ICO

- the buyer has to send minimum 1 ETH

- Vesting period X amount, lets say 3 months for now

- ICO stops when 60% of ICO tokens are sold ( when no more tokens available to mint )

- Purchasing token function (X amounts of ETH spent grants X amount of extra tokens), (vesting bonus function in milestone 2, the percentage of bonus tokens is within those 60%, for example, 40% are purchased and 20% is vesting bonus on top of that).

- Burn mechanism

Milestone 2:

- Vesting bonus - 90 days of vesting, each day of vesting gives 0.22222222% extra tokens on purchased amount (optional)

- Purchase bonus - if you buy our token for 10 ETH minimum (instead of 5), you get 10% extra.

- When ICO is closed leftover tokens are transferred to owners' address.

- Deploy script for remix.

# How to deploy

1. You need account infura

2. Create file .env in root folder with infura ROPSTEN url and MNEMONIC
example:

```
MNEMONIC="word1 word2 word3 ..."
ROPSTEN_URL=http://infura....
```

3. install all dependencies:

`npm install`

4. run deploy script and follow the instructions. Use regular deployment in menu and ropsten network

`npx oz deploy`
