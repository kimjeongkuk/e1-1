# 개발 워크스테이션 구축 미션 결과 보고서

## 1. 프로젝트 개요

- **목표:** 터미널(CLI), Docker, Git/GitHub로 개발 워크스테이션을 직접 구축하고, "내 컴퓨터에서만 되는" 문제를 줄이는 **재현 가능한 실행 환경**을 만든다.
- **수행 범위:** 터미널로 디렉토리·권한 정리 → Docker 설치/점검 → 컨테이너 실행/관리 → Dockerfile로 웹 서버 컨테이너화 → 포트 매핑 접속 확인 → 바인드 마운트/볼륨 검증 → Git 설정 및 GitHub 연동.
- **핵심 원칙:** 이미지와 컨테이너의 분리, 격리된 실행 환경, 포트·스토리지 연결 방식을 실행 결과(로그/접속/데이터 유지)로 확인한다.

## 2. 실행 환경

| 항목 | 값 |
|---|---|
| OS / Shell | 🔧 TODO: 실제 환경 하나로 기재 (예: Ubuntu on WSL2 / bash 또는 macOS + OrbStack / zsh) |
| Docker | `Docker version 29.9.3, build 5457199` |
| Git | `git version 2.53.0` |
| 작업 경로 | `~/projects/myapp/lab` |

```bash
$ docker --version && git --version
Docker version 29.9.3, build 5457199
git version 2.53.0
```

> ⚠️ 환경 표기를 하나로 통일하세요. (기존 README: WSL2 + Docker Desktop / 로그: OrbStack, `sudo docker` 사용 → 서울 캠퍼스는 sudo 제한 환경이므로 실제 사용한 방식을 그대로 적고 필요하면 이유를 한 줄 덧붙입니다.)

### 2.1 디렉토리 구조와 설계 기준

```text
~/projects/myapp/lab
├── Dockerfile        # 커스텀 이미지 정의
├── index.html        # 웹 서버가 서빙하는 정적 파일 (바인드 마운트 대상)
├── README.md         # 기술 문서
├── evidence/         # 상세 로그 (evidence.md)
└── images/           # 캡처 이미지
```

- **설계 기준:** 실습 코드·설정과 실행 증빙 로그를 분리하고, 불변 이미지/컨테이너와 마운트·볼륨 데이터를 구분해 재현성과 관리 편의성을 높였습니다.
- 상세 로그: [evidence/evidence.md](evidence/evidence.md)

## 3. 수행 체크리스트

- [x] 터미널 기본 조작 (pwd / ls -la / mkdir / cp / mv / rm)
- [x] 권한 변경 실습 (파일 1, 디렉토리 1)
- [x] Docker 버전 확인
- [x] 🔧 `docker info` 데몬 점검
- [x] 이미지/컨테이너 목록 (`docker images`, `docker ps -a`)
- [x] 🔧 `docker logs`, `docker stats`
- [x] hello-world 실행
- [x] ubuntu 컨테이너 진입 및 명령 수행
- [x] 🔧 attach / exec 차이 정리
- [x] 🔧 Dockerfile 커스텀 이미지 빌드/실행
- [x] 🔧 포트 매핑 접속 (8080, 8081 두 포트)
- [x] 🔧 바인드 마운트 반영 (전/후)
- [x] 🔧 Docker 볼륨 영속성 (명령 포함)
- [x] 🔧 Git 설정 (`git config --list`) + VSCode GitHub 연동
- [x] (선택) Docker Compose 등 보너스

> 완료한 항목만 `[x]`로 바꾸세요. 증거가 없는 항목에 체크하면 감점됩니다.

---

## 4. 개념 정리

### 4.1 절대경로와 상대경로
- **절대경로(`/...`, `~/...`)**: 현재 위치(`pwd`)와 무관하게 위치가 고정됩니다. 예: `~/projects/myapp/lab`
- **상대경로(`./...`, `evidence/...`)**: 현재 디렉토리 기준입니다. 클론한 위치가 달라도 구조만 같으면 동작해 이식성이 좋습니다. 예: `docker build -t my-web-lab:v1 .`의 빌드 컨텍스트 `.`

### 4.2 파일 권한 (rwx와 숫자 표기)
- `r`=4, `w`=2, `x`=1 이고, **소유자·그룹·기타** 순서로 세 자리를 씁니다.
- `7=rwx`, `6=rw-`, `5=r-x`, `4=r--`, `0=---`
- 예: `644` = `rw-r--r--`(소유자 읽기/쓰기, 나머지 읽기), `755` = `rwxr-xr-x`, `600` = 소유자만 읽기/쓰기, `700` = 소유자만 전체 권한.

