# 🛠 개발 워크스테이션 구축 미션 결과보고서

## 1. 실행 환경
- OS / Shell: WSL2 (Ubuntu) + Docker Desktop 연동
- 작업 경로: `~/projects/myapp/lab`
- Docker Version: `Docker version 29.9.3, build 5457199`
- Git Version: `git version 2.53.0`

### 1.1 디렉토리 구조 및 설계 기준
- **설계 기준:** 실습 코드·설정 파일과 실행 증빙 로그를 분리하고, 불변 이미지/컨테이너와 마운트·볼륨 데이터를 구분해 재현성과 관리 편의성을 높이는 구조로 설계했습니다.
- **`~/projects/myapp/lab` (루트 작업 디렉토리):** `Dockerfile`, `index.html`, 권한 실습 대상(`perm_test.txt`, `perm_dir`) 및 `README.md`를 관리하는 메인 실습 공간입니다.
- **`evidence/` (증빙 로그 디렉토리):** `evidence/evidence.md` 등 명령어 실행 결과와 검증 로그를 모아 본문(`README.md`)의 가독성을 유지하면서 근거 자료를 보존합니다.

## 2. 수행 항목 체크리스트
- [x] 터미널(CLI) 기반 작업 및 디렉토리 구성
- [x] 파일(`perm_test.txt`) 및 디렉토리(`perm_dir`) 권한 변경 전/후 비교 (`chmod`)
- [x] 커스텀 `Dockerfile` 빌드 및 포트 매핑 확인
- [x] 바인드 마운트 및 볼륨 영속성 검증
- [x] Git 설정 및 GitHub 원격 저장소(`e1-1`) 연동 및 문서 동기화

## 3. 핵심 수행 로그 및 증거
### 3.1 터미널 및 권한(`chmod`) 실습
- 파일(`perm_test.txt`): `600` (`-rw-------`) -> `644` (`-rw-r--r--`)
- 디렉토리(`perm_dir`): `700` (`drwx------`) -> `755` (`drwxr-xr-x`)
- 상세 CLI 및 권한 로그: `evidence/evidence.md` 참고

### 3.2 Docker 커스텀 이미지, 포트 매핑 및 데이터 관리
- 커스텀 이미지 빌드 및 컨테이너 실행/포트 매핑 확인
### 3.3 Docker 이미지 및 컨테이너 목록 증거
- `docker images` 및 `docker ps -a` 전체 출력은 `evidence/evidence.md`의 **Docker 이미지 및 컨테이너 목록 증거** 항목에 기록되어 있습니다.

- 바인드 마운트(`index.html` 변경 즉시 반영) 및 Docker 볼륨(컨테이너 삭제 후에도 데이터 유지) 검증
- 접속 증거 스크린샷(준비된 이미지 파일이 있다면 아래 경로/링크로 연결):
  - `![브라우저 접속 화면](evidence/screenshot.png)` *(실제 이미지 파일명을 맞게 수정하세요)*

### 3.4 Docker 이미지 빌드 로그
- 태그 지정 빌드 명령: `docker build -t my-web-lab:v1 .`
- 상세 빌드 출력 로그(성공 및 태그 확인): `evidence/evidence.md`의 **Docker 이미지 빌드 증거** 항목 참고

### 3.5 호스트 포트 접속 검증 증거
- 접속 확인 명령: `curl -i http://localhost:8080`
- 전체 HTTP 응답 헤더 및 본문 로그: `evidence/evidence.md`의 **호스트 포트 접속 검증 증거** 항목 참고

### 3.6 볼륨 마운트 및 컨테이너 삭제 후 데이터 유지 검증
- 검증 방식: 명명된 볼륨에 파일 생성 후 컨테이너 삭제(`docker rm -f`), 새 컨테이너에서 동일 볼륨 마운트 후 파일 목록 및 내용 비교
- 전·후 비교 전체 로그: `evidence/evidence.md`의 **볼륨 마운트 및 컨테이너 삭제 전·후 파일 비교 증거** 항목 참고

## 4. 트러블슈팅
1. **문제:** `git push` 시 원격 이력 충돌(`fetch first`) 발생
   - **원인/확인:** 원격 저장소(`e1-1`)에 먼저 생성된 파일 이력이 있어 로컬과 커밋 히스토리가 갈라짐
   - **해결:** 원격 변경 이력을 동기화한 뒤 로컬 커밋을 `main` 브랜치에 반영하여 해결
2. **문제:** `chmod` 및 파일 조회 명령 실행 시 인자 결합 또는 파일명 오타 오류 발생
   - **원인/확인:** 명령을 한 줄에 붙이거나 `perm_test.txt` 대신 `perm.txt`로 입력해 `No such file or directory`가 발생함
   - **해결:** 명령어를 줄 단위로 나누어 실행하고 정확한 파일명(`perm_test.txt`, `perm_dir`)으로 권한 변경 전/후를 재확인

## 5. 재현 방법
1. 저장소 클론: `git clone https://github.com/kimjeongkuk/e1-1.git`
2. 작업 디렉토리 이동: `cd e1-1` (기존 실습 경로 기준 `~/projects/myapp/lab` 참고)
3. Docker 이미지 빌드: `docker build -t my-web-lab:v1 .`
4. 포트(`-p`) 및 볼륨(`-v`) 매핑 옵션으로 컨테이너 실행:
   - 포트 매핑: `-p 8080:8000` (호스트 `8080` 포트 -> 컨테이너 `8000` 포트, 앱 내부 포트에 맞춰 조정)
   - 영속 볼륨 매핑: `-v lab-vol:/data` (`lab-vol` 볼륨을 컨테이너 `/data` 경로에 마운트)
   - 실행 명령 예시:
     ```bash
     docker volume create lab-vol
     docker run -d --name my-web-lab-ctr -p 8080:8000 -v lab-vol:/data my-web-lab:v1
     ```
5. 동작 확인: `curl -i http://localhost:8080` 및 컨테이너 삭제 후 `lab-vol` 데이터 유지 여부 확인
