# yiyd
![lang: haskell](https://img.shields.io/badge/lang-haskell-brightgreen.svg)
[![Travis Master](https://img.shields.io/travis/VonFry/yiyd/master.svg?label=master)](https://travis-ci.org/VonFry/yiyd)
[![Travis Dev](https://img.shields.io/travis/VonFry/yiyd/develop.svg?label=develop)](https://travis-ci.org/VonFry/yiyd)
[![Hackage](https://img.shields.io/hackage/v/yiyd.svg)](https://hackage.haskell.org/package/yiyd)
    
This project's whole name is __Zhou Yi Yarrow divination__. Its a Chinese traditional divination with _zhouyi_. So I'll write other document with Chinese instead of other language. I think it's so hard to describe them without chinese.

本项目实现在命令行下通过随机数的方式，按蓍草占卜流程生成爻。相比人工使用50根蓍草要来得方便多。但是如果可能，还是推荐通过蓍草或是木棒等物品进行占卜。这个过程可以对易有更多的了解。特别是每一步中的含意。同时，也能放空内心。

关于蓍草占卜流程，请通过源代码或其它方式了解。本人目前不想在文档中多写。

本项目仍开发中，什么时候会完成本人也不知道，说不定永远写不完呢。

# 功能

按蓍草占卜法，配合周易，生成结果。

# 安装

## clone

1. clone
2. `stack build`
3. (optional) `stack install`

也可以使用`cabal`。如果不是haskell开发员，为什么不自己写一个呢？本上没有上homebrew一类管理的想法。

## hackage

在项目最基本功能完成前，不会发布至hackage。

`cabal install yiyd`

or 

`stack install yiyd`


# 使用


| 参数 | 说明 |
| --- | --- |
| `—verbose`, `-v` | （默认启用）打印详细过程，包含占卜流程 |
| `—ask`, `-a` | 仅在`verbose`下有效，按步骤打印结果，且每步后询问是否继续 |
| `—quiet`, `-q` | 仅显示结果 |
| `—yao`, `-y` | 在`quiet`下，结果追加爻辞 |
| `—no-yao`, `-ny` | 在`verbose`下，结果不显示爻辞 |

注：如果想要保存至文件或什么，请使用重定向

# TODO

See: [todo](./todo.org)

