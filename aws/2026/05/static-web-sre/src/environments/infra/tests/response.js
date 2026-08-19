import http from 'k6/http';
import { Counter, Rate } from 'k6/metrics';

export const rate2xx = new Rate('http_req_2xx_rate');
export const rate3xx = new Rate('http_req_3xx_rate');
export const rate4xx = new Rate('http_req_4xx_rate');
export const rate5xx = new Rate('http_req_5xx_rate');

export const count2xx = new Counter('http_req_2xx_count');
export const count3xx = new Counter('http_req_3xx_count');
export const count4xx = new Counter('http_req_4xx_count');
export const count5xx = new Counter('http_req_5xx_count');

export const options = {
  stages: [
    { duration: '30s', target: 20 },
    { duration: '1m', target: 20 },
    { duration: '30s', target: 0 },
  ],
  gracefulStop: '5s',
  thresholds: {
    'http_req_5xx_rate': ['rate<0.01'],
  },
};

export default function () {
  let targetUrl = __ENV.TARGET_URL || 'http://localhost';

  if (!targetUrl.startsWith('http://') && !targetUrl.startsWith('https://')) {
    targetUrl = `https://${targetUrl}`;
  }

  const params = {
    timeout: '5s',
  };

  const res = http.get(targetUrl, params);

  // 💡 [핵심] res.status 값을 const status에 올바르게 할당합니다.
  const status = res ? res.status : 0;

  const is2xx = status >= 200 && status < 300;
  const is3xx = status >= 300 && status < 400;
  const is4xx = status >= 400 && status < 500;
  const is5xx = status >= 500 && status < 600;

  rate2xx.add(is2xx);
  rate3xx.add(is3xx);
  rate4xx.add(is4xx);
  rate5xx.add(is5xx);

  if (is2xx) count2xx.add(1);
  if (is3xx) count3xx.add(1);
  if (is4xx) count4xx.add(1);
  if (is5xx) count5xx.add(1);
}