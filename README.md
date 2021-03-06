<div align="center">

# SUSTech CS207 (Digital Logic) Project<br>VGA Tangram
  
</div>

### 功能

- [x] VGA 显示
- [x] 基本几何图形显示，包括图形内填充
- [x] 可以上下左右移动图形
- [x] 可以 360 度旋转图形（精确到 1 度）
- [x] 数码管显示图形的坐标、大小和角度
- [x] 调色板：可以更改图形的颜色
- [ ] 碰撞检测

### 实况

![](https://user-images.githubusercontent.com/20324409/171809743-1d3174bf-31a1-4ce4-8e53-cb8693fa9b68.jpg)

### 如何运行

1. 在 vivado 新项目中导入 `rtl` 文件夹（作为 Design Sources），导入约束文件 `constraints.xdc`；
2. 然后添加这个项目的目录到 include 目录中；
3. 添加 IP: Clocking Wizard，配置输出时钟为 40MHz；
4. 最后构建一下就能烧板了。

#### 拨码开关功能

```
┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐
│ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │
└─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘ └─┘
 │   │               │   │   │      Mode 0: 上下左右按钮移动图形
 │   │               │   │   │
 │   │               │   │   └───── Mode 1: 上下按钮调整大小，左右调整角度，中间切换形状
 │   │               │   │
 │   │               │   └───────── Mode 2: 左右增删图形，中间切换图形
 │   │               │
 │   │               └───────────── Mode 3: 调色板模式，上下左右移动指针，中间确认
 │   │
 │   └───────────────────────────── 切换数码管显示内容（0: 坐标和图形个数，1: 大小、角度和形状类型）
 │
 └───────────────────────────────── 精确模式，打开时按下一次按钮只调整 1 个单位
 ```
 
