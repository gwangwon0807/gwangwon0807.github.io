# GOOK_BOB

Jekyll + [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 테마 기반 보안 블로그 겸 포트폴리오.

## 내가 쓰는 곳: `_content/` 하나

```
_content/
├── sidebar.yml          왼쪽 사이드바 (이름, 한 줄 소개, 사진, 아이콘 링크)
├── about.yml            정보 페이지 (학력, 프로젝트, 취약점, 수상, 자격증 …)
├── profile.jpg          프로필 사진 (넣으면 sidebar.yml 의 avatar 에 파일 이름 적기)
└── posts/
    ├── 000000_template/ 글 양식. 통째로 복사해서 씀 (사이트에 안 올라감)
    └── 261015_pinlm1/   YYMMDD_주소
        ├── post.md      글 본문
        └── assets/      이 글의 이미지, 영상
```

이 폴더 밖은 사이트 동작 설정이라 평소에는 열 일이 없다.

## 글 쓰기

```bash
cp -R _content/posts/000000_template _content/posts/261020_flowscope
```

- **폴더 이름** `YYMMDD_주소`: 앞 6자리가 날짜(261020 → 2026-10-20), `_` 뒤가 주소(`/posts/flowscope/`)
  - 날짜가 미래면 그날까지 안 보임
  - 주소는 영어 소문자와 `-` 추천 (한글도 되지만 주소가 길어짐)
- **본문**은 항상 `post.md`
- **이미지, 영상**은 같은 폴더 `assets/`에 넣고 `assets/파일이름`으로 씀
  - 이미지: `![설명](assets/burp.png)`
  - 영상: `<video class="pf-video" src="assets/demo.mp4" autoplay loop muted playsinline></video>`
  - 썸네일: front matter에 `image: assets/cover.png`
- **front matter**
  - `title` 제목 / `categories` 큰 분류 **1개** / `tags` 세부 키워드 **여러 개** / `description` 목록 한 줄 요약
  - `date`는 안 써도 됨 (폴더 날짜). 시간까지 정할 때만 `date: 2026-10-20 21:00:00 +0900`
- **시리즈**: front matter에 `series: 이름` → 같은 이름 글끼리 날짜순으로 묶여 글 맨 위에 시리즈 상자(펼치면 목록)가 나옴. 날짜가 같으면 폴더 이름순
- **숨김 글**: front matter에 `hidden: true` → 홈, 카테고리, 태그, 검색, 이전/다음 글 어디에도 안 나오고 주소(`/posts/주소/`)로만 열림. 검색엔진에도 노출 안 됨
  - 원문 `post.md`는 GitHub 저장소에 그대로 올라가므로 진짜 비밀 내용은 쓰지 말 것
- 문법은 `_content/posts/261015_markdown-guide/post.md` 참고
- 버그바운티 글은 공개 허가된 건만, 도메인·계정·토큰 등은 가리고 작성

## about.yml 항목 형식

맨 위 소개 칸은 `profile:` (`headline` 굵은 첫 줄, `intro` 소개 문단, `facts` 오른쪽 목록). 지우면 안 나온다.

```yaml
  - title: 취약점 제보          # 섹션 이름
    show: 3                    # 선택: 처음에 보일 개수 (기본 5, 나머지는 "더 보기")
    items:
      - when: "2026.03"         # 오른쪽 날짜
        what: "CVE-2026-12345"  # 굵은 제목
        detail: "제품, 종류"     # 아래 줄 설명
        link: https://...       # 있으면 제목이 링크 (없으면 줄 삭제)
```

값에 콜론(`:`)이 들어가면 반드시 큰따옴표로 감싼다. 안 그러면 빌드가 깨진다.

## 미리보기

```bash
bundle install          # 처음 한 번
bundle exec jekyll s -l # http://localhost:4000, 저장하면 자동 새로고침
```

VSCode에서는 `Cmd+Shift+B`. `_config.yml`이나 `_plugins/`를 고쳤을 때, 새 글 폴더를 추가했는데 안 보일 때는 서버를 껐다 켠다.

## 배포

1. GitHub에 `<아이디>.github.io` 저장소 생성
2. `_config.yml`의 `url`을 `https://<아이디>.github.io`로 수정
3. push → Settings › Pages › Source를 **GitHub Actions**로
4. 이후 push할 때마다 자동 배포 (Actions 탭에서 진행 상황 확인)

## 나머지 파일 (디자인을 바꿀 때만)

| 파일 | 하는 일 |
| --- | --- |
| `_config.yml` | 배포 주소, 언어, 한 페이지 글 수 등 동작 설정 |
| `_plugins/content-folder.rb` | `_content/`를 사이트에 연결 (글 폴더, assets, 프로필 사진, 사이트 이름) |
| `_includes/sidebar.html` | 사이드바 틀 (내용은 `sidebar.yml`) |
| `_includes/post-item.html` | 글 목록 카드 (홈, 태그 공통) |
| `_includes/cv-item.html` | 정보 페이지 한 항목 |
| `_includes/series.html` | 글 맨 위 시리즈 상자 |
| `_includes/post-nav.html`, `metadata-hook.html` | 숨김 글에서 이전/다음 버튼 숨김, 검색엔진 차단 |
| `_layouts/home.html` | 홈 (글 목록 + 페이지 버튼) |
| `_layouts/categories.html` | 카테고리 페이지 (펼치는 상자) |
| `_layouts/category.html` | 옛 카테고리 주소 → 카테고리 페이지로 이동 |
| `_layouts/tags.html`, `tag.html` | 태그 페이지, 태그 하나의 글 목록 |
| `_tabs/` | 사이드바 메뉴 (`order:` 순서) |
| `assets/css/jekyll-theme-chirpy.scss` | 스타일. 색은 맨 위 `--pf-` 변수 |
| `assets/404.html` | 없는 주소 페이지 |
| `Gemfile` | 테마 버전 고정 (7.6.0). 덮어쓴 파일들이 이 버전 기준이라 올릴 때는 화면 확인 필요 |
| `.github/workflows/pages-deploy.yml` | push 시 자동 빌드·배포 |
