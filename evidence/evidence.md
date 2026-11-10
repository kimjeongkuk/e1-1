#### **[단계 1] 터미널 환경 및 권한 (CLI 기반)**
- [ ] 모든 명령어를 GUI가 아닌 **터미널(CLI)**에서 수행했는가?

viablevision3530@GNIA-C201-E04:~/e1-1$ pwd
/home/viablevision3530/e1-1
viablevision3530@GNIA-C201-E04:~/e1-1$ mkdir
error: the following required arguments were not provided:
  <dirs>...

Usage: mkdir [OPTION]... DIRECTORY...

For more information, try '--help'.
viablevision3530@GNIA-C201-E04:~/e1-1$ mkdir test-1
viablevision3530@GNIA-C201-E04:~/e1-1$ ls
README.md  README1.md  evidence  test-1
viablevision3530@GNIA-C201-E04:~/e1-1$ ls -la
total 56
drwxr-xr-x 5 viablevision3530 viablevision3530  4096 Nov 10 14:45 .
drwxr-x--- 7 viablevision3530 viablevision3530  4096 Nov 10 14:21 ..
drwxr-xr-x 7 viablevision3530 viablevision3530  4096 Nov 10 14:21 .git
-rw-r--r-- 1 viablevision3530 viablevision3530 36081 Nov 10 14:21 README.md
-rw-r--r-- 1 viablevision3530 viablevision3530     0 Nov 10 14:21 README1.md
drwxr-xr-x 2 viablevision3530 viablevision3530  4096 Nov 10 14:43 evidence
drwxr-xr-x 2 viablevision3530 viablevision3530  4096 Nov 10 14:45 test-1
viablevision3530@GNIA-C201-E04:~/e1-1$ cp
cp: missing file operand
Try 'cp --help' for more information.
viablevision3530@GNIA-C201-E04:~/e1-1$ cp test-1 test-2
cp: -r not specified; omitting directory 'test-1'
viablevision3530@GNIA-C201-E04:~/e1-1$ mv
mv: missing file operand
Try 'mv --help' for more information.
viablevision3530@GNIA-C201-E04:~/e1-1$ mv test-2 test-3
mv: cannot stat 'test-2': No such file or directory
viablevision3530@GNIA-C201-E04:~/e1-1$ ls
README.md  README1.md  evidence  test-1
viablevision3530@GNIA-C201-E04:~/e1-1$ mv test-1 test-2
viablevision3530@GNIA-C201-E04:~/e1-1$ ls
README.md  README1.md  evidence  test-2
viablevision3530@GNIA-C201-E04:~/e1-1$ cp -r test-2 test-3
viablevision3530@GNIA-C201-E04:~/e1-1$ rm test-3
rm: cannot remove 'test-3': Is a directory
viablevision3530@GNIA-C201-E04:~/e1-1$ rm test-2
rm: cannot remove 'test-2': Is a directory
viablevision3530@GNIA-C201-E04:~/e1-1$ rm -r test-2
viablevision3530@GNIA-C201-E04:~/e1-1$ ls
README.md  README1.md  evidence  test-3

- [ ] `pwd`, `mkdir`, `ls -la`, `cp`, `mv`, `rm` 등의 수행 과정(명령어+결과)을 기록했는가?

- [ ] 파일(1개)과 디렉토리(1개)에 대해 `chmod`로 권한을 변경하고 `ls -l`로 전/후를 비교했는가?
viablevision3530@GNIA-C201-E04:~/e1-1$ touch my_file.txt
viablevision3530@GNIA-C201-E04:~/e1-1$ ls -l my_file.txt
-rw-r--r-- 1 viablevision3530 viablevision3530 0 Nov 10 14:55 my_file.txt
viablevision3530@GNIA-C201-E04:~/e1-1$ chmod 600 my_file.txt
viablevision3530@GNIA-C201-E04:~/e1-1$ bash
viablevision3530@GNIA-C201-E04:~/e1-1$ mkdir my_dir
viablevision3530@GNIA-C201-E04:~/e1-1$ ls -ld my_dir
drwxr-xr-x 2 viablevision3530 viablevision3530 4096 Nov 10 14:56 my_dir
viablevision3530@GNIA-C201-E04:~/e1-1$ chmod 700 my_dir
viablevision3530@GNIA-C201-E04:~/e1-1$ bash
viablevision3530@GNIA-C201-E04:~/e1-1$ ls -ld my_dir
drwx------ 2 viablevision3530 viablevision3530 4096 Nov 10 14:56 my_dir
viablevision3530@GNIA-C201-E04:~/e1-1$

#### **[단계 2] Docker 환경 구축 (OrbStack)**

- [ ] `hello-world` 실행 로그를 확보했는가?
viablevision3530@GNIA-C201-E04:~/e1-1$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:c567b231f65614688711a75f31518a064258a51d442117a3e771a3a8fdba78ef
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

- [ ] `ubuntu` 컨테이너 내부 진입 후 `echo` 및 `ls` 명령 결과를 기록했는가?
viablevision3530@GNIA-C201-E04:~/e1-1$ sudo docker run -it --name my-ubuntu ubuntu bash
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
f3f25b84a7d7: Pull complete
edafa32f5d9e: Pull complete
21594acc2d8b: Download complete
Digest: sha256:6a06111c3b0a8600feadb270aec771dc239bf407b25625f93f44ab00e11f4d3c
Status: Downloaded newer image for ubuntu:latest
root@1de83c8a6c00:/# ls
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@1de83c8a6c00:/# ls -la
total 60
drwxr-xr-x   1 root root 4096 Nov 10 06:17 .
drwxr-xr-x   1 root root 4096 Nov 10 06:17 ..
-rwxr-xr-x   1 root root    0 Nov 10 06:17 .dockerenv
drwxr-xr-x   2 root root 4096 Oct 25 10:26 .rock
lrwxrwxrwx   1 root root    7 Apr 20  2026 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Apr 20  2026 boot
drwxr-xr-x   5 root root  360 Nov 10 06:17 dev
drwxr-xr-x   1 root root 4096 Nov 10 06:17 etc
drwxr-xr-x   3 root root 4096 Oct 25 10:26 home
lrwxrwxrwx   1 root root    7 Apr 20  2026 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Apr 20  2026 lib64 -> usr/lib64
drwxr-xr-x   2 root root 4096 Oct 25 10:25 media
drwxr-xr-x   2 root root 4096 Oct 25 10:25 mnt
drwxr-xr-x   2 root root 4096 Oct 25 10:25 opt
dr-xr-xr-x 302 root root    0 Nov 10 06:17 proc
drwx------   2 root root 4096 Oct 25 10:26 root
drwxr-xr-x   4 root root 4096 Oct 25 10:26 run
lrwxrwxrwx   1 root root    8 Apr 20  2026 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 Oct 25 10:25 srv
dr-xr-xr-x  12 root root    0 Nov 10 06:17 sys
drwxrwxrwt   2 root root 4096 Oct 25 10:25 tmp
drwxr-xr-x  12 root root 4096 Oct 25 10:24 usr
drwxr-xr-x  11 root root 4096 Oct 25 10:26 var
root@1de83c8a6c00:/# whoami
root
root@ee780d13d5ac:/# echo "codyssey mission"
codyssey mission
root@ee780d13d5ac:/# exit
exit

#### **[단계 3] 커스텀 Dockerfile 및 포트 매핑**
