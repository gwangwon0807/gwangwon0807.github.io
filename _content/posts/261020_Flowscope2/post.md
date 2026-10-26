---
title: "화이트햇스쿨 팀프로젝트 Flowscope - 2 "
categories: [Project]            # 큰 분류 1개: CTF / Bug Bounty / Research / Project / Guide
tags: [Project, API]            # 세부 키워드 여러 개
description: "타임라인 및 성과"
series: Flowscope        # 선택: 같은 이름끼리 묶여 글 맨 위에 시리즈 상자 (날짜순)
# image: assets/cover.png    # 선택: 목록 썸네일 + 글 맨 위 이미지
date: 2026-10-20 16:00:00 +09:00  # 선택: 시간까지 정하고 싶을 때 (없으면 폴더 날짜)
math: true                 # 선택: 수식 쓸 때
mermaid: true              # 선택: 다이어그램 쓸 때
# hidden: true               # 선택: 숨김 글. 목록·검색 어디에도 안 나오고 주소(/posts/주소/)로만 열림
---
# 1. 타임라인

| 주차 | 활동내용 |
| :--- | :--- |
| 1주차 | Burp, API 취약점(IDOR, BOLA, BFLA 등)학습| 
| 2주차 | 도구 어떤식으로 개발할지 회의 - 그래프는 어떻게 나타낼지, Brup extenstion으로할지 등 계획 |
| 3주차 | 연구팀, 개발팀으로 나누어서 각자 파트 맡아 진행 |
| 4주차 | MVP 만들어진 도구 리뷰 및 연구 진행 및 중간발표 |
| 5주차 ~ | 도구 성능 개선 및 버그 수정, QA 진행 |
| 6주차 ~ | 화이트, 블랙 박스 대상으로 실제 도구 써보며 취약점 분석 |
| 12주차 | 최종 발표 |  

# 2. 성과 

| 유형 | 상세 내용 |
| :--- | :--- |
| 오픈소스 | 유효 취약점 10건 |
| 블랙박스 | 국내 이커머스 버그 바운티 CWE-200 |
| 논문 | 정보보호 학회 제출 및 승인 | 

## 2-1 CVE 리스트

| CVE ID | 상세 |
| :--- | :--- |
| [CVE-2026-107604](https://nvd.nist.gov/vuln/detail/cve-2026-107604) | Keycloak-services:keycloak-services: view-clients role allows retrieval of active client secrets via installation provider endpoints |
| [CVE-2026-112001](https://nvd.nist.gov/vuln/detail/cve-2026-112001) | ProjectSend 2.0.0 before 2.7.0 Incorrect Authorization via Users API Token Abilities Affected: ProjectSend >= 2.0.0, < 2.7.0  |
| [CVE-2026-112002](https://nvd.nist.gov/vuln/detail/cve-2026-112002) | ProjectSend 2.5.0 before 2.7.0 Unverified Password Change via /settings/password Affected: ProjectSend >= 2.5.0, < 2.7.0 |
| [CVE-2026-112003](https://nvd.nist.gov/vuln/detail/cve-2026-112003)  | ProjectSend 2.0.0 before 2.7.0 Path Validation Bypass via Orphan File Import/Delete Affected: ProjectSend >= 2.0.0, < 2.7.0 |
| [CVE-2026-112004](https://nvd.nist.gov/vuln/detail/cve-2026-112004) | Teable before 2026-10-12T12-45-53Z.3331 Authorization Bypass via Folder Rename Endpoint Affected: teable < 2026-10-12T12-45-53Z.3331 |
| [CVE-2026-111912](https://nvd.nist.gov/vuln/detail/cve-2026-111912) | forum topic update IDOR: no new ID |
| 추후 4개 더 작성 예정 | |
| | |
| | |
| | |



