<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [초기화] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #ecf0f3;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }

        /* [1. 로그인 컨테이너] */
        .login-card {
            position: absolute;
            top: 55%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #ecf0f3;
            width: 520px;
            padding: 70px 50px;
            border-radius: 30px;
            text-align: center;
            box-shadow: 18px 18px 30px #cbced1, -18px -18px 30px white;
            z-index: 10; /* 장식 이미지보다 위에 오도록 설정 */
        }

        /* [2. 상단 로고 영역] */
        .top-logo-area {
            position: absolute;
            top: -200px; 
            left: 0;
            width: 100%;
            display: flex;
            justify-content: center;
        }
        
        .top-logo-area img {
            height: 150px; 
            object-fit: contain;
            display: block;
            filter: drop-shadow(5px 5px 10px rgba(0,0,0,0.1));
        }

        /* [3. 하단 장식 이미지 (New!)] */
        .deco-img {
            position: absolute;
            bottom: 0;
            z-index: 1; /* 배경보다는 위, 카드보다는 아래 */
            width: 500px; /* 적절한 크기로 조절하세요 */
            opacity: 0.8; /* 너무 튀지 않게 살짝 투명도 */
            pointer-events: none; /* 클릭 방지 */
        }

        .deco-left {
            left: 0;
            /* 이미지가 너무 딱 붙지 않게 위치 미세 조정 가능 */
            /* transform: translate(-10%, 10%); */
        }

        .deco-right {
            right: 0;
            /* transform: translate(10%, 10%); */
        }


        /* [나머지 기존 스타일 유지] */
        .login-header { margin-bottom: 45px; }
        .login-title { font-size: 34px; font-weight: 900; color: #333; letter-spacing: -1px; margin: 0; }
        .input-group { position: relative; margin-bottom: 30px; text-align: left; }
        .input-icon { position: absolute; top: 50%; left: 25px; transform: translateY(-50%); color: #999; font-size: 20px; }
        .input-field { width: 100%; height: 65px; padding: 0 25px 0 60px; border: none; border-radius: 60px; font-size: 17px; background-color: #ecf0f3; color: #333; font-family: 'Noto Sans KR', sans-serif; box-shadow: inset 6px 6px 6px #cbced1, inset -6px -6px 6px white; transition: all 0.3s ease; }
        .input-field:focus { box-shadow: inset 4px 4px 4px #babecc, inset -4px -4px 4px white; color: #503396; }
        .input-field::placeholder { color: #aaa; font-size: 16px; }
        .login-btn { width: 100%; height: 65px; background-color: #503396; color: #fff; font-size: 20px; font-weight: 800; border: none; border-radius: 60px; cursor: pointer; margin-top: 15px; box-shadow: 6px 6px 10px rgba(80, 51, 150, 0.2), -6px -6px 10px rgba(255, 255, 255, 0.8); transition: all 0.2s ease; }
        .login-btn:active { transform: scale(0.98); box-shadow: 2px 2px 5px rgba(80, 51, 150, 0.2), -2px -2px 5px rgba(255, 255, 255, 0.8); }
        .login-btn:hover { background-color: #3e257a; }
        .login-footer { margin-top: 40px; font-size: 15px; color: #888; }
        .login-footer a { color: #333; font-weight: 700; margin-left: 5px; text-decoration: none; }
        .login-footer a:hover { color: #503396; }

    </style>
</head>
<body>

    <!-- [하단 장식 이미지 추가] -->
    <!-- 왼쪽 하단 이미지 -->
    <img src="../../resources/img/deco_left.png" class="deco-img deco-left" alt="deco">
    
    <!-- 오른쪽 하단 이미지 -->
    <img src="../../resources/img/deco_right.png" class="deco-img deco-right" alt="deco">


    <!-- [로그인 컨테이너] -->
    <div class="login-card">
        
        <div class="top-logo-area">
            <img src="../../resources/img/2GV_LOGO_empty.png" alt="2GV Logo">
        </div>

        <div class="login-header">
            <h2 class="login-title">관리자 로그인</h2>
        </div>

        <form action="../admin_dashboard/Admin_Dashboard.jsp" method="post">
            <div class="input-group">
                <i class="fa-solid fa-user input-icon"></i>
                <input type="text" name="adminId" class="input-field" placeholder="Admin ID" required autocomplete="off">
            </div>

            <div class="input-group">
                <i class="fa-solid fa-lock input-icon"></i>
                <input type="password" name="adminPass" class="input-field" placeholder="Password" required>
            </div>

            <button type="submit" class="login-btn">LOGIN</button>
        </form>

        <div class="login-footer">
            <p>계정을 잊으셨나요? <a href="#">복구하기</a></p>
        </div>
    </div>

</body>
</html>