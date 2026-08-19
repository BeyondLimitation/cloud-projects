import http from 'k6/http';
import { Counter, Rate } from 'k6/metrics';

// 1. 상태 코드 그룹별 비율(%) 메트릭
export const rate2xx = new Rate('http_req_2xx_rate');
export const rate3xx = new Rate('http_req_3xx_rate');
export const rate4xx = new Rate('http_req_4xx_rate');
export const rate5xx = new Rate('http_req_5xx_rate');

// 2. 상태 코드 그룹별 요청 건수(Count) 메트릭
export const count2xx = new Counter('http_req_2xx_count');
export const count3xx = new Counter('http_req_3xx_count');
export const count4xx = new Counter('http_req_4xx_count');
export const count5xx = new Counter('http_req_5xx_count');

export const options = {
  // 테스트 부하 시나리오 설정
  stages: [
    { duration: '30s', target: 20 }, // 30초 동안 20 VUs까지 증대
    { duration: '1m', target: 20 },  // 1분간 유지
    { duration: '30s', target: 0 },  // 30초 동안 감축
  ],
  // 테스트 종료 후 잔여 요청 정리 대기시간 단축 (기본 30초 -> 5초)
  gracefulStop: '5s',
  // 가장 중요한 5xx 에러율 검증 설정 (임계치)
  thresholds: {
    // 전체 요청 중 5xx 에러 발생률이 0.1%(0.001) 미만이어야 성공
    'http_req_5xx_rate': ['rate<0.001'], 
  },
};

export default function () {
  // GitHub Actions에서 주입해줄 Target URL (없을 경우 기본값 사용)
  const targetUrl = __ENV.TARGET_URL || 'http://localhost';
  
  const res = http.get(`https://${targetUrl}`);

  // 2xx, 3xx, 4xx, 5xx 상태 분류
  const is2xx = status >= 200 && status < 300;
  const is3xx = status >= 300 && status < 400;
  const is4xx = status >= 400 && status < 500;
  const is5xx = status >= 500 && status < 600;

  // 메트릭 데이터 기록 (비율)
  rate2xx.add(is2xx);
  rate3xx.add(is3xx);
  rate4xx.add(is4xx);
  rate5xx.add(is5xx);

  // 메트릭 데이터 기록 (건수)
  if (is2xx) count2xx.add(1);
  if (is3xx) count3xx.add(1);
  if (is4xx) count4xx.add(1);
  if (is5xx) count5xx.add(1);
}