<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 리뷰 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 공통 스타일 (이전과 동일)] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f5f6fa;
            color: #333;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select, textarea { font-family: 'Noto Sans KR', sans-serif; }

        /* [2. 사이드바] */
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

        /* [3. 메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [4. 검색 필터] */
        .filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
        .filter-input { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
        .filter-input-long { flex: 1; }
        .filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .filter-btn:hover { background-color: #333; }
        .reset-btn { height: 45px; padding: 0 20px; background-color: #fff; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .reset-btn:hover { background-color: #f9f9f9; }

        /* [5. 테이블] */
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { cursor: pointer; transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }

        /* 별점 스타일 */
        .star-rating { color: #ffc107; font-size: 13px; }
        
        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }


        /* [6. 상세 모달 스타일] */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 2000; justify-content: center; align-items: center; }
        .modal-card { background-color: #fff; width: 600px; border-radius: 15px; overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.3); animation: slideUp 0.3s ease-out; display: flex; flex-direction: column; }
        @keyframes slideUp { from { transform: translateY(50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header { padding: 20px 30px; background-color: #f9f9f9; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }
        .modal-close { font-size: 24px; color: #aaa; cursor: pointer; }
        .modal-close:hover { color: #333; }

        .modal-body { padding: 30px 40px; }

        .review-detail-group { margin-bottom: 20px; }
        .detail-label { font-size: 13px; color: #888; font-weight: 700; margin-bottom: 5px; }
        .detail-text { font-size: 15px; color: #333; padding: 10px; background-color: #f9f9f9; border-radius: 6px; border: 1px solid #eee; }
        .review-content-box { min-height: 120px; line-height: 1.6; }

        .modal-footer { padding: 20px 30px; background-color: #f9f9f9; border-top: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        
        .btn-del-review { padding: 10px 20px; border-radius: 6px; background-color: #fdedec; border: 1px solid #fadbd8; color: #e74c3c; font-weight: 700; cursor: pointer; }
        .btn-del-review:hover { background-color: #fceae9; }
        .btn-close { padding: 10px 25px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd; color: #555; font-weight: 600; cursor: pointer; }
        .btn-close:hover { background-color: #f0f0f0; }

        /* [7. 확인 모달] */
        .confirm-card { background-color: #fff; width: 400px; border-radius: 12px; text-align: center; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .confirm-icon { font-size: 40px; color: #e74c3c; margin-bottom: 20px; }
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }
        .btn-confirm-yes { padding: 10px 30px; border-radius: 6px; border: none; font-weight: 700; cursor: pointer; background-color: #e74c3c; color: #fff; }
        .btn-confirm-no { padding: 10px 30px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd; color: #555; font-weight: 600; cursor: pointer; }

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
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link active"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer"><div class="admin-avatar">AD</div><div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div></div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>리뷰 관리</h2>
                <p>사용자가 작성한 영화 리뷰를 조회하고 관리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="filter-card">
                <select class="filter-input">
                    <option value="movie">영화명</option>
                    <option value="user">아이디</option>
                    <option value="content">내용</option>
                </select>
                <input type="text" class="filter-input filter-input-long" placeholder="검색어를 입력하세요">
                <button class="filter-btn">조회</button>
                <button class="reset-btn"><i class="fa-solid fa-rotate-right"></i></button>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span>3,450</span>개의 리뷰가 있습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="15%"> <col width="20%"> <col width="10%"> <col width="40%"> <col width="15%"> </colgroup>
                    <thead>
                        <tr>
                            <th>사용자 아이디</th>
                            <th>영화명</th>
                            <th>평점</th>
                            <th>리뷰 내용</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr onclick="openDetailModal('user1234', '범죄도시4', '5', '진짜 마석도 형사님 최고에요! ㅋㅋ 액션 타격감 미쳤고 유머도 빵빵 터짐 강추합니다', '2024-05-01')">
                            <td>user1234</td><td>범죄도시4</td>
                            <td><i class="fa-solid fa-star star-rating"></i> 5.0</td>
                            <td>진짜 마석도 형사님 최고에요! ㅋㅋ 액션 타격감...</td>
                            <td>2024-05-01</td>
                        </tr>
                        <tr onclick="openDetailModal('hong_gd', '퓨리오사: 매드맥스', '4.5', '액션은 좋은데 전작보다는 조금 아쉬움 그래도 볼만함', '2024-05-23')">
                            <td>hong_gd</td><td>퓨리오사: 매드맥스</td>
                            <td><i class="fa-solid fa-star star-rating"></i> 4.5</td>
                            <td>액션은 좋은데 전작보다는 조금 아쉬움 그래...</td>
                            <td>2024-05-23</td>
                        </tr>
                        <tr onclick="openDetailModal('test_user', '설계자', '2.0', '강동원 얼굴 보러 갔다가 스토리 때문에 실망함 ㅠ 개연성이 좀 부족한듯', '2024-05-30')">
                            <td>test_user</td><td>설계자</td>
                            <td><i class="fa-solid fa-star star-rating"></i> 2.0</td>
                            <td>강동원 얼굴 보러 갔다가 스토리 때문에 실망...</td>
                            <td>2024-05-30</td>
                        </tr>
                        <tr onclick="openDetailModal('movie_love', '인사이드 아웃 2', '5.0', '너무 감동적이에요 ㅠㅠ 어른들을 위한 애니메이션.. 눈물 콧물 다 뺌', '2024-06-13')">
                            <td>movie_love</td><td>인사이드 아웃 2</td>
                            <td><i class="fa-solid fa-star star-rating"></i> 5.0</td>
                            <td>너무 감동적이에요 ㅠㅠ 어른들을 위한 애니...</td>
                            <td>2024-06-13</td>
                        </tr>
                        <tr onclick="openDetailModal('popcorn_king', '원더랜드', '3.5', '소재는 신선한데 연출이 좀 루즈함. 탕웨이 연기는 좋았음', '2024-06-06')">
                            <td>popcorn_king</td><td>원더랜드</td>
                            <td><i class="fa-solid fa-star star-rating"></i> 3.5</td>
                            <td>소재는 신선한데 연출이 좀 루즈함. 탕웨이...</td>
                            <td>2024-06-06</td>
                        </tr>
                        <tr onclick="openDetailModal('blue_sky', '하이재킹', '4.0', '하정우 연기력 미쳤다.. 긴장감 대박임 꼭 보세요', '2024-06-22')">
                            <td>blue_sky</td><td>하이재킹</td><td><i class="fa-solid fa-star star-rating"></i> 4.0</td><td>하정우 연기력 미쳤다.. 긴장감 대박임...</td><td>2024-06-22</td>
                        </tr>
                        <tr onclick="openDetailModal('star_wars', '콰이어트 플레이스', '3.0', '깜짝 놀라는 장면 많음 팝콘 쏟을 뻔', '2024-06-27')">
                            <td>star_wars</td><td>콰이어트 플레이스</td><td><i class="fa-solid fa-star star-rating"></i> 3.0</td><td>깜짝 놀라는 장면 많음 팝콘 쏟을 뻔...</td><td>2024-06-27</td>
                        </tr>
                        <tr onclick="openDetailModal('cinema_fan', '탈주', '4.5', '이제훈 구교환 케미 좋음 달리는 장면에서 숨참고 봄', '2024-07-04')">
                            <td>cinema_fan</td><td>탈주</td><td><i class="fa-solid fa-star star-rating"></i> 4.5</td><td>이제훈 구교환 케미 좋음 달리는 장면에서...</td><td>2024-07-04</td>
                        </tr>
                        <tr onclick="openDetailModal('action_man', '데드풀과 울버린', '5.0', '이거지!!! 마블의 구세주 데드풀 사랑해요', '2024-07-25')">
                            <td>action_man</td><td>데드풀과 울버린</td><td><i class="fa-solid fa-star star-rating"></i> 5.0</td><td>이거지!!! 마블의 구세주 데드풀 사랑해요...</td><td>2024-07-25</td>
                        </tr>
                        <tr onclick="openDetailModal('comedy_queen', '파일럿', '4.0', '조정석 여장 연기 진짜 웃김 ㅋㅋㅋ 가족끼리 보기 좋음', '2024-08-01')">
                            <td>comedy_queen</td><td>파일럿</td><td><i class="fa-solid fa-star star-rating"></i> 4.0</td><td>조정석 여장 연기 진짜 웃김 ㅋㅋㅋ 가족끼...</td><td>2024-08-01</td>
                        </tr>
                        <tr onclick="openDetailModal('noir_lover', '리볼버', '3.5', '전도연 카리스마 ㄷㄷ 근데 내용은 좀 어려움', '2024-08-08')">
                            <td>noir_lover</td><td>리볼버</td><td><i class="fa-solid fa-star star-rating"></i> 3.5</td><td>전도연 카리스마 ㄷㄷ 근데 내용은 좀 어...</td><td>2024-08-08</td>
                        </tr>
                        <tr onclick="openDetailModal('scifi_mania', '에이리언: 로물루스', '4.5', '오랜만에 제대로 된 공포 SF 나옴 추천', '2024-08-15')">
                            <td>scifi_mania</td><td>에이리언: 로물루스</td><td><i class="fa-solid fa-star star-rating"></i> 4.5</td><td>오랜만에 제대로 된 공포 SF 나옴 추천...</td><td>2024-08-15</td>
                        </tr>
                        <tr onclick="openDetailModal('drama_king', '행복의 나라', '4.0', '이선균 배우님의 마지막 연기 잊지 않겠습니다 ㅠㅠ', '2024-08-15')">
                            <td>drama_king</td><td>행복의 나라</td><td><i class="fa-solid fa-star star-rating"></i> 4.0</td><td>이선균 배우님의 마지막 연기 잊지 않겠습...</td><td>2024-08-15</td>
                        </tr>
                        <tr onclick="openDetailModal('veteran_cop', '베테랑2', '4.5', '1편만큼 재밌음 정해인 눈빛 연기 소름', '2024-09-14')">
                            <td>veteran_cop</td><td>베테랑2</td><td><i class="fa-solid fa-star star-rating"></i> 4.5</td><td>1편만큼 재밌음 정해인 눈빛 연기 소름...</td><td>2024-09-14</td>
                        </tr>
                        <tr onclick="openDetailModal('joker_fan', '조커: 폴리 아 되', '3.0', '뮤지컬 요소가 호불호 갈릴듯 나는 불호', '2024-10-02')">
                            <td>joker_fan</td><td>조커: 폴리 아 되</td><td><i class="fa-solid fa-star star-rating"></i> 3.0</td><td>뮤지컬 요소가 호불호 갈릴듯 나는 불호...</td><td>2024-10-02</td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination">
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">3</a>
                </div>
            </div>
        </div>
    </main>

    <div id="detailModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <span class="modal-title">리뷰 상세 조회</span>
                <i class="fa-solid fa-xmark modal-close" onclick="closeDetailModal()"></i>
            </div>
            
            <div class="modal-body">
                <div class="review-detail-group">
                    <div class="detail-label">사용자 아이디</div>
                    <div id="m_userId" class="detail-text"></div>
                </div>
                <div class="review-detail-group">
                    <div class="detail-label">영화명</div>
                    <div id="m_movieTitle" class="detail-text"></div>
                </div>
                <div class="review-detail-group">
                    <div class="detail-label">평점</div>
                    <div id="m_rating" class="detail-text" style="color:#ffc107; font-weight:bold;"></div>
                </div>
                <div class="review-detail-group">
                    <div class="detail-label">작성일</div>
                    <div id="m_date" class="detail-text"></div>
                </div>
                <div class="review-detail-group">
                    <div class="detail-label">리뷰 내용</div>
                    <div id="m_content" class="detail-text review-content-box"></div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn-del-review" onclick="openConfirmModal()">삭제</button>
                <button class="btn-close" onclick="closeDetailModal()">닫기</button>
            </div>
        </div>
    </div>

    <div id="confirmModal" class="modal-overlay" style="z-index: 2100;">
        <div class="confirm-card">
            <div class="confirm-icon"><i class="fa-solid fa-trash-can"></i></div>
            <div class="confirm-text">해당 리뷰를 삭제하시겠습니까?</div>
            <div class="confirm-sub">삭제된 리뷰는 복구할 수 없습니다.</div>
            <div class="confirm-actions">
                <button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
                <button class="btn-confirm-yes" onclick="executeDelete()">예, 삭제합니다</button>
            </div>
        </div>
    </div>

    <script>
        // 상세 모달 열기
        function openDetailModal(userId, movieTitle, rating, content, date) {
            document.getElementById('m_userId').innerText = userId;
            document.getElementById('m_movieTitle').innerText = movieTitle;
            document.getElementById('m_rating').innerText = "★ " + rating;
            document.getElementById('m_content').innerText = content;
            document.getElementById('m_date').innerText = date;

            document.getElementById('detailModal').style.display = 'flex';
        }

        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
        }

        // 확인 모달 열기
        function openConfirmModal() {
            document.getElementById('confirmModal').style.display = 'flex';
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // 실제 삭제 동작
        function executeDelete() {
            alert('리뷰가 정상적으로 삭제되었습니다.');
            closeConfirmModal();
            closeDetailModal();
            // location.reload(); // 새로고침
        }

        // 외부 클릭 닫기
        window.onclick = function(event) {
            if (event.target == document.getElementById('detailModal')) closeDetailModal();
            if (event.target == document.getElementById('confirmModal')) closeConfirmModal();
        }
    </script>

</body>
</html>