import '@nomicfoundation/hardhat-toolbox';
require('hardhat-contract-sizer');

const config = {
  solidity: {
    version: '0.8.19',
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
    },
  },
  networks: {
    arbitrumOne: {
      url: 'https://arb1.arbitrum.io/rpc',
    },
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  },
  mocha: {
    timeout: 200_000,
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
    except: ['Mock', 'Test'],
  },
};

export default config;
