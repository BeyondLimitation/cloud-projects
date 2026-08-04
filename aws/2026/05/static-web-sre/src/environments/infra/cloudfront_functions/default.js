function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // 1. '/dev' 또는 '/dev/' 로 시작하는 경우 prefix 제거
    // /dev -> "" 
    // /dev/ -> "/"
    // /dev/about -> "/about"
    if (uri === '/dev' || uri.startsWith('/dev/')) {
        uri = uri.replace(/^\/dev/, '');
    }

    // 2. Prefix 제거 후 빈 문자열이거나 '/'인 경우 index.html 처리
    if (uri === '' || uri === '/') {
        uri = '/index.html';
    } 
    // 3. 하위 디렉토리(슬래시로 끝나는 경로) 요청 시 index.html 보완
    else if (uri.endsWith('/')) {
        uri += 'index.html';
    }

    // 변경된 URI 적용
    request.uri = uri;
    return request;
}