### 4.3 이미지와 컨테이너
- **이미지**: 앱과 실행 환경을 담은 불변의 실행 템플릿.
- **컨테이너**: 이미지로부터 격리된 프로세스로 실행되는 인스턴스. 컨테이너 안의 변경은 삭제 시 함께 사라질 수 있습니다.

### 4.4 포트 매핑이 필요한 이유
컨테이너는 자체 네트워크 네임스페이스에서 실행되므로 내부 포트에서 대기해도 호스트에서 바로 접근할 수 없습니다. `-p <호스트포트>:<컨테이너포트>`로 호스트 요청을 컨테이너 포트로 전달합니다.

### 4.5 Docker 볼륨 (🔧 TODO: 본인 말로 확인)
- 볼륨은 Docker가 관리하는 영속 저장소로, 컨테이너를 삭제해도 데이터가 남습니다.
- 바인드 마운트는 **호스트의 특정 경로**를 컨테이너에 연결하고(개발 중 즉시 반영에 유리), 볼륨은 **Docker가 경로를 관리**합니다(데이터 영속성에 유리).

### 4.6 Git과 GitHub (🔧 TODO: 본인 말로 확인)
- **Git**: 내 컴퓨터에서 변경 이력을 관리하는 로컬 버전 관리 도구.
- **GitHub**: Git 저장소를 원격에 호스팅하고 협업(PR, 이슈 등)을 지원하는 플랫폼.

---

## 5. 수행 로그와 증거

### 5.1 터미널 기본 조작

```bash
$ pwd
/home/user/e1-1
$ mkdir test-1
$ ls -la
total 56
drwxr-xr-x 5 user user  4096 Nov 10 14:45 .
...
-rw-r--r-- 1 user user 36081 Nov 10 14:21 README.md
drwxr-xr-x 2 user user  4096 Nov 10 14:45 test-1
$ cp test-1 test-2
cp: -r not specified; omitting directory 'test-1'     # 디렉토리는 -r 필요
$ mv test-1 test-2
$ cp -r test-2 test-3
$ rm test-2
rm: cannot remove 'test-2': Is a directory              # 디렉토리는 -r 필요
$ rm -r test-2
$ ls
README.md  README1.md  evidence  test-3
```

> 🔧 TODO: 파일 내용 확인(`cat`)과 빈 파일 생성(`touch`)도 함께 기록하세요. 에러가 났던 명령도 남겨 두면 실습 흔적으로 좋습니다.

### 5.2 권한 변경 전/후

**디렉토리**
```bash
$ ls -ld my_dir
drwxr-xr-x 2 user user 4096 Nov 10 14:56 my_dir      # 변경 전 (755)
$ chmod 700 my_dir
$ ls -ld my_dir
drwx------ 2 user user 4096 Nov 10 14:56 my_dir      # 변경 후 (700)
```

**파일**
```bash
$ touch my_file.txt
$ ls -l my_file.txt
-rw-r--r-- 1 user user 0 Nov 10 14:55 my_file.txt    # 변경 전 (644)
$ chmod 600 my_file.txt
$ ls -l my_file.txt
🔧 TODO: 변경 후 출력을 여기에 붙여 넣기 (-rw------- 예상)
```

| 대상 | 변경 전 | 변경 후 |
|---|---|---|
| `my_file.txt` | `644` (`-rw-r--r--`) | `600` (`-rw-------`) |
| `my_dir` | `755` (`drwxr-xr-x`) | `700` (`drwx------`) |

> ⚠️ 위 표는 실제 로그 기준입니다. 이전 README의 `perm_test.txt`/`perm_dir` 600→644, 700→755 내용과 달랐으므로, 둘 중 **실제로 수행한 한 가지로 통일**하세요.

### 5.3 Docker 설치·점검

```bash
$ docker --version
Docker version 29.9.3, build 5457199
$ docker info
🔧 TODO: 출력 붙여 넣기 (Server Version, Containers 등 확인)
```

### 5.4 hello-world

