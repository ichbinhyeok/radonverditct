# 단일 스테이지 구성 (QEMU 에뮬레이터 위에서 자바 컴파일 시 발생하는 병목 현상을 방지하기 위해)
# CI 파이프라인(GitHub Actions의 x86 환경)에서 ./gradlew build 를 끝낸 후, 생성된 .jar 파일만 이 컨테이너로 복사합니다.

# ARM64 아키텍처를 완벽하게 지원하는 Alpine 기반 Java 21 JRE 이미지
FROM bellsoft/liberica-openjre-alpine:21

# 보안과 안정성을 위해 사용자 생성 (root 유저 회피)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser:appgroup

# 워크디렉토리 설정
WORKDIR /app

# GitHub Actions 파이프라인에서 빌드 완료된 jar 파일을 복사
COPY --chown=appuser:appgroup build/libs/*.jar app.jar

# 컨테이너 포트 노출 (내부 8080)
EXPOSE 8080

# OCI(Arm) 512MB 제한 환경을 고려한 최적화된 JVM 옵션 설정
# - UseSerialGC: 단일 스레드 기반 GC로 저사양 ARM 인스턴스에서 메모리를 가장 적게 소모함
# - Xms256m / Xmx384m: 초기/최대 힙 메모리 고정 (512MB 제한 내에서 안전하게 구동되도록 비율 설정)
# - Xss512k: 스레드 당 스택 메모리 크기 축소 (기본 1MB -> 512KB)
ENTRYPOINT ["java", "-XX:+UseSerialGC", "-Xms256m", "-Xmx384m", "-Xss512k", "-jar", "app.jar"]
