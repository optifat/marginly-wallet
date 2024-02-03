import { expect } from 'chai';
import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { ethers } from 'hardhat';
import { createWalletFactory } from './shared/fixtures';
import { MarginlyWallet } from '../typechain-types/contracts';

describe('MarginlyWallet creation', () => {
  it('creation', async () => {
    const { walletFactory }= await loadFixture(createWalletFactory);
    const [_, user] = await ethers.getSigners();

    expect(await walletFactory.getWallet(user.address)).to.be.eq(ethers.constants.AddressZero);
    await walletFactory.connect(user).createWallet();

    const walletAddress = await walletFactory.getWallet(user.address);
    expect(walletAddress).to.be.not.eq(ethers.constants.AddressZero);
    
    const factory = await ethers.getContractFactory('MarginlyWallet');
    const wallet = factory.attach(walletAddress) as MarginlyWallet;

    expect(await wallet.owner()).to.be.eq(user.address);

  });
});