```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

### 5.5 ubuntu 컨테이너 실습

```bash
$ docker run -it --name my-ubuntu ubuntu bash
root@<container-id>:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@<container-id>:/# whoami
root
root@<container-id>:/# echo "codyssey mission"
codyssey mission
root@<container-id>:/# exit
```

**attach / exec 차이 (🔧 TODO: 직접 관찰한 내용으로 수정)**
- `docker exec -it <이름> bash`: 실행 중인 컨테이너에 **새 프로세스**를 띄워 접속. `exit`해도 컨테이너는 유지됩니다.
- `docker attach <이름>`: 컨테이너의 **메인 프로세스**에 붙음. 메인 셸을 `exit`하면 컨테이너도 종료됩니다.

### 5.6 이미지/컨테이너 목록 및 운영 명령

```bash
$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE
hello-world:latest   1e4c05b897a7       25.9kB         9.49kB
my-web-lab:v1        04e5e109d9b7        177MB         43.3MB
my-web:1.0           af3a6422bf29        177MB         43.3MB
ubuntu:latest        d66b366dac61        163MB         45.9MB

$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED        STATUS                    NAMES
c835ba128675   ubuntu        "bash"     44 hours ago   Exited (0) 43 hours ago   my-ubuntu
920afec8802e   hello-world   "/hello"   44 hours ago   Exited (0) 44 hours ago   pedantic_darwin

$ docker logs <컨테이너명>
🔧 TODO
$ docker stats --no-stream
🔧 TODO
```

### 5.7 Dockerfile 커스텀 이미지

- **선택 방식:** 🔧 TODO (B: Linux/Python 베이스 + 기능 추가로 보임. 실제 Dockerfile 기준으로 확정)
- **베이스 이미지:** 🔧 TODO (예: `python:3.12-...`, 로그상 `SimpleHTTP/0.6 Python/3.12`로 서빙됨)

```dockerfile
🔧 TODO: `cat Dockerfile` 결과를 그대로 붙여 넣기
```

| 커스텀 포인트 | 목적 |
|---|---|
| 🔧 TODO (예: `COPY index.html`) | 🔧 TODO |
| 🔧 TODO (예: `EXPOSE`, `CMD`) | 🔧 TODO |

```bash
$ docker build -t my-web-lab:v1 .
🔧 TODO: 빌드 전체 출력 (Successfully built / naming to ... 확인)
```

### 5.8 포트 매핑 접속 (2회)

```bash
$ docker run -d -p 8080:<컨테이너포트> --name my-web-8080 my-web-lab:v1
$ curl -i http://localhost:8080
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.12.16
Content-type: text/html
Content-Length: 33

<h1>Updated via Bind Mount!</h1>

$ docker run -d -p 8081:<컨테이너포트> --name my-web-8081 my-web-lab:v1
$ curl -i http://localhost:8081
🔧 TODO: 두 번째 포트 응답
```

![포트 8080 브라우저 접속 (주소창 포함)](images/port-8080.png)
*🔧 TODO: 위 이미지는 `http://localhost:8080` 주소창과 응답 화면이 함께 보이는 캡처로 교체*

### 5.9 바인드 마운트 (변경 전/후)

```bash
$ docker run -d -p 8082:<컨테이너포트> -v "$(pwd)/index.html:<컨테이너 내 경로>" --name bind-test my-web-lab:v1
$ curl http://localhost:8082
🔧 TODO: 변경 전 출력
$ echo '<h1>Updated via Bind Mount!</h1>' > index.html
$ curl http://localhost:8082
<h1>Updated via Bind Mount!</h1>
```

### 5.10 볼륨 영속성

```bash
$ docker volume create lab-vol
$ docker run -d --name vol-check-ctr -v lab-vol:/data ubuntu sleep infinity
$ docker exec vol-check-ctr bash -c 'echo persist-check-2026 > /data/note.txt'
$ docker exec vol-check-ctr bash -c 'ls -la /data && echo "--- note.txt ---" && cat /data/note.txt'
total 12
-rw-r--r-- 1 root root   19 Nov 21 02:45 note.txt
--- note.txt ---
persist-check-2026

$ docker rm -f vol-check-ctr
vol-check-ctr

$ docker run --rm -v lab-vol:/data ubuntu bash -c 'ls -la /data && cat /data/note.txt'
total 12
-rw-r--r-- 1 root root   19 Nov 21 02:45 note.txt
persist-check-2026
```

> 🔧 TODO: 위 명령은 기존 출력에 맞춰 **복원한 예시**입니다. 실제로 입력했던 명령으로 맞춰 주세요.

### 5.11 Git 설정과 GitHub 연동

