// Service Worker for 个人导航站 PWA
// 版本控制：每次更新静态资源时需要更改版本号

// 可改参数：缓存版本号（更新时递增）
const CACHE_VERSION = 'v1.0.0';
const CACHE_NAME = `nav-pwa-${CACHE_VERSION}`;

// 可改参数：需要预缓存的静态资源列表
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/config.html',
  '/manifest.json',
  '/icons/icon-192.png',
  '/icons/icon-512.png',
  '/icons/icon.svg'
];

// Install 事件：安装 Service Worker 时触发
self.addEventListener('install', (event) => {
  console.log('[Service Worker] 安装中...版本:', CACHE_VERSION);

  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[Service Worker] 缓存静态资源');
        return cache.addAll(STATIC_ASSETS);
      })
      .then(() => {
        console.log('[Service Worker] 跳过等待，立即激活');
        return self.skipWaiting();
      })
      .catch((error) => {
        console.error('[Service Worker] 缓存失败:', error);
      })
  );
});

// Activate 事件：Service Worker 激活时触发
self.addEventListener('activate', (event) => {
  console.log('[Service Worker] 激活中...版本:', CACHE_VERSION);

  event.waitUntil(
    caches.keys()
      .then((cacheNames) => {
        // 删除旧版本缓存
        return Promise.all(
          cacheNames
            .filter((name) => {
              // 保留当前版本，删除其他版本
              return name.startsWith('nav-pwa-') && name !== CACHE_NAME;
            })
            .map((name) => {
              console.log('[Service Worker] 删除旧缓存:', name);
              return caches.delete(name);
            })
        );
      })
      .then(() => {
        console.log('[Service Worker] 立即接管所有页面');
        return self.clients.claim();
      })
  );
});

// Fetch 事件：拦截所有网络请求
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // 跳过非 GET 请求
  if (request.method !== 'GET') {
    return;
  }

  // 跳过 chrome-extension 和其他协议
  if (!url.protocol.startsWith('http')) {
    return;
  }

  // 策略1: 外部资源（跨域请求）- Network First with Cache Fallback
  if (url.origin !== location.origin) {
    event.respondWith(
      fetch(request)
        .then((response) => {
          // 成功获取，缓存副本
          if (response && response.ok) {
            const responseClone = response.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(request, responseClone);
            });
          }
          return response;
        })
        .catch(() => {
          // 网络失败，尝试从缓存获取
          return caches.match(request)
            .then((cachedResponse) => {
              return cachedResponse || new Response('离线状态，无法加载外部资源', {
                status: 503,
                statusText: 'Service Unavailable'
              });
            });
        })
    );
    return;
  }

  // 策略2: 导航请求（HTML 页面）- Network First with Cache Fallback
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((response) => {
          // 成功获取，更新缓存
          if (response && response.ok) {
            const responseClone = response.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(request, responseClone);
            });
          }
          return response;
        })
        .catch(() => {
          // 网络失败，使用缓存
          return caches.match(request)
            .then((cachedResponse) => {
              if (cachedResponse) {
                return cachedResponse;
              }
              // 如果缓存也没有，返回离线页面
              return caches.match('/index.html');
            });
        })
    );
    return;
  }

  // 策略3: 静态资源（CSS、JS、图片等）- Cache First with Network Fallback
  event.respondWith(
    caches.match(request)
      .then((cachedResponse) => {
        if (cachedResponse) {
          // 命中缓存，直接返回
          return cachedResponse;
        }

        // 缓存未命中，从网络获取
        return fetch(request)
          .then((response) => {
            // 检查响应是否有效
            if (!response || response.status !== 200 || response.type === 'error') {
              return response;
            }

            // 缓存有效响应的副本
            const responseClone = response.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(request, responseClone);
            });

            return response;
          })
          .catch((error) => {
            console.error('[Service Worker] 获取资源失败:', request.url, error);
            // 网络和缓存都失败，返回错误
            return new Response('资源加载失败', {
              status: 503,
              statusText: 'Service Unavailable'
            });
          });
      })
  );
});

// 消息事件：接收来自页面的消息
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    // 强制更新 Service Worker
    self.skipWaiting();
  }

  if (event.data && event.data.type === 'CLEAR_CACHE') {
    // 清除所有缓存
    event.waitUntil(
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((name) => caches.delete(name))
        );
      }).then(() => {
        console.log('[Service Worker] 所有缓存已清除');
      })
    );
  }
});

// 可改参数：后台同步（可选功能）
// 如果需要后台同步功能，取消以下注释
/*
self.addEventListener('sync', (event) => {
  if (event.tag === 'sync-data') {
    event.waitUntil(
      // 执行后台同步逻辑
      syncData()
    );
  }
});

async function syncData() {
  console.log('[Service Worker] 后台同步数据');
  // 实现同步逻辑
}
*/

