# webster的导航站 ✨

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PWA](https://img.shields.io/badge/PWA-enabled-brightgreen.svg)]()
[![GitHub Pages](https://img.shields.io/badge/deploy-GitHub%20Pages-success.svg)]()

webster的个人网站导航，纯原生技术实现，支持 PWA、主题切换、拖拽排序等现代化特性。

## ✨ 特性

- 🎨 **优雅动画** - 卡片呼吸感、图标脉冲光晕，鼠标交互自然流畅
- 🌓 **主题切换** - 暗色/亮色一键切换，自动记忆用户偏好
- 📱 **PWA 支持** - 可安装到桌面、离线访问、原生应用体验
- 🔄 **拖拽排序** - 支持鼠标拖拽调整卡片顺序，实时保存
- 🛠️ **可视化配置** - 无需编辑代码，通过 `config.html` 轻松管理
- 🔍 **智能获取** - 自动抓取网站标题、图标和主题色
- 💾 **本地存储** - 所有配置保存在浏览器本地，数据永不丢失
- 📦 **零依赖** - 纯原生 HTML/CSS/JavaScript，单文件即可运行

## 🖼️ 预览

![演示截图](https://via.placeholder.com/800x450/1a1a1a/3b82f6?text=导航站预览)

> 提示：将上面的占位图替换为实际截图

## 🚀 快速开始

### 在线演示

👉 [点击访问在线演示](https://你的用户名.github.io/仓库名/)

### 本地运行

**方法1：使用 Python（推荐）**

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```

**方法2：使用 Node.js**

```bash
# 使用 http-server
npx http-server -p 8000

# 或使用 serve
npx serve -p 8000
```

**方法3：使用 VS Code**

安装 [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) 插件，右键 `index.html` → "Open with Live Server"

然后在浏览器中访问 `http://localhost:8000`

> ⚠️ **重要**：请勿直接双击 `index.html` 打开（`file://` 协议），会导致 PWA 和部分功能无法使用。

## 📝 如何增删卡片

### 方法1：使用可视化配置工具（推荐）

1. **启动本地服务器**（见上方"快速开始"）

2. **打开配置工具**
   ```
   http://localhost:8000/config.html
   ```

3. **选择文件**
   - 点击"📁 选择 index.html"按钮
   - 选择项目中的 `index.html` 文件
   - 授权浏览器访问文件

4. **添加卡片**
   - 填写网站名称、网址、描述
   - 点击"🔍 自动获取"可自动填充信息
   - 点击"✨ 添加卡片"保存

5. **删除卡片**
   - 在列表中找到要删除的卡片
   - 点击右侧的"×"按钮

> 💡 **提示**：配置工具使用 File System Access API，需要 Chrome 86+、Edge 86+ 或其他基于 Chromium 的浏览器。

### 方法2：手动编辑代码

1. **打开 `index.html`**

2. **找到 `SITE_CONFIG` 数组**（约第 230 行）

```javascript
const SITE_CONFIG = [
  {
    id: 'google',                                    // 唯一标识符
    name: 'Google',                                  // 网站名称
    url: 'https://www.google.com',                   // 完整 URL
    icon: 'https://www.google.com/favicon.ico',      // 图标地址
    description: '全球最大的搜索引擎'                  // 描述文字
  },
  // ... 更多卡片
];
```

3. **添加新卡片**：复制一个对象，修改内容

```javascript
{
  id: 'github',                          // 确保 id 唯一
  name: 'GitHub',
  url: 'https://github.com',
  icon: 'https://github.com/favicon.ico',
  description: '代码托管与协作平台'
}
```

4. **删除卡片**：删除对应的整个对象（包括花括号和逗号）

5. **保存文件**并刷新浏览器

## 🎨 如何切换主题

### 手动切换

点击页面右上角的 **"🌙 切换主题"** 或 **"☀️ 切换主题"** 按钮

### 主题说明

- **暗色模式**（默认）：深色背景，适合夜间使用，护眼舒适
- **亮色模式**：浅色背景，适合白天使用，清爽明亮

### 主题记忆

- 主题选择会自动保存到浏览器 `localStorage`
- 下次访问时自动应用上次的选择
- PWA 地址栏颜色会同步跟随主题变化

## 📦 如何部署到 GitHub Pages

### 前置要求

- ✅ 拥有 GitHub 账号
- ✅ 已安装 Git
- ✅ 已创建 GitHub 仓库

### 部署步骤

**1. 初始化 Git 仓库（如果还没有）**

```bash
git init
git add .
git commit -m "Initial commit"
```

**2. 关联远程仓库**

```bash
git remote add origin https://github.com/你的用户名/仓库名.git
git push -u origin main
```

**3. 运行部署脚本**

```bash
# macOS / Linux
chmod +x deploy.sh
./deploy.sh

# Windows (Git Bash)
bash deploy.sh
```

**4. 在 GitHub 启用 Pages**

- 打开仓库页面
- 进入 `Settings` > `Pages`
- Source 选择 `gh-pages` 分支
- 点击 `Save`

**5. 访问网站**

几分钟后访问：`https://你的用户名.github.io/仓库名/`

### 更新网站

每次修改后重新运行部署脚本即可：

```bash
./deploy.sh
```

### 自定义域名（可选）

1. 在仓库根目录创建 `CNAME` 文件
2. 写入你的域名：`example.com`
3. 在域名 DNS 设置中添加 CNAME 记录指向 `你的用户名.github.io`

## 📱 PWA 功能说明

### 安装到桌面

**Chrome / Edge（桌面版）**
1. 访问网站
2. 点击地址栏右侧的 **安装图标** (⊕)
3. 确认安装

**Chrome / Edge（Android）**
1. 访问网站
2. 点击菜单 > **"添加到主屏幕"**
3. 确认添加

**Safari（iOS）**
1. 访问网站
2. 点击分享按钮
3. 选择 **"添加到主屏幕"**

### 离线访问

- ✅ 首次访问后，页面会自动缓存
- ✅ 无网络时仍可打开和使用导航站
- ✅ 用户配置（卡片顺序、主题）保存在本地
- ⚠️ 新添加的网站图标需要联网才能加载

### 更换图标

默认使用 SVG 临时图标，如需更换：

1. 准备两张 PNG 图标：
   - `icon-192.png`（192×192 像素）
   - `icon-512.png`（512×512 像素）

2. 放入 `/icons` 目录

3. 详细设计指南请查看：`icons/README.md`

**在线图标生成工具：**
- [RealFaviconGenerator](https://realfavicongenerator.net/)
- [PWA Builder](https://www.pwabuilder.com/imageGenerator)

## 🛠️ 技术栈

| 技术 | 说明 |
|------|------|
| HTML5 | 语义化标签、Canvas API |
| CSS3 | CSS Variables、Flexbox、Grid、动画 |
| JavaScript (ES6+) | 原生 JS，无框架依赖 |
| Service Worker | PWA 离线缓存 |
| Web App Manifest | PWA 安装配置 |
| File System Access API | 配置工具文件读写 |
| LocalStorage | 数据持久化 |
| Drag and Drop API | 拖拽排序 |

## 🌐 浏览器兼容性

| 浏览器 | index.html | config.html | PWA 支持 |
|--------|------------|-------------|----------|
| Chrome 86+ | ✅ | ✅ | ✅ 完整支持 |
| Edge 86+ | ✅ | ✅ | ✅ 完整支持 |
| Firefox 90+ | ✅ | ❌ | ⚠️ 部分支持 |
| Safari 15+ | ✅ | ❌ | ⚠️ 部分支持 |
| Opera 72+ | ✅ | ✅ | ✅ 完整支持 |

> 💡 **config.html** 需要 File System Access API，目前仅 Chromium 系浏览器支持。  
> 其他浏览器请使用"手动编辑代码"方式管理卡片。

## ❓ 常见问题

### 配置工具无法使用？

**问题**：点击"选择文件"没有反应或提示不支持

**解决**：
- 使用 Chrome 86+、Edge 86+ 或其他 Chromium 浏览器
- 确保通过 HTTP 服务器访问（不能使用 `file://` 协议）
- 检查浏览器控制台是否有错误提示

### PWA 无法安装？

**问题**：地址栏没有安装图标

**解决**：
- 确保通过 HTTPS 或 localhost 访问
- 检查 `manifest.json` 和 `serviceworker.js` 是否加载成功
- 打开 DevTools > Application > Manifest 查看错误
- 清除浏览器缓存后重试

### 部署脚本报错？

**问题**：执行 `./deploy.sh` 提示权限错误

**解决**：
```bash
# 赋予执行权限
chmod +x deploy.sh

# 重新运行
./deploy.sh
```

**问题**：提示"未配置远程仓库"

**解决**：
```bash
# 添加远程仓库
git remote add origin https://github.com/你的用户名/仓库名.git

# 重新运行部署
./deploy.sh
```

### 拖拽排序不生效？

**问题**：拖动卡片后位置没有保存

**解决**：
- 刷新页面查看是否已保存（数据存储在 localStorage）
- 检查浏览器是否启用了 LocalStorage
- 隐私模式下 LocalStorage 可能被禁用

### 图标加载失败？

**问题**：部分网站图标显示为默认图标

**解决**：
- 网站可能没有 favicon 或阻止跨域访问
- 手动替换为有效的图标 URL
- 使用配置工具的"自动获取"功能重新获取

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发指南

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/AmazingFeature`
3. 提交更改：`git commit -m 'Add some AmazingFeature'`
4. 推送分支：`git push origin feature/AmazingFeature`
5. 提交 Pull Request

### 功能建议

如果你有好的想法，欢迎通过 Issue 讨论：
- 新增功能需求
- 界面优化建议
- 性能改进方案
- Bug 反馈

## 📄 许可证

本项目采用 [MIT License](LICENSE) 开源协议。

你可以自由地：
- ✅ 使用、修改、分发本项目
- ✅ 用于个人或商业用途
- ✅ 二次开发和定制

唯一要求：
- 📝 保留原作者版权声明

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给个 Star 支持一下！**

Made with ❤️ by **webster**

[Report Bug](../../issues) · [Request Feature](../../issues)

</div>

