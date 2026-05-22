// Force clear all caches and unregister
self.addEventListener('install', event => {
  console.log('Clearing all caches...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          console.log('Deleting cache:', cacheName);
          return caches.delete(cacheName);
        })
      );
    }).then(() => {
      console.log('All caches cleared, skipping waiting...');
      return self.skipWaiting();
    })
  );
});

self.addEventListener('activate', event => {
  console.log('Service worker activated, claiming clients...');
  event.waitUntil(
    self.clients.claim().then(() => {
      console.log('Clients claimed, unregistering self...');
      return self.registration.unregister();
    }).then(() => {
      console.log('Service worker unregistered');
    })
  );
});

// Don't cache anything - always fetch from network
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request).catch(() => {
      return new Response('Offline - please check your connection', {
        status: 503,
        statusText: 'Service Unavailable'
      });
    })
  );
});

