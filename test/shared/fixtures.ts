import { ethers } from 'hardhat';
import { MarginlyWalletFactory, MarginlyPool } from '../../typechain-types';
import { createMarginlyPool } from '../../submodules/marginly/packages/contracts/test/shared/fixtures';

export async function createWalletFactory(): Promise<{
  walletFactory: MarginlyWalletFactory,
  marginlyPool: MarginlyPool,
}> {
  const { marginlyFactory, marginlyPool } = await createMarginlyPool();
  const factory = await ethers.getContractFactory('MarginlyWalletFactory');
  const walletFactory = await factory.deploy(marginlyFactory.address);
  return {
    walletFactory,
    marginlyPool
  };
}

