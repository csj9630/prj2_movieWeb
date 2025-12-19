<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 영화 등록</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [공통 스타일 유지] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select, textarea { font-family: 'Noto Sans KR', sans-serif; }

        /* [사이드바] */
        .sidebar { width: 260px; background-color: #1e1e2d; color: #a2a3b7; display: flex; flex-direction: column; flex-shrink: 0; transition: all 0.3s; }
        .logo-area { height: 80px; display: flex; align-items: center; justify-content: center; background-color: #1b1b28; border-bottom: 1px solid #2d2d3f; }
        .logo-area img { height: 45px; object-fit: contain; display: block; }
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #5e6278; padding: 10px 25px; margin-top: 15px; }
        .menu-category:first-child { margin-top: 0; }
        .menu-link { display: flex; align-items: center; padding: 12px 25px; color: #a2a3b7; font-size: 14px; font-weight: 500; transition: 0.2s; border-left: 3px solid transparent; }
        .menu-link:hover, .menu-link.active { background-color: #2b2b40; color: #fff; border-left-color: #503396; }
        .menu-icon { width: 25px; font-size: 16px; text-align: center; margin-right: 10px; }
        .sidebar-footer { padding: 20px; border-top: 1px solid #2d2d3f; display: flex; align-items: center; gap: 12px; background-color: #1e1e2d; }
        .admin-avatar { width: 40px; height: 40px; background-color: #503396; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; font-size: 14px; }
        .admin-info h4 { font-size: 14px; color: #fff; font-weight: 500; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }

        /* [메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [탭] */
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }


        /* [등록 폼 컨테이너 (모달 스타일)] */
        .form-container {
            background-color: #fff; width: 850px; margin: 0 auto;
            border-radius: 15px; overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            display: flex; flex-direction: column;
            border: 1px solid #eee;
        }

        .form-header {
            padding: 20px 30px; background-color: #f9f9f9; border-bottom: 1px solid #eee;
        }
        .form-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }

        /* 폼 본문 (좌우 분할) */
        .form-body { padding: 40px; display: flex; gap: 40px; align-items: flex-start; }
        
        /* 좌측: 포스터 */
        .movie-poster-area { width: 260px; flex-shrink: 0; text-align: center; }
        .movie-poster {
            width: 100%; height: 380px; object-fit: cover; border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); margin-bottom: 15px;
            background-color: #eee; display: block;
        }
        .img-upload-btn {
            width: 100%; padding: 10px; background-color: #eee; color: #555;
            border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: 600;
            cursor: pointer;
        }
        .img-upload-btn:hover { background-color: #e0e0e0; }

        /* 우측: 입력 필드 */
        .movie-info-area { flex: 1; display: flex; flex-direction: column; gap: 20px; }
        
        .info-group { display: flex; flex-direction: column; }
        .info-label { font-size: 13px; font-weight: 700; color: #555; margin-bottom: 5px; }
        .required { color: #e74c3c; margin-left: 3px; }

        .info-input, .info-select {
            width: 100%; height: 40px; padding: 0 10px;
            border: 1px solid #ddd; border-radius: 4px; font-size: 14px; background-color: #fff;
        }
        .info-input:focus, .info-select:focus { border-color: #503396; }
        
        .intro-input {
            width: 100%; height: 100px; padding: 10px;
            border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: none;
            line-height: 1.6;
        }

        /* 멀티 선택 (감독/출연진) */
        .multi-select-container { position: relative; width: 100%; }
        .selected-tags {
            display: flex; flex-wrap: wrap; gap: 5px; padding: 5px;
            border: 1px solid #ddd; border-radius: 4px; min-height: 40px;
            background-color: #fff; cursor: text;
        }
        .tag {
            background-color: #e8fff3; color: #1bc5bd; font-size: 12px; font-weight: 600;
            padding: 4px 8px; border-radius: 4px; display: flex; align-items: center; gap: 5px;
        }
        .tag-close { cursor: pointer; font-weight: bold; }
        .search-input-inner { border: none; outline: none; font-size: 14px; flex: 1; min-width: 80px; height: 28px; }
        .dropdown-list {
            display: none; position: absolute; top: 100%; left: 0; width: 100%;
            max-height: 200px; overflow-y: auto; background: #fff; border: 1px solid #ddd;
            border-radius: 0 0 4px 4px; z-index: 10; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .dropdown-item { padding: 10px; font-size: 14px; cursor: pointer; transition: 0.2s; }
        .dropdown-item:hover { background-color: #f5f5f5; color: #503396; }

        /* 하단 버튼 */
        .form-footer {
            padding: 20px 30px; background-color: #f9f9f9; border-top: 1px solid #eee;
            display: flex; justify-content: flex-end; gap: 10px;
        }
        .btn-md { padding: 10px 30px; border-radius: 6px; font-weight: 600; font-size: 14px; cursor: pointer; transition: 0.2s; border: none; }
        .btn-save { background-color: #503396; color: #fff; }
        .btn-save:hover { background-color: #3e257a; }
        .btn-cancel { background-color: #fff; border: 1px solid #ddd; color: #555; }
        .btn-cancel:hover { background-color: #f9f9f9; }

    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="logo-area">
            <a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a>
        </div>
        <div class="menu-list">
            <div class="menu-category">MAIN</div>
            <ul><li><a href="../admin_dashboard/Admin_Dashboard.jsp" class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li></ul>
            <div class="menu-category">RESOURCE</div>
            <ul>
                <li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link"><i class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link active"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <div class="admin-avatar">AD</div>
            <div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div>
        </div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title"><h2>영화 관리</h2><p>등록된 영화 정보를 조회, 수정, 삭제합니다.</p></div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="sub-nav">
                <a href="Admin_MovieList.jsp" class="sub-nav-item">영화 조회</a>
                <a href="Admin_MovieRegister.jsp" class="sub-nav-item active">영화 등록</a>
            </div>

            <div class="form-container">
                <div class="form-header">
                    <span class="form-title">신규 영화 등록</span>
                </div>
                
                <form id="movieForm" action="MovieRegisterAction.jsp" method="post" enctype="multipart/form-data">
                    <div class="form-body">
                        <div class="movie-poster-area">
                            <img src="https://via.placeholder.com/250x360?text=Poster+Preview" id="previewPoster" class="movie-poster">
                            <button type="button" class="img-upload-btn" onclick="document.getElementById('fileInput').click()">
                                <i class="fa-solid fa-camera"></i> 포스터 등록
                            </button>
                            <input type="file" id="fileInput" name="poster" style="display:none" onchange="previewImage(this)" accept="image/*">
                        </div>

                        <div class="movie-info-area">
                            <div class="info-group">
                                <label class="info-label">영화 제목<span class="required">*</span></label>
                                <input type="text" class="info-input" name="title" placeholder="영화 제목을 입력하세요" required>
                            </div>

                            <div style="display:flex; gap:15px;">
                                <div class="info-group" style="flex:1;">
                                    <label class="info-label">장르<span class="required">*</span></label>
                                    <select class="info-select" name="genre">
                                        <option value="액션">액션</option><option value="범죄">범죄</option>
                                        <option value="코미디">코미디</option><option value="드라마">드라마</option>
                                        <option value="SF">SF</option><option value="애니메이션">애니메이션</option>
                                    </select>
                                </div>
                                <div class="info-group" style="flex:1;">
                                    <label class="info-label">관람 등급<span class="required">*</span></label>
                                    <select class="info-select" name="grade">
                                        <option value="전체 관람가">전체 관람가</option><option value="12세 관람가">12세 관람가</option>
                                        <option value="15세 관람가">15세 관람가</option><option value="청소년 불가">청소년 불가</option>
                                    </select>
                                </div>
                            </div>

                            <div style="display:flex; gap:15px;">
                                <div class="info-group" style="flex:1;">
                                    <label class="info-label">상영 시간<span class="required">*</span></label>
                                    <input type="text" class="info-input" name="runtime" placeholder="예: 120분">
                                </div>
                                <div class="info-group" style="flex:1;">
                                    <label class="info-label">개봉일<span class="required">*</span></label>
                                    <input type="date" class="info-input" name="releaseDate">
                                </div>
                            </div>

                            <div class="info-group">
                                <label class="info-label">감독<span class="required">*</span></label>
                                <div id="directorContainer" class="multi-select-container">
                                    <div class="selected-tags" onclick="toggleDropdown('directorList')">
                                        <input type="text" class="search-input-inner" placeholder="감독 검색..." onkeyup="filterList('directorList', this.value)">
                                    </div>
                                    <div id="directorList" class="dropdown-list">
                                        <div class="dropdown-item" onclick="addTag('directorContainer', '봉준호')">봉준호</div>
                                        <div class="dropdown-item" onclick="addTag('directorContainer', '박찬욱')">박찬욱</div>
                                        <div class="dropdown-item" onclick="addTag('directorContainer', '류승완')">류승완</div>
                                        <div class="dropdown-item" onclick="addTag('directorContainer', '최동훈')">최동훈</div>
                                        <div class="dropdown-item" onclick="addTag('directorContainer', '크리스토퍼 놀란')">크리스토퍼 놀란</div>
                                        </div>
                                </div>
                                <input type="hidden" name="directors" id="directorHidden">
                            </div>

                            <div class="info-group">
                                <label class="info-label">출연진<span class="required">*</span></label>
                                <div id="castContainer" class="multi-select-container">
                                    <div class="selected-tags" onclick="toggleDropdown('castList')">
                                        <input type="text" class="search-input-inner" placeholder="배우 검색..." onkeyup="filterList('castList', this.value)">
                                    </div>
                                    <div id="castList" class="dropdown-list">
                                        <div class="dropdown-item" onclick="addTag('castContainer', '마동석')">마동석</div>
                                        <div class="dropdown-item" onclick="addTag('castContainer', '손석구')">손석구</div>
                                        <div class="dropdown-item" onclick="addTag('castContainer', '김무열')">김무열</div>
                                        <div class="dropdown-item" onclick="addTag('castContainer', '박지환')">박지환</div>
                                        <div class="dropdown-item" onclick="addTag('castContainer', '이동휘')">이동휘</div>
                                        </div>
                                </div>
                                <input type="hidden" name="actors" id="castHidden">
                            </div>

                            <div class="info-group">
                                <label class="info-label">영화 소개</label>
                                <textarea class="intro-input" name="intro" placeholder="영화 줄거리를 입력하세요..."></textarea>
                            </div>

                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="button" class="btn-md btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-md btn-save" onclick="submitForm()">등록</button>
                    </div>
                </form>
            </div>

        </div>
    </main>

    <script>
        // 이미지 미리보기
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewPoster').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // 멀티 태그 기능
        function addTag(containerId, value) {
            const container = document.getElementById(containerId).querySelector('.selected-tags');
            const input = container.querySelector('.search-input-inner');
            
            // 중복 체크
            const exists = Array.from(container.querySelectorAll('.tag')).some(t => t.innerText.includes(value));
            if (exists) return;

            const tag = document.createElement('div');
            tag.className = 'tag';
            tag.innerHTML = value + ' <span class="tag-close" onclick="removeTag(this)">x</span>';
            container.insertBefore(tag, input);
            
            // 입력창 초기화 & 드롭다운 닫기
            input.value = '';
            input.focus();
        }

        function removeTag(element) {
            element.parentElement.remove();
        }

        function toggleDropdown(listId) {
            const list = document.getElementById(listId);
            list.style.display = (list.style.display === 'block') ? 'none' : 'block';
        }

        function filterList(listId, keyword) {
            const list = document.getElementById(listId);
            list.style.display = 'block';
            const items = list.getElementsByClassName('dropdown-item');
            for (let item of items) {
                if (item.innerText.includes(keyword)) item.style.display = 'block';
                else item.style.display = 'none';
            }
        }

        window.addEventListener('click', function(e) {
            if (!e.target.closest('.multi-select-container')) {
                document.querySelectorAll('.dropdown-list').forEach(el => el.style.display = 'none');
            }
        });

        // 폼 제출 (태그 값 hidden input에 담기)
        function submitForm() {
            // 감독 태그 수집
            const directorTags = document.querySelectorAll('#directorContainer .tag');
            const directors = Array.from(directorTags).map(t => t.innerText.replace(' x', '')).join(', ');
            document.getElementById('directorHidden').value = directors;

            // 배우 태그 수집
            const castTags = document.querySelectorAll('#castContainer .tag');
            const actors = Array.from(castTags).map(t => t.innerText.replace(' x', '')).join(', ');
            document.getElementById('castHidden').value = actors;

            alert('영화가 성공적으로 등록되었습니다.');
            // document.getElementById('movieForm').submit(); // 실제 DB 연동 시 주석 해제
            location.href = 'Admin_MovieList.jsp';
        }
    </script>

</body>
</html>