```bash
$ git config --global user.name "<이름>"
$ git config --global init.defaultBranch main
$ git config --list
🔧 TODO: 출력 (user.email 등 개인정보는 마스킹)
```

![VSCode GitHub 로그인 및 저장소 연동](images/github-link.png)
*🔧 TODO: 토큰/계정 정보가 보이지 않게 마스킹한 캡처*

---

## 6. 트러블슈팅

### 6.1 `git push` 시 `fetch first` 오류
| 단계 | 내용 |
|---|---|
| 문제 | `git push` 시 원격 이력 충돌 (`! [rejected] ... (fetch first)`) |
| 원인 가설 | 원격 저장소에 먼저 생성된 커밋이 있어 로컬과 히스토리가 갈라졌을 것 |
| 확인 | 🔧 TODO: `git log --oneline --graph --all` 또는 `git fetch` 후 `git status` 출력 |
| 해결 | 🔧 TODO: 실제 사용한 명령 (예: `git pull --rebase origin main` → `git push`) |

### 6.2 `docker rm` / `cp` 디렉토리 오류 (실제 로그)
| 단계 | 내용 |
|---|---|
| 문제 | `cp: -r not specified; omitting directory`, `rm: cannot remove 'test-2': Is a directory` |
| 원인 가설 | 디렉토리는 재귀 옵션 없이 복사·삭제할 수 없다 |
| 확인 | `cp --help`, `rm --help`에서 `-r` 옵션 확인 |
| 해결 | `cp -r`, `rm -r`로 재실행하여 성공 |

> 이전 README의 "파일명 오타(`perm.txt`)" 사례는 실제 에러 메시지와 출력을 붙일 수 있을 때만 유지하세요. 위 6.2는 로그에 실제로 남아 있어 증거가 확실합니다.

### 6.3 포트 충돌 확인·해제 절차 (참고)
```bash
docker ps --filter "publish=8080"     # 점유 컨테이너 확인
ss -tulpn | grep :8080                # 호스트 프로세스 확인
docker stop <컨테이너명> && docker rm <컨테이너명>
```
> 실제로 겪은 경우에만 "트러블슈팅"으로 쓰고, 겪지 않았다면 "참고 절차"로 표기하세요.

---

## 7. 재현 방법

```bash
git clone https://github.com/kimjeongkuk/e1-1.git
cd e1-1

docker build -t my-web-lab:v1 .

docker volume create lab-vol
docker run -d --name my-web-lab-ctr -p 8080:<컨테이너포트> -v lab-vol:/data my-web-lab:v1

curl -i http://localhost:8080
```

- `<컨테이너포트>`는 Dockerfile의 서버 포트(🔧 TODO: 확정값)입니다.
- 컨테이너 삭제(`docker rm -f my-web-lab-ctr`) 후 같은 볼륨으로 재실행해 `/data` 데이터가 유지되는지 확인합니다.
- 경로(`~/projects/myapp/lab`)는 개인 PC 기준이므로, 클론한 디렉토리에서 실행하면 동일하게 동작합니다.

 ## 8. 제약 사항

 - 제출 방식

   - 제출 방식은 GitHub Repository 링크로 진행한다.
   - 기술 문서(README.md 등)에 수행 로그와 증거가 모두 포함되어야 한다.(별도 파일로 분리하는 것은 가능하나, README에서 링크로 접근이 가능해야 함
 )
 - 실행 방식
   - 모든 작업은 터미널(CLI) 기반으로 수행한다.
   - Dockerfile은 직접 작성해야 한다.
   - 포트 매핑과 마운트/볼륨은 직접 설정하고 동작을 검증해야 한다.

 - 증거 수집 규칙
   - 캡처/로그에는 "명령어 입력"과 "출력 결과"가 함께 포함되어야 한다.
   - 브라우저 접속 증거는 주소창(포트 포함)과 응답 화면이 함께 보이도록 한다.
   - 민감정보는 로그/이밎에 남기지 않는다(마스킹 필수).

 - 재현성
   - README만 보고도 평가자가 동일 절차를 따라 결과물을 확인할 수 있어야 한다.
   - 특정 개인에 종속된 경로/설정이 있다면, 대체 방법 또는 주의사항을 함께 기록한다.

---

## 부록. 미션 README 필수 체크리스트

