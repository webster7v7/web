# 图标文件说明

## 需要的图标文件

为了让 PWA 在各种设备上完美显示，需要以下两个 PNG 图标：

1. **icon-192.png** - 192x192 像素（安卓主屏幕图标）
2. **icon-512.png** - 512x512 像素（启动画面、应用商店）

## 当前状态

✅ **icon.svg** - 临时 SVG 图标（已创建，可用于开发测试）
⚠️ **icon-192.png** - 待创建（必需）
⚠️ **icon-512.png** - 待创建（必需）

## 生成方法

### 方法1: 在线工具（推荐）

**使用 RealFaviconGenerator**
1. 访问 https://realfavicongenerator.net/
2. 上传一张高清 logo 图片（建议 1024x1024 或更大）
3. 自动生成所有需要的尺寸和格式
4. 下载生成的文件包
5. 将 `android-chrome-192x192.png` 重命名为 `icon-192.png`
6. 将 `android-chrome-512x512.png` 重命名为 `icon-512.png`
7. 放置到本 `/icons` 目录

**使用 PWA Builder**
1. 访问 https://www.pwabuilder.com/imageGenerator
2. 上传源图片
3. 选择需要的尺寸
4. 下载并重命名文件

### 方法2: 设计软件

**使用 Figma**
1. 创建 512x512 画布
2. 设计图标（保持中心 80% 区域内为主要内容，支持 maskable）
3. 导出为 PNG：
   - 512x512（1x）
   - 192x192（使用导出设置调整尺寸）

**使用 Photoshop / Illustrator**
1. 创建 512x512 文档
2. 设计图标内容
3. 导出两个尺寸的 PNG 文件
4. 确保无透明度问题（建议使用实色背景）

### 方法3: 使用临时 SVG（开发阶段）

当前目录中的 `icon.svg` 可以暂时使用：
- ✅ 在浏览器中可以正常显示
- ✅ 可以在开发阶段测试 PWA 功能
- ⚠️ 部分设备可能不支持 SVG 图标
- ❌ 建议正式上线前替换为 PNG

## 图标设计建议

### 尺寸和格式
- **格式**：PNG（推荐）或 WebP
- **尺寸**：192x192 和 512x512（精确像素）
- **分辨率**：72 DPI（网页标准）
- **颜色模式**：RGB

### 设计原则
1. **简洁明了**：避免过多细节，在小尺寸下仍清晰可辨
2. **安全区域**：主要内容保持在中心 80% 区域（支持 maskable icon）
3. **背景不透明**：使用实色背景，避免透明背景在不同系统下显示不一致
4. **品牌色**：使用与网站主题一致的颜色（建议：#3b82f6 蓝色系）
5. **高对比度**：图标与背景有足够对比度，确保可读性

### Maskable Icon 说明

现代 Android 系统支持"自适应图标"，会裁剪图标为不同形状：
- 圆形
- 圆角矩形
- 水滴形

**设计要点：**
```
512x512 画布
├─ 安全区域: 中心 410x410（80%）<- 主要内容放这里
├─ 裁剪区域: 中心 460x460（90%）<- 次要内容
└─ 边缘区域: 外围 26px     <- 可能被裁剪，不要放重要内容
```

**测试工具：**
- https://maskable.app/ - 在线测试 maskable 效果

## 快速替换步骤

1. 准备好 `icon-192.png` 和 `icon-512.png` 两个文件
2. 将文件放到 `/icons` 目录
3. 刷新浏览器缓存（Ctrl+Shift+R 或 Cmd+Shift+R）
4. 在 Chrome DevTools > Application > Manifest 中验证图标加载
5. 卸载已安装的 PWA（如有），重新安装测试

## 故障排查

### 图标不显示？
- 检查文件名是否完全匹配（区分大小写）
- 检查文件路径是否正确（`/icons/icon-192.png`）
- 清除浏览器缓存和 Service Worker 缓存
- 在 DevTools > Application > Manifest 查看错误信息

### 图标被裁剪？
- 确保主要内容在中心 80% 区域内
- 使用 https://maskable.app/ 测试
- 调整设计，增加内边距

### 图标模糊？
- 确保使用精确尺寸（192x192, 512x512）
- 不要拉伸或压缩图片
- 导出时选择高质量设置

## 参考资源

- [Web.dev PWA Icons](https://web.dev/add-manifest/#icons)
- [Maskable Icon Guide](https://web.dev/maskable-icon/)
- [PWA Asset Generator](https://github.com/onderceylan/pwa-asset-generator)

