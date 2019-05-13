---
title: 'webpack4构建vue项目（二）'
date: 2019-03-01 10:32:58
tags:
- webpack配置
---
## 前言

距离上篇文章9102年webpack4搭建vue项目已经过了将近两个月了，一直没有时间写文章，公司项目比较多，这两个月一直在加班，最近大家一直在讨论996.icu，其实我想发表一点自己的看法，关于加班我的座右铭一直是：只要工资给到位，加班无所谓。尴尬的就是我们公司不给加班费，而且不让调休，哈哈哈，相信大多数公司都是如此，所以呢，所以呢，直到今天才能给大家分享文章，想看上篇文章的同学点这里`[传送门](https://www.imooc.com/article/279078)`
好了废话不多说开始撸代码。

## 新建文件夹
```
mkdir wepack-vue //文件名字可以随便
```

## 新建package.json文件 

```
npm init -y
```

## webpack配置 

 - 新建build文件夹
```
mkdir build
```

build文件夹新建webpack.base.conf.js，webpack.dev.conf.js，webpack.prod.conf.js
webpack.base.conf.js 存放公共配置
webpack.prod.conf.js 存放生产环境配置
webpack.dev.conf.js 存放开发环境配置

 - 创建src文件夹并创建main.js
 - 创建index.html

```
<!DOCTYPE html>
<html lang="en">
<head>    
    <meta charset="UTF-8">    
    <meta name="viewport" content="width=device-width, initial-scale=1.0">    
    <meta http-equiv="X-UA-Compatible" content="ie=edge">    
    <title>webpack搭建vue项目</title>
</head>
<body>
    <div id="app"></div>
</body>
</html>
```

 - 下载webpack webpack-dev-server webpack-cli

```
npm i webpack webpack-dev-server webpack-cli -D
```

 - 打开webpack.base.config.js，并配置webpack整体属性

```
var path = require('path');
var webpack = require('webpack');
module.exports = {
    entry: {
        main: path.resolve(__dirname, '../src/main.js')
    },
    output: {
        path: path.resolve(__dirname, '../src'),
        filname: '[name].[bash].js',
    },
    module: {
        rules: []
    },
    pligins: [
                new webpack.HashedModuleIdsPlugin(), // 解决vender后面的hash每次都改变
             ],
    resolve: {

    }
}
```

## 配置loader 

 - 下载babel-loader，babel-core，babel-preset-dev，rules并配置js

babel-preset-env 帮助我们配置 babel。我们只需要告诉它我们要兼容的情况（目标运行环境），它就会自动把代码转换为兼容对应环境的代码。

babel-core是作为babel的核心存在，babel的核心api都在这个模块里面

tips: babel是7.X的话babel-core必须是6.X，否则不兼容

```
npm i babel-loader babel-core babel-preset-env@7 -D
```

```
rules:[
    {
        test: /\.js$/,
        use: ['babel-loader'],
        exclude: /node_modules/
    }
]
```

 - 新建.babelrc文件，.babelrc是babel全局配置文件

```
{
    "preset": [
                ['env',{
                        "targets":  {// 指定转译到那个环境
                            //浏览器环境                            
                            "browsers": ["> 1%", "last 2 versions", "not ie <= 8"],
                        },
                        //是否将ES6的模块化语法转译成其他类型
                        "modules": false
                 }]
            ]
}
```

 - 下载file-loader，rules并配置文件（图片和字体）

```
npm i file-loader -D
```

```
rules:[
    {
        test: /\.(jpg|png|svg|gif)$/,
        use: ['file-loader']
    },
  {
        test: '/\.(woff|woff2|eot|ttf|otf)$/',
        use: ['file-loader']
   },]
```

 - 下载css-loader，vue-style-loader，sass-loader， node-sass，并配置css，scss，sass

```
npm i css-loader vue-style-loader sass-loader node-sass -D
```

```
rules:[
    {
        test: /\.(sa|sc|c)ss$/,
        use: [
                {loader: 'vue-style-loader'},
                'css-loader',
                'sass-loader'
              ]
    },
  ]
```

 - 下载less，less-loader，并配置less

```
npm i less-loader less -D
```