> 코디세이 올인원 1기 · 입학연수 1-1 — 미션 「내 컴퓨터에 개발자용 '작업실' 꾸미기」
> 제출 전에 이 목록을 하나씩 확인하세요. 평가는 **GitHub 저장소 링크 하나**로 하고, 평가자는 **README만 보고** 판단합니다.

### 먼저 알아둘 것 3가지

- **명령과 출력은 반드시 텍스트 코드블록**으로 넣으세요. AI 사전평가는 이미지·PDF를 읽지 않아서, 스크린샷만 있으면 "증거 없음"이 됩니다. 스크린샷은 보조 자료입니다.
- 캡처에는 **입력한 명령과 출력 결과가 함께** 보여야 하고, 브라우저 캡처에는 **주소창(포트 포함)** 이 보여야 합니다.
- 이메일·비밀번호·토큰·인증 코드·개인 키는 **가리거나 빼야** 합니다.

### A. 문서 구성 — README 앞부분에 꼭 있어야 하는 5가지

| ✔ | # | 항목 | 무엇을 쓰나 | 예시 |
|---|---|---|---|---|
| ☐ | 1 | **프로젝트 개요** | 이 미션에서 무엇을 했는지 2~3줄 요약 | 터미널·Docker·Git을 세팅하고 실행 결과로 검증한 기록 |
| ☐ | 2 | **실행 환경** | OS, 쉘, 터미널, Docker 버전, Git 버전 | Windows + WSL2 Ubuntu / bash / Docker 29.x / Git 2.x |
| ☐ | 3 | **수행 체크리스트** | 아래 B의 실습 항목을 `- [x]` 목록으로 | 터미널, 권한, Docker, Dockerfile, 포트, 마운트, 볼륨, Git, GitHub |
| ☐ | 4 | **검증 방법 + 결과 위치** | 어떤 명령으로 무엇을 확인했는지, 그 결과가 README 어디에 있는지 링크 | 표: 항목 \| 명령 \| 확인한 내용 \| 위치(#5-7) |
| ☐ | 5 | **트러블슈팅 (2건 이상)** | 문제 → 원인 가설 → 확인 → 해결 순서 | 실제로 겪은 오류를 쓰면 됩니다 (예: 포트 충돌, 명령을 찾을 수 없음) |

### B. 수행 로그 — 각 항목마다 "명령 + 출력"을 코드블록으로

| ✔ | # | 항목 | 꼭 들어가야 하는 것 | 핵심 명령 |
|---|---|---|---|---|
| ☐ | 6 | **터미널 조작** | 현재 위치, 목록(숨김 파일 포함), 이동, 폴더 생성, 복사, 이동/이름 변경, 삭제, 파일 내용 확인, 빈 파일 생성 | `pwd` `ls -la` `cd` `mkdir` `cp` `mv` `rm` `cat` `touch` |
| ☐ | 7 | **권한 변경** | **파일 1개 + 폴더 1개**, 변경 **전/후** 비교 | `ls -l` 또는 `stat` → `chmod 600` → 다시 확인 |
| ☐ | 8 | **Docker 점검** | 버전 확인, 데몬(엔진) 동작 확인 | `docker --version` `docker info` |
| ☐ | 9 | **Docker 운영 명령** | 이미지 목록, 컨테이너 실행·중지·목록, 로그, 리소스 | `docker images` `ps` `ps -a` `logs` `stats` `stop` |
| ☐ | 10 | **컨테이너 실습** | hello-world 성공, ubuntu 진입 후 `ls`·`echo`, **attach와 exec 차이를 직접 관찰하고 정리** | `docker run hello-world` / `docker run -it ubuntu bash` / `docker exec` / `attach` |
| ☐ | 11 | **커스텀 이미지** | Dockerfile **직접 작성**, 어떤 베이스 이미지를 골랐는지, 추가한 줄마다 목적, 빌드·실행 결과 | `FROM nginx:alpine` + `COPY` / `docker build -t my-web:1.0 .` |
| ☐ | 12 | **포트 매핑** | `-p 호스트:컨테이너`로 실행, 브라우저 화면(**주소창 포함**) 또는 curl 응답 | `docker run -d -p 8080:80 …` / `curl http://localhost:8080` |
| ☐ | 13 | **바인드 마운트** | 실행 명령 + 호스트에서 파일을 고친 **전/후** 비교 | `-v $(pwd)/폴더:/usr/share/nginx/html` |
| ☐ | 14 | **볼륨 영속성** | 볼륨 생성 → 연결 → 데이터 저장 → **컨테이너 삭제** → 새 컨테이너에서 데이터 그대로인지 확인 | `docker volume create` / `-v mydata:/data` / `docker rm -f` |
| ☐ | 15 | **Git 설정** | 사용자 이름, 이메일, 기본 브랜치 설정 결과 (이메일은 가리기) | `git config --list` / `init.defaultBranch main` |
| ☐ | 16 | **GitHub·VSCode 연동** | VSCode에서 GitHub 로그인한 화면, 저장소 연결·push 결과 | `git remote -v` `git push` + 스크린샷 |

### C. 제출 규칙 — 지키지 않으면 내용이 있어도 감점

- **저장소 공개**: Public으로 만들고, 링크 하나로 모든 결과를 볼 수 있어야 합니다. 별도 파일로 나눠도 README에서 링크로 이어져야 합니다.
- **코드블록 정리**: 문서 안의 명령과 출력은 모두 ` ```bash ` 코드블록으로 넣습니다.
- **CLI로 직접 수행**: 모든 작업은 터미널로 하고, Dockerfile·포트·마운트·볼륨은 직접 설정하고 동작을 확인해야 합니다.
- **재현성**: README만 보고 다른 사람이 따라 할 수 있어야 합니다. 내 PC에만 있는 경로나 설정은 대체 방법이나 주의사항을 적습니다.

### D. 평가 때 말로 설명해야 하는 6가지 — README에 짧게 정리해 두면 좋습니다

| ✔ | 개념 | 한 문장 답 |
|---|---|---|
| ☐ | **절대 경로 vs 상대 경로** | 절대 경로는 `/`부터 적은 전체 주소라 어디서든 같고, 상대 경로는 지금 위치(`.`, `..`)를 기준으로 합니다. |
| ☐ | **권한 r/w/x, 755·644** | 소유자·그룹·기타 세 자리마다 읽기 4 + 쓰기 2 + 실행 1을 더한 값입니다. 755 = rwxr-xr-x, 644 = rw-r--r--. |
| ☐ | **커스텀 이미지** | 공식 이미지를 `FROM`으로 가져와 필요한 부분만 추가해 새 이미지를 만듭니다. 이미지는 설계도, 컨테이너는 실행한 것. |
| ☐ | **포트 매핑이 필요한 이유** | 컨테이너는 분리된 네트워크에서 돌기 때문에 호스트 포트와 컨테이너 포트를 연결해야 밖에서 접속됩니다. |
| ☐ | **Docker 볼륨** | 컨테이너를 지우면 데이터도 사라지지만, 볼륨은 따로 관리되는 저장 공간이라 삭제 후에도 데이터가 남습니다. |
| ☐ | **Git vs GitHub** | Git은 내 컴퓨터에서 변경 이력을 기록하는 도구, GitHub은 그 기록을 올려 공유·협업하는 서비스입니다. |

### E. 놓치기 쉬운 것 — 직접 해 보며 확인한 부분

- **포트 충돌 진단**: AI 사전평가에서 "포트를 누가 쓰는지 확인하는 방법과 비우는 방법"이 없으면 FAIL이 나왔습니다. 트러블슈팅에 함께 넣어 두세요.

  ```bash
  docker ps --filter "publish=8080"   # 8080을 쓰는 컨테이너 찾기
  ss -ltn | grep 8080                 # 리눅스에서 8080 대기 상태 확인
  docker stop <컨테이너 이름>          # 포트 비우기 (또는 -p 8083:80 처럼 다른 포트 사용)
  ```

- **attach/exec 차이는 결과까지**: exec로 나온 뒤 `docker ps`는 Up, attach로 나온 뒤 `docker ps -a`는 Exited. 이 두 출력을 남겨야 "관찰"이 됩니다.
- **권한은 전/후 둘 다**: 변경 후 결과만 있으면 비교가 안 됩니다. 파일과 폴더 각각 변경 전 출력도 넣으세요.
- **Windows 사용자**: PowerShell에서는 `ls -la`, `chmod`가 제대로 안 됩니다. WSL Ubuntu 터미널에서 진행하고, Docker Desktop 설정의 WSL integration에서 Ubuntu를 켜야 `docker` 명령이 됩니다.
- **이메일 노출**: `git config --list` 화면과 입력 줄(`git config --global user.email "…"`)에 이메일이 그대로 보입니다. 캡처 전에 `clear` 하고 결과만 찍은 뒤 가리세요.
