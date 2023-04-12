// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.5.16;

import "./interfaces/IUniswapV2Factory.sol";
import "./UniswapV2Pair.sol";

// 工厂合，用于创建配对合约/
contract UniswapV2Factory is IUniswapV2Factory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair; //token0，token1，address pair
    address[] public allPairs;

    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair) {
        require(tokenA != tokenB, "UniswapV2: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "UniswapV2: ZERO_ADDRESS");

        //必须是uniswap中未创建过的pair
        require(
            getPair[token0][token1] == address(0),
            "UniswapV2: PAIR_EXISTS"
        ); // single check is sufficient

        //获取模板合约UniswapV2Pair的creationCode
        //type().creationCode就是给合约创建字节码
        bytes memory bytecode = type(UniswapV2Pair).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        //将合约创建在指定地址
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
            //新地址 = hash("0xFF",创建者地址, salt, bytecode)
        }
        //初始化，只会调用一次
        IUniswapV2Pair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "UniswapV2: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
