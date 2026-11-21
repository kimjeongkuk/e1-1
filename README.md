# 🛠 개발 워크스테이션 구축 미션 결과보고서

## 1. 실행 환경
- OS / Shell: WSL2 (Ubuntu) + Docker Desktop 연동
- 작업 경로: `~/projects/myapp/lab`
- Docker Version: (실행한 `docker --version` 결과 기록)
- Git Version: (실행한 `git --version` 결과 기록)

## 2. 수행 항목 체크리스트
- [x] 터미널 CLI 기본 조작 및 폴더 구성
- [x] 파일(`perm_test.txt`) 및 디렉토리(`perm_dir`) 권한 변경 전/후 비교 (`chmod`)
- [x] 커스텀 `Dockerfile` 빌드 및 포트 매핑(`-p 8080:8000` 등) 확인
- [x] 바인드 마운트 및 볼륨 영속성 검증
- [x] Git 설정 및 GitHub 원격 저장소(`e1-1`) 연동

## 3. 핵심 수행 로그 및 증거
### 3.1 터미널 및 권한 실습
- `perm_test.txt`: `600` (`-rw-------`) -> `644` (`-rw-r--r--`)
- `perm_dir`: `700` (`drwx------`) -> `755` (`drwxr-xr-x`)
- 상세 CLI 로그: `evidence/evidence.md` 참고

### 3.2 Docker 커스텀 이미지, 포트 매핑 및 데이터 관리
- 이미지 빌드(`my-web-lab:v1`) 및 컨테이너 실행/로그 확인
- 바인드 마운트(`index.html` 수정 반영) 및 볼륨(`lab-data-vol`) 영속성 검증

## 4. 트러블슈팅
1. **문제:** `git push -u origin main` 시 `! [rejected] main -> main (fetch first)` 발생
   - **원인/확인:** 원격 저장소(`e1-1`)에 먼저 생성된 파일 이력이 있어 로컬과 이력이 갈라짐
   - **해결:** `git pull --rebase origin main`으로 이력을 맞춘 뒤 `git push -u origin main`으로 푸시
2. **문제:** `chmod` 또는 파일 조회 명령에서 인자/파일명 오타 오류 발생
   - **원인/확인:** 명령을 붙여 쓰거나 `perm_test.txt` 대신 `perm.txt`로 입력함
   - **해결:** 명령을 줄 단위로 분리하고 정확한 파일명을 지정해 실행 및 권한 결과 재확인

## 5. 재현 방법
1. 저장소 클론: `git clone https://github.com/kimjeongkuk/e1-1.git`
2. 작업 디렉토리 이동: `cd e1-1` (기존 작업 경로 기준 `~/projects/myapp/lab` 참고)
3. 이미지 빌드 및 실행: `docker build -t my-web-lab:v1 .` 후 포트 매핑/마운트/볼륨 옵션으로 실행
