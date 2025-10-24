#!/bin/bash
# ========================================
# GitHub Pages 自动部署脚本
# ========================================
# 功能：一键部署到 gh-pages 分支
# 使用：./deploy.sh

set -e  # 遇到错误立即退出

# 颜色定义（美化输出）
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目配置
DEPLOY_BRANCH="gh-pages"
TEMP_DIR=$(mktemp -d)

# ========================================
# 工具函数
# ========================================

# 错误处理函数
error_exit() {
  echo -e "${RED}❌ 错误: $1${NC}" >&2
  cleanup
  exit 1
}

# 清理临时文件
cleanup() {
  if [ -d "$TEMP_DIR" ]; then
    echo -e "${YELLOW}🧹 清理临时文件...${NC}"
    rm -rf "$TEMP_DIR"
  fi
}

# 注册清理钩子（脚本退出时自动执行）
trap cleanup EXIT

# 打印信息
print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

# ========================================
# 环境检查
# ========================================

check_environment() {
  print_info "检查部署环境..."

  # 检查 Git 是否安装
  if ! command -v git &> /dev/null; then
    error_exit "未安装 Git，请先安装：https://git-scm.com/"
  fi

  # 检查当前目录是否为 Git 仓库
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error_exit "当前目录不是 Git 仓库，请先运行：git init"
  fi

  # 检查是否配置了远程仓库
  if ! git remote get-url origin > /dev/null 2>&1; then
    error_exit "未配置远程仓库 origin，请先运行：git remote add origin <仓库地址>"
  fi

  print_success "环境检查通过"
}

# ========================================
# 文件复制
# ========================================

copy_files() {
  print_info "准备部署文件..."

  # 复制核心 HTML 文件
  cp index.html "$TEMP_DIR/" || error_exit "复制 index.html 失败"
  cp config.html "$TEMP_DIR/" || error_exit "复制 config.html 失败"

  # 复制 PWA 相关文件
  cp manifest.json "$TEMP_DIR/" || error_exit "复制 manifest.json 失败"
  cp serviceworker.js "$TEMP_DIR/" || error_exit "复制 serviceworker.js 失败"

  # 复制 icons 目录（排除占位符文件）
  mkdir -p "$TEMP_DIR/icons"
  
  # 复制 SVG 图标（临时使用）
  if [ -f icons/icon.svg ]; then
    cp icons/icon.svg "$TEMP_DIR/icons/"
  fi
  
  # 复制 README（图标说明）
  if [ -f icons/README.md ]; then
    cp icons/README.md "$TEMP_DIR/icons/"
  fi

  # 如果存在 PNG 图标，复制它们
  if [ -f icons/icon-192.png ]; then
    cp icons/icon-192.png "$TEMP_DIR/icons/"
    print_success "已包含 icon-192.png"
  else
    print_warning "未找到 icon-192.png，将使用 SVG 临时图标"
  fi

  if [ -f icons/icon-512.png ]; then
    cp icons/icon-512.png "$TEMP_DIR/icons/"
    print_success "已包含 icon-512.png"
  else
    print_warning "未找到 icon-512.png，将使用 SVG 临时图标"
  fi

  print_success "文件准备完成"
}

# ========================================
# 部署到 GitHub Pages
# ========================================

deploy() {
  print_info "开始部署到 $DEPLOY_BRANCH 分支..."

  cd "$TEMP_DIR"

  # 初始化 Git 仓库
  git init > /dev/null 2>&1

  # 配置 Git 用户信息（如果未配置）
  if [ -z "$(git config user.name)" ]; then
    git config user.name "$(git -C "$OLDPWD" config user.name || echo 'Deploy Bot')"
  fi
  if [ -z "$(git config user.email)" ]; then
    git config user.email "$(git -C "$OLDPWD" config user.email || echo 'deploy@bot.local')"
  fi

  # 添加所有文件
  git add -A

  # 提交（使用时间戳）
  COMMIT_MSG="Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
  git commit -m "$COMMIT_MSG" > /dev/null 2>&1

  # 获取原仓库的远程 URL
  ORIGIN_URL=$(git -C "$OLDPWD" remote get-url origin)

  # 添加远程仓库
  git remote add origin "$ORIGIN_URL"

  # 强制推送到 gh-pages 分支
  print_info "推送到远程仓库..."
  git push -f origin HEAD:$DEPLOY_BRANCH

  cd "$OLDPWD"
}

# ========================================
# 主流程
# ========================================

main() {
  echo ""
  echo "=========================================="
  echo "  🚀 GitHub Pages 部署脚本"
  echo "=========================================="
  echo ""

  # 环境检查
  check_environment

  # 显示部署信息
  REPO_URL=$(git remote get-url origin)
  echo ""
  echo -e "${BLUE}远程仓库:${NC} $REPO_URL"
  echo -e "${BLUE}部署分支:${NC} $DEPLOY_BRANCH"
  echo ""

  # 检查未提交的更改
  if [[ -n $(git status -s) ]]; then
    print_warning "检测到未提交的更改"
    echo ""
    git status -s
    echo ""
  fi

  # 用户确认
  read -p "确认部署？(y/n) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "已取消部署"
    exit 0
  fi

  echo ""

  # 复制文件
  copy_files

  # 执行部署
  deploy

  # 成功提示
  echo ""
  echo "=========================================="
  print_success "部署成功！"
  echo "=========================================="
  echo ""
  echo "GitHub Pages 将在几分钟内更新"
  echo ""
  
  # 尝试提取仓库信息生成访问地址
  if [[ $REPO_URL =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"
    echo -e "${GREEN}访问地址:${NC} https://${USERNAME}.github.io/${REPO_NAME}/"
  else
    echo "请在 GitHub 仓库设置中查看 Pages 访问地址"
  fi
  
  echo ""
  echo "💡 首次部署需要在 GitHub 仓库设置中："
  echo "   Settings > Pages > Source > 选择 gh-pages 分支"
  echo ""
}

# 执行主流程
main

