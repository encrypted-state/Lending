// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.19;

import "./FHERC20.sol";
import "./AlTokenDeployer.sol";
import "./LendingPool.sol";
import { FHE, euint16, inEuint16 } from "@fhenixprotocol/contracts/FHE.sol";


contract MockLendingPool is LendingPool {

  constructor(AlTokenDeployer _alTokenDeployer) LendingPool(_alTokenDeployer) {}

  function setPool(
    FHERC20 _token,
    inEuint16 calldata _totalBorrows,
    inEuint16 calldata _totalBorrowShares
  ) external {
    euint16 totalBorrows = FHE.asEuint16(_totalBorrows);
    euint16 totalBorrowShares = FHE.asEuint16(_totalBorrowShares);
    Pool storage pool = pools[address(_token)];
    pool.totalBorrows = totalBorrows;
    pool.totalBorrowShares = totalBorrowShares;
    pool.lastUpdateTimestamp = block.timestamp;
  }

  function setUserPool(
    address _user,
    FHERC20 _token,
    bool _useAsCollateral,
    euint16 _borrowShares
  ) external {
    UserPoolData storage userData = userPoolData[_user][address(_token)];
    userData.disableUseAsCollateral = !_useAsCollateral;
    userData.borrowShares = _borrowShares;
  }

  function setPoolReserves(FHERC20 _token, euint16 _amount) external {
    Pool storage pool = pools[address(_token)];
    pool.poolReserves = _amount;
  }

  function mintEncryptedAlToken(FHERC20 _token, address _recipient, inEuint16 calldata _amount) external {
    Pool storage pool = pools[address(_token)];
    pool.alToken.mintEncryptedTo(_recipient, FHE.asEuint16(_amount));
  }

  function burnEncryptedAlToken(
    FHERC20 _token,
    address _user,
    inEuint16 calldata _amount
  ) external {
    Pool storage pool = pools[address(_token)];
    pool.alToken.burnEncryptedTo(_user, FHE.asEuint16(_amount));
  }

  function callAction(FHERC20 _token) external updatePoolWithInterestsAndTimestamp(_token) {}


  function calculateRoundDownLiquidityShareAmountExternal(FHERC20 _token, euint16 _amount)
    external
    view
    returns (euint16)
  {
    return calculateRoundDownLiquidityShareAmount(_token, _amount);
  }

  function calculateRoundUpLiquidityShareAmountExternal(FHERC20 _token, euint16 _amount)
    external
    view
    returns (euint16)
  {
    return calculateRoundUpLiquidityShareAmount(_token, _amount);
  }

  function calculateRoundUpBorrowShareAmountExternal(FHERC20 _token, euint16 _amount)
    external
    view
    returns (euint16)
  {
    return calculateRoundUpBorrowShareAmount(_token, _amount);
  }

  function calculateRoundDownLiquidityAmountExternal(FHERC20 _token, euint16 _shareAmount)
    external
    view
    returns (euint16)
  {
    return calculateRoundDownLiquidityAmount(_token, _shareAmount);
  }

  function calculateRoundUpBorrowAmountExternal(FHERC20 _token, euint16 _shareAmount)
    external
    view
    returns (euint16)
  {
    return calculateRoundUpBorrowAmount(_token, _shareAmount);
  }

  function calculateRoundDownBorrowShareAmountExternal(FHERC20 _token, euint16 _amount)
    external
    view
    returns (euint16)
  {
    return calculateRoundDownBorrowShareAmount(_token, _amount);
  }

  function calculateLinearInterestExternal(
    uint16 _rate,
    uint256 _fromTimestamp,
    uint256 _toTimestamp
  ) external pure returns (uint16) {
    return calculateLinearInterest(_rate, _fromTimestamp, _toTimestamp);
  }

  function calculateCollateralAmountExternal(
    FHERC20 _token,
    euint16 _liquidateAmount,
    FHERC20 _collateral
  ) external view returns (uint256) {
    return calculateCollateralAmount(_token, FHE.decrypt(_liquidateAmount), _collateral);
  }

}