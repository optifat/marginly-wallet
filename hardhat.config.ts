import '@nomicfoundation/hardhat-toolbox';
require('hardhat-contract-sizer');
require('hardhat-dependency-compiler');

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
    only: ['MarginlyWallet', 'MarginlyWalletFactory'],
    except: ['Mock', 'Test'],
  },
  dependencyCompiler: {
    paths: [
      'submodules/marginly/packages/router/contracts/MarginlyRouter.sol',
      'submodules/marginly/packages/contracts/contracts/MarginlyPool.sol',
      'submodules/marginly/packages/contracts/contracts/MarginlyFactory.sol',
      'submodules/marginly/packages/contracts/contracts/test/TestUniswapFactory.sol',
      'submodules/marginly/packages/contracts/contracts/test/TestUniswapPool.sol',
      'submodules/marginly/packages/contracts/contracts/test/TestSwapRouter.sol',
      'submodules/marginly/packages/contracts/contracts/test/TestERC20Token.sol',
    ],
  },
};

export default config;
