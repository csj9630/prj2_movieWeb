<%@page import="movie.image_admin.AdminImageDAO"%>
<%@page import="movie.image_admin.AdminImageDTO"%>
<%@page import="movie.trailer_admin.TrailerDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.movie_admin.MovieDTO"%>
<%@page import="movie.admin.AdminMovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // [세션 검사]
    String adminId = (String) session.getAttribute("adminId");
    if (adminId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "../admin_login/Admin_Login.jsp";
    </script>
<%
        return;
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String mode = "insert";
    MovieDTO mDTO = null;
    List<TrailerDTO> tList = null; 
    List<AdminImageDTO> sList = null;

    if(id != null && !id.equals("")){
        mode = "update";
        AdminMovieService as = AdminMovieService.getInstance();
        mDTO = as.getMovie(id);
        
        // 트레일러 정보 가져오기
        tList = as.getTrailers(id); 
        
        // 스틸컷 정보 가져오기 (DAO 호출)
        sList = movie.image_admin.AdminImageDAO.getInstance().selectStillCuts(id);
    }
    
    pageContext.setAttribute("mode", mode);
    pageContext.setAttribute("mDTO", mDTO);
    pageContext.setAttribute("tList", tList);
    pageContext.setAttribute("sList", sList);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 영화 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <style>
        /* 초기화 및 레이아웃 */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        
        /* 사이드바 스타일 */
        .sidebar { width: 260px; background-color: #1e1e2d; color: #a2a3b7; display: flex; flex-direction: column; flex-shrink: 0; }
        .logo-area { height: 80px; display: flex; align-items: center; justify-content: center; background-color: #1b1b28; border-bottom: 1px solid #2d2d3f; }
        .logo-area img { height: 45px; object-fit: contain; }
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #5e6278; padding: 10px 25px; margin-top: 15px; }
        .menu-category:first-child { margin-top: 0; }
        .menu-link { display: flex; align-items: center; padding: 12px 25px; color: #a2a3b7; font-size: 14px; font-weight: 500; text-decoration: none; border-left: 3px solid transparent; }
        .menu-link:hover, .menu-link.active { background-color: #2b2b40; color: #fff; border-left-color: #503396; }
        .menu-icon { width: 25px; text-align: center; margin-right: 10px; }
        .sidebar-footer { padding: 20px; border-top: 1px solid #2d2d3f; display: flex; align-items: center; gap: 12px; background-color: #1e1e2d; }
        .admin-avatar { width: 40px; height: 40px; background-color: #503396; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; }
        .admin-info h4 { font-size: 14px; color: #fff; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }

        /* 메인 컨텐츠 영역 */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #fff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; }
        .header-left-title p { font-size: 13px; color: #888; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; cursor: pointer; }

        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }
        .form-container { background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 900px; margin: 0 auto; }
        
        /* 폼 스타일 */
        .input-section { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; padding-bottom: 30px; border-bottom: 1px solid #eee; margin-bottom: 30px; }
        .full-width { grid-column: span 2; }
        .form-group { margin-bottom: 5px; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        .form-input, .form-select, .form-textarea { width: 100%; padding: 0 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; height: 45px; }
        .form-textarea { height: 120px; padding: 15px; resize: none; }
        .form-input:read-only { background-color: #f9f9f9; color: #888; cursor: default; }
        .form-input:focus, .form-select:focus, .form-textarea:focus { border-color: #503396; }
        
        /* 이미지 업로드 관련 */
        .image-upload-area { display: flex; gap: 20px; }
        .preview-box { flex: 1; border: 1px dashed #ddd; border-radius: 8px; padding: 15px; text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 250px; background-color: #fafafa; }
        .preview-img { max-width: 100%; max-height: 200px; object-fit: contain; margin-bottom: 15px; border-radius: 4px; display: block; }
        .file-input { display: none; }
        .upload-btn { padding: 8px 16px; background-color: #eee; border-radius: 4px; font-size: 12px; font-weight: 600; color: #555; cursor: pointer; transition: 0.2s; }
        .upload-btn:hover { background-color: #e0e0e0; }
        
        /* 스틸컷 그리드 */
        .stillcut-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; }
        .stillcut-box { border: 1px dashed #ddd; border-radius: 6px; padding: 10px; text-align: center; min-height: 150px; display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #fafafa; }
        .stillcut-img { max-width: 100%; max-height: 100px; object-fit: contain; margin-bottom: 10px; display: block; }

        /* 버튼 및 태그 스타일 */
        .form-actions { display: flex; justify-content: center; gap: 10px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; }
        .btn-save { background-color: #503396; color: #fff; padding: 12px 30px; border-radius: 6px; font-weight: 700; cursor: pointer; border: none; }
        .btn-cancel { background-color: #fff; border: 1px solid #ddd; color: #555; padding: 12px 30px; border-radius: 6px; font-weight: 600; cursor: pointer; }

        .tag-container { border: 1px solid #ddd; border-radius: 6px; padding: 5px; min-height: 45px; display: flex; flex-wrap: wrap; gap: 5px; background-color: #fff; }
        .tag-item { background-color: #e8fff3; color: #1bc5bd; font-size: 13px; font-weight: 600; padding: 5px 10px; border-radius: 4px; display: flex; align-items: center; gap: 6px; }
        .tag-close { cursor: pointer; font-size: 12px; color: #1bc5bd; opacity: 0.7; }
        .tag-close:hover { opacity: 1; }
        .search-group { display: flex; gap: 8px; }
        .btn-search-icon { width: 45px; background: #1e1e2d; color: #fff; border-radius: 6px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; }

        /* 트레일러 입력 스타일 */
        .trailer-input-group { display: flex; gap: 8px; margin-bottom: 8px; }
        .btn-add-trailer { background: #503396; color: #fff; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 12px; margin-bottom: 10px; }
        .btn-remove-trailer { background: #ffdede; color: #e74c3c; border: 1px solid #fadbd8; width: 45px; border-radius: 6px; cursor: pointer; display: flex; justify-content: center; align-items: center; }
        .btn-remove-trailer:hover { background-color: #fceae9; }

        /* 모달 스타일 */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 999; justify-content: center; align-items: center; }
        .modal-box { background: #fff; width: 400px; padding: 25px; border-radius: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 18px; font-weight: 700; margin-bottom: 15px; display: flex; justify-content: space-between; }
        .modal-body { max-height: 400px; overflow-y: auto; }
        .search-result-list { list-style: none; margin-top: 10px; border: 1px solid #eee; border-radius: 4px; }
        .search-result-item { padding: 10px; border-bottom: 1px solid #eee; cursor: pointer; font-size: 14px; transition: 0.2s; }
        .search-result-item:hover { background-color: #f5f6fa; color: #503396; font-weight: 600; }
        .search-result-item:last-child { border-bottom: none; }
        .modal-close-btn { cursor: pointer; color: #999; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="logo-area"><a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a></div>
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
            <div class="admin-avatar">
                <%= adminId != null && adminId.length() >= 2 ? adminId.substring(0, 2).toUpperCase() : "AD" %>
            </div>
            <div class="admin-info">
                <h4><%= adminId %></h4>
                <p>Admin Account</p>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>영화 등록/수정</h2>
                <p>새로운 영화를 등록하거나 기존 정보를 수정합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="form-container">
                <form id="movieForm" enctype="multipart/form-data">
                    <input type="hidden" name="mode" value="${ mode }">
                    <input type="hidden" name="prevMainImage" value="${ mDTO.mainImage }">
                    <input type="hidden" name="prevBgImage" value="${ mDTO.bgImage }">
                    
                    <input type="hidden" name="trailerList" id="trailerList">
                    
                    <div class="input-section">
                        <div class="form-group">
                            <label class="form-label">영화 코드</label>
                            <input type="text" name="id" class="form-input" value="${ mDTO.movieCode }" placeholder="${ mode eq 'insert' ? '자동 생성됩니다' : '' }" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">영화 제목</label>
                            <input type="text" name="name" id="name" class="form-input" value="${ mDTO.movieName }" placeholder="영화 제목 입력">
                        </div>
                        <div class="form-group">
                            <label class="form-label">장르</label>
                            <input type="text" name="genre" class="form-input" value="${ mDTO.movieGenre }" placeholder="예: 액션, 드라마">
                        </div>
                        <div class="form-group">
                            <label class="form-label">러닝타임 (분)</label>
                            <input type="number" name="time" class="form-input" value="${ mDTO.runningTime }" placeholder="숫자만 입력">
                        </div>

                        <div class="form-group">
                            <label class="form-label">감독</label>
                            <input type="hidden" name="director" id="directorInput" value="${ mDTO.directorNames }">
                            <div class="search-group">
                                <div id="directorTags" class="tag-container" style="flex:1;"></div>
                                <button type="button" class="btn-search-icon" onclick="openSearchModal('director')">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">출연진</label>
                            <input type="hidden" name="actors" id="actorInput" value="${ mDTO.actorNames }">
                            <div class="search-group">
                                <div id="actorTags" class="tag-container" style="flex:1;"></div>
                                <button type="button" class="btn-search-icon" onclick="openSearchModal('actor')">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">관람 등급</label>
                            <select name="grade" class="form-select">
                                <option value="전체 이용가" ${ mDTO.movieGrade eq '전체 이용가' ? 'selected' : '' }>전체 이용가</option>
                                <option value="12세 이용가" ${ mDTO.movieGrade eq '12세 이용가' ? 'selected' : '' }>12세 이용가</option>
                                <option value="15세 이용가" ${ mDTO.movieGrade eq '15세 이용가' ? 'selected' : '' }>15세 이용가</option>
                                <option value="청소년 관람불가" ${ mDTO.movieGrade eq '청소년 관람불가' ? 'selected' : '' }>청소년 관람불가</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">개봉일</label>
                            <input type="date" name="release" id="release" class="form-input" value="${ mDTO.releaseDate }">
                        </div>
                        
                        <div class="form-group full-width">
                            <label class="form-label">상영 상태</label>
                            <select name="showing" class="form-select">
                                <option value="개봉예정" ${ mDTO.showing eq '개봉예정' ? 'selected' : '' }>개봉예정</option>
                                <option value="상영중" ${ mDTO.showing eq '상영중' ? 'selected' : '' }>상영중</option>
                                <option value="상영종료" ${ mDTO.showing eq '상영종료' ? 'selected' : '' }>상영종료</option>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">줄거리</label>
                            <textarea name="intro" class="form-textarea" placeholder="영화 줄거리를 입력하세요">${ mDTO.intro }</textarea>
                        </div>
                    </div>

                    <div class="input-section" style="border-bottom: none; grid-template-columns: 1fr 1fr;">
                        
                        <div class="form-group">
                            <label class="form-label">메인 포스터 (1장)</label>
                            <div class="preview-box">
                                <img id="previewMain" class="preview-img" 
                                     src="${ not empty mDTO.mainImage && not empty mDTO.movieCode ? '../../resources/images/movieImg/' += mDTO.movieCode += '/' += mDTO.mainImage : '../../resources/images/no_image.png' }" 
                                     onerror="this.onerror=null; this.src='../../resources/images/no_image.png'">
                                <label for="mainImage" class="upload-btn">이미지 선택</label>
                                <input type="file" id="mainImage" name="mainImage" class="file-input" accept="image/*" onchange="handlePreview(this, '#previewMain')">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">배경 이미지 (1장)</label>
                            <div class="preview-box">
                                <img id="previewBg" class="preview-img" 
                                     src="${ not empty mDTO.bgImage && not empty mDTO.movieCode ? '../../resources/images/movieImg/' += mDTO.movieCode += '/' += mDTO.bgImage : '../../resources/images/no_image.png' }" 
                                     onerror="this.onerror=null; this.src='../../resources/images/no_image.png'">
                                <label for="bgImage" class="upload-btn">이미지 선택</label>
                                <input type="file" id="bgImage" name="bgImage" class="file-input" accept="image/*" onchange="handlePreview(this, '#previewBg')">
                            </div>
                        </div>
                        
                        <div class="form-group full-width" style="margin-top: 30px;">
                            <label class="form-label">스틸컷 (최대 6장)</label>
                            <div class="stillcut-grid">
                                <% for(int i=1; i<=6; i++) { 
                                   String currentSrc = "../../resources/images/no_image.png";
                                   if(sList != null && sList.size() >= i) {
                                       AdminImageDTO sDto = sList.get(i-1);
                                       if(sDto.getImg_path() != null) {
                                           currentSrc = "../../resources/images/movieImg/" + sDto.getMovie_code() + "/" + sDto.getImg_path();
                                       }
                                   }
                                %>
                                <div class="stillcut-box">
                                    <span style="font-size:12px; color:#999; margin-bottom:5px;">스틸컷 <%=i%></span>
                                    <img id="previewStill<%=i%>" class="stillcut-img" src="<%=currentSrc%>" onerror="this.onerror=null; this.src='../../resources/images/no_image.png'">
                                    <label for="stillCut<%=i%>" class="upload-btn">선택</label>
                                    <input type="file" id="stillCut<%=i%>" name="stillCut<%=i%>" class="file-input" accept="image/*" onchange="handlePreview(this, '#previewStill<%=i%>')">
                                </div>
                                <% } %>
                            </div>
                        </div>

                        <div class="form-group full-width" style="margin-top: 20px;">
                            <label class="form-label">트레일러 (YouTube URL)</label>
                            <button type="button" class="btn-add-trailer" onclick="addTrailerField()">+ 트레일러 추가</button>
                            <div id="trailerContainer">
                                <c:choose>
                                    <c:when test="${ not empty tList }">
                                        <c:forEach var="t" items="${ tList }">
                                            <div class="trailer-input-group">
                                                <input type="text" name="trailer" class="form-input" 
                                                       value="https://youtu.be/${ t.url_path }" 
                                                       placeholder="YouTube URL을 입력하세요 (예: https://youtu.be/xxx)">
                                                <button type="button" class="btn-remove-trailer" onclick="removeTrailerField(this)">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="trailer-input-group">
                                            <input type="text" name="trailer" class="form-input" placeholder="YouTube URL을 입력하세요 (예: https://youtu.be/xxx)">
                                            <button type="button" class="btn-remove-trailer" onclick="removeTrailerField(this)">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-save" onclick="saveMovie()">저장 완료</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <div id="searchModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <span id="modalTitle">감독 검색</span>
                <i class="fa-solid fa-xmark modal-close-btn" onclick="closeModal()"></i>
            </div>
            <div class="modal-body">
                <input type="text" id="modalSearchInput" class="form-input" placeholder="이름을 검색하세요..." onkeyup="performSearch()">
                <ul id="searchResultList" class="search-result-list">
                    </ul>
            </div>
        </div>
    </div>

    <script>
        // 전역 변수
        let selectedDirectors = [];
        let selectedActors = [];
        let currentSearchType = "";

        // [중요] handlePreview를 $(function(){}) 밖으로 꺼냈습니다.
        // 이제 HTML 태그의 onchange에서 이 함수를 찾을 수 있습니다.
        function handlePreview(input, imgSelector) {
            if (input.files && input.files[0]) {
                var file = input.files[0];
                var maxSize = 100 * 1024 * 1024; // 100MB
                
                if(file.size > maxSize){
                    alert("이미지 용량이 너무 큽니다. (100MB 이하만 가능)");
                    $(input).val(""); // 파일 선택 취소
                    // 미리보기 이미지를 no_image로 초기화 (경로 주의)
                    $(imgSelector).attr("src", "../../resources/images/no_image.png");
                    return;
                }
                
                var reader = new FileReader();
                reader.onload = function(e) { 
                    // 파일 읽기가 성공하면 img 태그의 src를 변경
                    $(imgSelector).attr("src", e.target.result); 
                }
                reader.readAsDataURL(file);
            }
        }

        // 트레일러 필드 추가/삭제 함수도 밖으로 꺼내는 것이 안전합니다.
        function addTrailerField() {
            const html = `
                <div class="trailer-input-group">
                    <input type="text" name="trailer" class="form-input" placeholder="YouTube URL을 입력하세요">
                    <button type="button" class="btn-remove-trailer" onclick="removeTrailerField(this)"><i class="fa-solid fa-trash"></i></button>
                </div>`;
            $("#trailerContainer").append(html);
        }

        function removeTrailerField(btn) {
            if($("#trailerContainer .trailer-input-group").length <= 1) {
                $(btn).prev("input").val(""); 
                return;
            }
            $(btn).closest(".trailer-input-group").remove();
        }

        // --- jQuery 초기화 영역 ---
        $(function() {
            // 초기 데이터 로딩
            initTags("director", $("#directorInput").val());
            initTags("actor", $("#actorInput").val());

            // 메인/배경 이미지는 ID로 이벤트 연결되어 있음 (그래도 handlePreview가 전역이면 작동함)
            $("#mainImage").on("change", function() { handlePreview(this, "#previewMain"); });
            $("#bgImage").on("change", function() { handlePreview(this, "#previewBg"); });
        });

        // --- 태그 및 검색 관련 함수들 (전역) ---
        function initTags(type, dataString) {
            if(!dataString) return;
            const names = dataString.split(",");
            names.forEach(name => { name = name.trim(); if(name) addTag(type, name); });
        }

        function openSearchModal(type) {
            currentSearchType = type;
            $("#modalTitle").text(type === 'director' ? '감독 검색' : '출연진 검색');
            $("#modalSearchInput").val("").focus();
            $("#searchResultList").empty();
            $("#searchModal").css("display", "flex");
        }

        function closeModal() {
            $("#searchModal").hide();
        }

        function performSearch() {
            const keyword = $("#modalSearchInput").val();
            if(keyword.length < 1) {
                $("#searchResultList").empty();
                return;
            }

            $.ajax({
                url: "api_search_people.jsp",
                type: "get",
                data: { type: currentSearchType, keyword: keyword },
                dataType: "json",
                success: function(json) {
                    const list = $("#searchResultList");
                    list.empty();
                    if(json.length === 0) {
                        list.append("<li class='search-result-item'>검색 결과가 없습니다.</li>");
                    } else {
                        $.each(json, function(index, name) {
                            const li = $("<li>").addClass("search-result-item").text(name);
                            li.on("click", function() {
                                addTag(currentSearchType, name);
                                closeModal();
                            });
                            list.append(li);
                        });
                    }
                },
                error: function() {
                    console.error("검색 API 호출 실패");
                }
            });
        }

        function addTag(type, name) {
            let targetArray = (type === 'director') ? selectedDirectors : selectedActors;
            let containerId = (type === 'director') ? "#directorTags" : "#actorTags";
            
            if(targetArray.includes(name)) {
                alert("이미 추가된 이름입니다.");
                return;
            }
            
            targetArray.push(name);
            updateHiddenInput(type);

            const tag = $("<div>").addClass("tag-item").text(name);
            const closeBtn = $("<i>").addClass("fa-solid fa-xmark tag-close");
            
            closeBtn.on("click", function() {
                removeTag(type, name, tag);
            });
            tag.append(closeBtn);
            $(containerId).append(tag);
        }

        function removeTag(type, name, tagElement) {
            let targetArray = (type === 'director') ? selectedDirectors : selectedActors;
            const idx = targetArray.indexOf(name);
            if(idx > -1) {
                targetArray.splice(idx, 1);
            }
            updateHiddenInput(type);
            tagElement.remove();
        }

        function updateHiddenInput(type) {
            let targetArray = (type === 'director') ? selectedDirectors : selectedActors;
            let inputId = (type === 'director') ? "#directorInput" : "#actorInput";
            $(inputId).val(targetArray.join(","));
        }

        // 저장 버튼
        function saveMovie() {
            if($("#name").val().trim() === "") {
                alert("영화 제목을 입력해주세요.");
                $("#name").focus();
                return;
            }
            if($("#release").val() === "") {
                alert("개봉일을 선택해주세요.");
                $("#release").focus();
                return;
            }

            // 트레일러 URL 합치기
            let urls = [];
            $("input[name='trailer']").each(function() {
                let val = $(this).val().trim();
                if(val !== "") urls.push(val);
            });
            $("#trailerList").val(urls.join(","));

            $(".btn-save").prop("disabled", true).text("저장 중...");
            var form = $('#movieForm')[0];
            var formData = new FormData(form);

            $.ajax({
                url: "admin_movie_register_process.jsp",
                type: "post",
                enctype: 'multipart/form-data',
                data: formData,
                processData: false,
                contentType: false,
                dataType: "json",
                success: function(json) {
                    if(json.result) {
                        alert("저장이 완료되었습니다.");
                        location.href = "Admin_MovieList.jsp";
                    } else {
                        alert("저장에 실패했습니다.");
                        $(".btn-save").prop("disabled", false).text("저장 완료");
                    }
                },
                error: function(xhr) {
                    alert("서버 통신 오류: " + xhr.status);
                    $(".btn-save").prop("disabled", false).text("저장 완료");
                }
            });
        }
    </script>
</body>
</html>