```
rules:[
    {
        test: /\.less$/,
        use: [
                {loader: 'vue-style-loader'},
                'css-loader',
                'less-loader'
              ]
    },
  ]
```

## 生成html文件 

 - 下载html-webpack-plugin，并配置npm i html-webpack-plugin -D

```
// 引入html-webpack-plugin
var HtmlWebpackPlugin = require('html-webpack-plugin');
plugins: [
    new HtmlWebpackPlugin({
        template: path.resolve(__diename, '../index.html')
    }),
]
```

## 配置解析模块 

```
resolve: {
    // 能够使用户在引入模块时不带扩展
    extensions: ['.js', '.json', '.vue', 'css']
}
```

base模块配置了一些东西但没有配置完，会在后边一点一点加上，接下来配置dev和prod

## 配置webpack.dev.conf 

 - 下载 webpack-merge

```
npm i webpack-merge -D
```

webpack.dev.js

```
var merge = require('webpack-merge');
var baseConfig = require('./webpack.base.conf');
var path = require('path');
var webpack = reuire('webpack');
module.exports = merge(baseConfig, {
    devtool: 'inline-source-map', // 压缩方式
    mode: 'development'
    devServer: {
     hot: true, // 热更新
     open: true, // 自动打开页面
     contentBase: path.resolve(__dirname, '../dist'), // 告诉服务从哪提供内容
    },
    plugins: [
        new.webpack.HotModuleReplacementPlugin(), //开启热更新
    ]
})
```

## 配置webpack.prod.conf 
webpack.prod.conf.js

```
var merge = require('webpack-merge');
var baseConfig = require('./webpack.base.conf');
var path = require('path');
var webpack = reuire('webpack');
module.exports = merge(baseConfig, {
    devtool: 'source-map', // 压缩方式
    mode: 'production'
    plugins: [
    ]
})
```

## 配置vue-loader 

 - 下载vue-loader，vue，vue-template-compiler, 并配置vue解析文件，配置webpack.base.cond.js

```
npm i vue vue-loader vue-template-compiler -D
```

```
var VueLoaderPlugin = require('vue-loader/lib/plugin');
// 省略代码......
rules:[
    {
        test: /\.vue$/,
        use: ['vue-loader'],
        exclude: /node_modules/
    },
  ]
// 省略代码.......
// 省略代码....
plugins: [
    new VueLoaderPlugin(), // 它的职责是将你定义过的其它规则复制并应用到 .vue 文件里相应语言的块
]
// 省略代码...
配置vue别名，确保webpack可以找到.vue文件
// 省略代码...
reslove: {
    alias: [
        'vue$': 'vue/dist/vue.esm.js', //配置别名 确保webpack可以找到.vue文件
        '@': path.resolve(__dirname, '../src')
    ]
}
```

 - 新建App.vue文件

```
<template>
    <div>{{str}}</div>
</template>
<script>
export default {
  name: 'App',
  data () {
    return {
      str: 'hello'
    }
  }}
</script>
<style>
div {
  color: red;
}
</style>
```

 - 在main.js中引入vue

```
import VUe from 'vue'
import App from './App'

new Vue({
    el: "#app",
    render: (h) => h(App)
})
```

## 配置命令 

 - 找到package.json文件，并配置开发和打包命令

```
// 省略代码。。。
"scripts": {
  "dev": "webpack-dev-server  --progress --config build/webpack.dev.conf.js",
   "build": "webpack --config build/webpack.prod.conf.js"
  }
```

 - 运行项目

```
npm run dev
```

可以看到项目已经跑起来了



## 区分环境引入不同地址 

 - 新建config文件夹并新建dev.ev.js和prod.env.js

dev.env.js 开发环境配置

```
'use strict'

module.exports = {
    NODE_ENV: '"development"',
    BASE_API: '"http://1456"',
}
```

prod.env.js 生产环境配置

```
'use strict'

module.exports = {
    NODE_ENV: '"production"',    BASE_API: '"http://123.com"',
}
```

## 优化webpack配置

 - 解决更改文件打包时dist文件没有清除，再次打包。

下载clean-webpack-plugin，并配置webpack.prod.conf.js文件

