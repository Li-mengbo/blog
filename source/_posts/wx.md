---
title: 微信小程序转发好友
date: 2018-04-01 
tags:
- 微信小程序
---
今天简单地说下微信小程序的转发功能，为什么要简单的说下呢，因为主要讲的就是转发给好友或者群组，还有一种是分享到朋友圈，这种就比较复杂一点了，先稍微透漏一点，分享到朋友圈主要是两种方法，一种是后台直接生成海报图，一种是前端通过canvas生成海报。以后有机会再详细说，好了，言归正传继续说我们的转发好友。
< !--more-->

首先介绍一个微信小程序的API：onShareAppMessage(options)

在 Page 中定义 onShareAppMessage 函数，设置该页面的转发信息。

* 只有定义了此事件处理函数，右上角菜单才会显示 “转发” 按钮
* 用户点击转发按钮的时候会调用
* 此事件需要 return 一个 Object，用于自定义转发内容

options 参数说明

|参数 |类型 |说明 |最低版本 |
|--------|---------|-------|
|from |String |转发事件来源。button：页面内转发按钮；menu：右上角转发菜单 |1.2.4 |
|target |Object |如果 from 值是 button，则 target 是触发这次转发事件的 button，否则为 undefined |1.2.4 |

自定义转发字段

|字段 |说明 |默认值 |最低版本 |
|--------|---------|-------|
|title |转发标题 |当前小程序名称 |1.2.4 |
|path |转发路径 |当前页面 path ，必须是以 / 开头的完整路径 |
|imageUrl |自定义图片路径，可以是本地文件路径、代码包文件路径或者网络图片路径，支持PNG及JPG，不传入 imageUrl 则使用默认截图。显示图片长宽比是 5:4 | |	1.5.0 |
|success |转发成功的回调函数 | |1.1.0 |
|fail |转发失败的回调函数 | |1.1.0 |
|complete |转发结束的回调函数（转发成功、失败都会执行） | |1.1.0 |

还有一个值那就是shareTickets他是转发成功返回的，并且是个数组，每一项是一个 shareTicket ，对应一个转发对象

API先说到这，接下来就是转发的实现

先看图：



首先要在onLoad中配置wx.showShareMenu
```javascript
  onLoad: function (e) {
    wx.showShareMenu({
      // 要求小程序返回分享目标信息
      withShareTicket: true
    }); 
  },
```
然后再配置onShareAppMessage
```javascript
/* 转发*/
  onShareAppMessage: function (ops) {
    if (ops.from === 'button') {
      // 来自页面内转发按钮
      console.log(ops.target)
    }
    return {
      title: '转发dom',
      path: `pages/index/index`,
      success: function (res) {
        // 转发成功
        console.log("转发成功:" + JSON.stringify(res));
        var shareTickets = res.shareTickets;
        // if (shareTickets.length == 0) {
        //   return false;
        // }
        // //可以获取群组信息
        // wx.getShareInfo({
        //   shareTicket: shareTickets[0],
        //   success: function (res) {
        //     console.log(res)
        //   }
        // })
      },
      fail: function (res) {
        // 转发失败
        console.log("转发失败:" + JSON.stringify(res));
      }
    }
  },
```
我解释一下wx.getShareInfo这个可以获取到获取转发详细信息

完整js代码就是
```javaScript
//index.js
//获取应用实例
const app = getApp()

Page({
  data: {
    motto: 'Hello World',
  },
  onLoad: function (e) {
    wx.showShareMenu({
      // 要求小程序返回分享目标信息
      withShareTicket: true
    }); 
  },
  /* 转发*/
  onShareAppMessage: function (ops) {
    if (ops.from === 'button') {
      // 来自页面内转发按钮
      console.log(ops.target)
    }
    return {
      title: '转发dom',
      path: `pages/index/index`,
      success: function (res) {
        // 转发成功
        console.log("转发成功:" + JSON.stringify(res));
        var shareTickets = res.shareTickets;
        // if (shareTickets.length == 0) {
        //   return false;
        // }
        // //可以获取群组信息
        // wx.getShareInfo({
        //   shareTicket: shareTickets[0],
        //   success: function (res) {
        //     console.log(res)
        //   }
        // })
      },
      fail: function (res) {
        // 转发失败
        console.log("转发失败:" + JSON.stringify(res));
      }
    }
  },
})
```
聪明的同学就该知道接下来该是wxml代码
```html
<view class="container">
  <view class="userinfo">
   <button open-type="share">分享好友</button>
  </view>
  <view class="usermotto">
    <text class="user-motto">{{motto}}</text>
  </view>
</view>
```

友情提示一下如果点击按钮分享的话，button一定要设置open-type="share"否则不起作用。如果觉得文章还不错并对你有帮助的话，请分享给你的小伙伴，并点赞，有什么不懂得可以在底下留言哦。如果想看源码的话可以去我的github上下载，欢迎star，[github]: https://github.com/Mr-MengBo/wx-share