# uniswap_fork:

V1，V2:x\*y=k
V1 的 Exchange 合约包含了定价、交易、添加/移除流动性、分发 LP token 代币功能。
V_3:加入了虚拟流动性：其实就是通过这个平移了一下坐标系

更多内容可以参考这个文章：
https://juejin.cn/post/7185379590162874429
&&
https://zhuanlan.zhihu.com/p/380749685
&&
https://zhuanlan.zhihu.com/p/390814143
&&
https://github.com/Dapp-Learning-DAO/Dapp-Learning/blob/main/basic/13-decentralized-exchange/uniswap-v1-like/README.md

## V2 合约：

### interfaces（5）:

### libraries（3）:

### core 合约（3）：

- 1:UniswapV2ERC20.sol：
  这个合约继承了 ERC20 的合约，存在差别的主要是 permit 函数，合约中运用 ERC712 的签名标准，功能和 approval 相似，就是可以线下签好名然后发给第三方，让第三方帮你做 approval 的操作，花费第三方的 gas

- 2.UniswapV2Factory.sol：

  - createPair():
    创建交易对合约
  - setFeeTo():
    用于设置 feeTo 地址，只有 feeToSetter 才可以设置。
    uniswap 中每次交易代币会收取 0.3%的手续费，目前全部分给了 LQ，若此地址不为 0 时，将会分出手续费中的 1/6 给这个地址（这部分逻辑没有体现在 factory 里面）
  - setFeeToSetter():
    用于设置 feeToSetter 地址，必须是现任 feeToSetter 才可以设置。

- 3.UniswapV2Pair
  - getReserves():
    用于获取交易对的资产数量和最近一次交易的区块时间
  - \_safeTransfer():
    函数用于发送代币
  - \_unpdate():
    用于更新 reserves 并进行价格累计的计算
  - \_mintFee():
    用于在添加流动性和移除流动性时，计算开发团队手续费
  - mint():
    用于用户提供流动性时(提供一定比例的两种 ERC-20 代币)增加流动性代币给流动性提供者
  - burn():
    用于燃烧流动性代币来提取相应的两种资产，并减少交易对的流动性
  - swap():
    用于交易对中资产交易