```
npm i clean-webpack-plugin -D
// 引入clean-webpack-plugin
var CleanWebpackPlugin = require('clean-webpack-plugin');
// 省略代码。。。。
plugins: [
    new CleanWebPackPlugin();
]
```

 - 根据不同环境提取css

下载mini-css-extract-plugin，并配置webpack.prod.conf.js文件

```
npm i mini-css-extract-plugin -D
```

更改webpack.prod.conf.js中使用vue-style-loader的代码，更改为

```
 module: {
        rules: [
            {
                test: /\.(c|sc|sa)ss$/,
                use: [
                  {
                    loader: MiniCssExtractPlugin.loader,
                  },
                  'css-loader',
                  'sass-loader'
                ]
            },
            {
            test: /\.less$/,
            use: [
                {
                loader: MiniCssExtractPlugin.loader,
                },
                'css-loader',
                'less-loader'
                ]
            }
        ]
    },
```

在webpack.prod.conf.js的plugin中配置

```
new MiniCssExtractPlugin({
    filename: '[name].[hash].js'
})
webpack.base.conf.js中删除使用vue-style-loader的代码，并在webpack.dev.conf.js中定义

  module: {
    rules: [
      {
        test: /\.(c|sc|sa)ss$/,
        use: [
          {
            loader: 'vue-style-loader',
          },
          'css-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.less$/,
        use: [
          {
            loader: 'vue-style-loader',
          },
          'css-loader',
          'less-loader'
         ]
      }
    ]
  },
```

这个配置vue-loader中有提到[配置css单独打包](https://vue-loader.vuejs.org/zh/guide/extract-css.html#webpack-4)

 - 第三方库单独打包

把依赖的第三方库抽取出来单独打包，加快打包进度

下载autodll-webpack-plugin

```
npm i autodll-webpack-plugin -D
```

 - 在webpack.base.conf.js中配置

```
var AutodllWebpackpackPlugin = require('autodll-webpack-plugin');
plugins: [
    new AutodllWebpackpackPlugin ({
        inject: true,
        debugger: true,
        filename: '[name].js',
        path: './dll',
        entry: {
            vendor: ['vue']
        }
    })
]
```

tips: inject 为 true，插件会自动把打包出来的第三方库文件插入到 HTML。filename 是打包后文件的名称。path 是打包后的路径。entry 是入口，vendor 是你指定的名称，数组内容就是要打包的第三方库的名称，不要写全路径，Webpack 会自动去 node_modules 中找到的。

 - 提取公共代码

在 webpack.base.conf.js的 plugins 属性中添加如下插件对象

```
new webpack.optimize.SplitChunksPlugin()
```

 - 打包时压缩js和css

下载optimize-css-assets-webpack-plugin和uglifyjs-webpack-plugin

```
npm i uglifyjs-webpack-plugin uglifyjs-webpack-plugin -D
```

在webpack.prod.conf.js中分别引入optimize-css-assets-webpack-plugin和uglifyjs-webpack-plugin并增加optimization

```
var OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
var UglifyJsPlugin = require("uglifyjs-webpack-plugin");
// ...省略号 
    optimization: {
                minimizer: [
          // 压缩JS
          new UglifyJsPlugin({
            uglifyOptions: {
              compress: {
                warnings: false, // 去除警告
                drop_debugger: true, // 去除debugger
                drop_console: true // 去除console.log
              },
            },
            cache: true, // 开启缓存
            parallel: true, // 平行压缩
            sourceMap: false // set to true if you want JS source maps
          }),
          // 压缩css
          new OptimizeCSSAssetsPlugin({})
        ]
    },
```

 - css自动加前缀

下载postcss-loader 和autoprefixer

```
npm i postcss-loader autoprefixer -D
```

分别在webpack.dev.conf.js和webpack.prod.conf.js的use中添加postcss-loader

```
use: [
    'postcss-loader'
]
```

在项目下增加postcss.config.js

```
// 配置cssz加前缀
module.exports = {
  plugins: [
    require('autoprefixer')
  ]
}
```

以上配置的项目就可以跑起来了，谢谢大家，如有错误，敬请指出，一起在码农的道路上越走越远

感恩骗点star项目地址[项目地址](https://github.com/mr-mengbo/webpack-vue-admin)

占位
下一篇会介绍vue搭建后台项目