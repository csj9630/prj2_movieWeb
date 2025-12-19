/*==============업데이트 내용============================*/
/*
2025-12-12 : 이미지 파일명을 mc001_still_001.jpg로 변경
						영화 데이터 50개까지 추가
2025-12-11 : movie, trailer, MOVIE_IMAGE 가데이터를 insert all로 수정 및 데이터  추가

2025-12-11 : PK키 포맷 변경 완료 (1자리 -> 3자리 패딩)
             ex) dc1 -> dc001, tn1 -> tn001, scc1 -> scc001 등
2025-12-10 : movie, trailer, MOVIE_IMAGE 테이블 구조 및 가데이터 수정
2025-12-10 : F5로 실행 잘되게 제미나이 찬스로 수정함.
*/

/* ============================================== */
/* 초기화 (테이블 삭제)               */
/* ============================================== */
DROP TABLE ANNOUNCE CASCADE CONSTRAINTS;
DROP TABLE MOVIE_IMAGE CASCADE CONSTRAINTS;
DROP TABLE TRAILER CASCADE CONSTRAINTS;
DROP TABLE REVIEW CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE SEAT_BOOK CASCADE CONSTRAINTS;
DROP TABLE BOOK CASCADE CONSTRAINTS;
DROP TABLE SCREEN_INFO CASCADE CONSTRAINTS;
DROP TABLE CAST CASCADE CONSTRAINTS;
DROP TABLE MOVIE_DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE SEAT CASCADE CONSTRAINTS;
DROP TABLE THEATHER_INFO CASCADE CONSTRAINTS;
DROP TABLE SOUND CASCADE CONSTRAINTS;
DROP TABLE BOOK_RATE CASCADE CONSTRAINTS;
DROP TABLE MOVIE CASCADE CONSTRAINTS;
DROP TABLE CINEMA_INFO CASCADE CONSTRAINTS;
DROP TABLE ACTOR CASCADE CONSTRAINTS;
DROP TABLE DIRECTOR CASCADE CONSTRAINTS;
DROP TABLE DISCOUNT CASCADE CONSTRAINTS;
DROP TABLE ADMIN CASCADE CONSTRAINTS;
DROP TABLE USERS CASCADE CONSTRAINTS;

/* ============================================== */
/* 테이블 생성 (CREATE)              */
/* ============================================== */

/* 1. 유저 */
CREATE TABLE USERS (
    users_id VARCHAR2(30) NOT NULL PRIMARY KEY,
    users_pass VARCHAR2(30) NOT NULL,
    email VARCHAR2(60) NOT NULL,
    users_name VARCHAR2(40) NOT NULL,
    birth DATE NOT NULL,
    gender CHAR(10) NOT NULL,
    users_image VARCHAR2(100) NOT NULL,
    recent_login DATE NOT NULL,
    join_date DATE NOT NULL,
    active CHAR(10) NOT NULL,
    phone_num VARCHAR2(30) NOT NULL
);

/* 2. 관리자 */
CREATE TABLE ADMIN (
    admin_id VARCHAR2(40) NOT NULL PRIMARY KEY,
    admin_pass VARCHAR2(40) NOT NULL,
    create_date DATE NOT NULL
);

/* 3. 할인 */
CREATE TABLE DISCOUNT (
    discount_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    discount_type VARCHAR2(30) NOT NULL,
    discount_rate NUMBER NOT NULL,
    discount_people VARCHAR2(30) NOT NULL
);

/* 4. 감독 */
CREATE TABLE DIRECTOR (
    director_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    director_name VARCHAR2(40) NOT NULL
);

/* 5. 배우 */
CREATE TABLE ACTOR (
    actor_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    actor_name VARCHAR2(50) NOT NULL
);

/* 6. 영화관 정보 */
CREATE TABLE CINEMA_INFO (
    cinema_num VARCHAR2(30) NOT NULL PRIMARY KEY,
    cinema_name VARCHAR2(30) NOT NULL,
    cinema_location VARCHAR2(60) NOT NULL
);

/* 7. 영화 */
CREATE TABLE MOVIE (
    movie_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    movie_name VARCHAR2(90) NOT NULL,
    movie_genre VARCHAR2(50) NOT NULL,
    running_time VARCHAR2(30) NOT NULL,
    movie_grade VARCHAR2(30) NOT NULL,
    release_date VARCHAR2(30) NOT NULL,
    intro VARCHAR2(999) NOT NULL,
    main_image VARCHAR2(60) NOT NULL,
    bg_image VARCHAR2(60) NOT NULL,
    daily_audience VARCHAR2(30) NOT NULL,
    total_audience VARCHAR2(30) NOT NULL,
    movie_delete CHAR(10) NOT NULL,
    showing VARCHAR2(30) NOT NULL
);

/* 8. 예매율 */
CREATE TABLE BOOK_RATE(
    bookrate_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    book_rate NUMBER NOT NULL,
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_RATE_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 9. 사운드 시스템 */
CREATE TABLE SOUND (
    sound_code VARCHAR2(20) NOT NULL PRIMARY KEY,
    sound_name VARCHAR2(60) NOT NULL
);

/* 10. 상영관 정보 */
CREATE TABLE THEATHER_INFO (
    theather_num VARCHAR2(20) NOT NULL PRIMARY KEY,
    theather_name VARCHAR2(30) NOT NULL,
    total_seat NUMBER NOT NULL,
    availability CHAR(10) NOT NULL,
    cinema_num VARCHAR2(30) NOT NULL CONSTRAINT FK_THEATHER_INFO_CINEMA_NUM REFERENCES CINEMA_INFO(CINEMA_NUM),
    sound_code VARCHAR2(20) NOT NULL CONSTRAINT FK_THEATHER_INFO_SOUND_CODE REFERENCES SOUND(SOUND_CODE)
);

/* 11. 좌석 */
CREATE TABLE SEAT (
    seat_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    seat_row VARCHAR2(30) NOT NULL,
    seat_col VARCHAR2(30) NOT NULL,
    available_seat VARCHAR2(20) NOT NULL,
    theather_num VARCHAR2(20) NOT NULL CONSTRAINT FK_SEAT_THEATHER_NUM REFERENCES THEATHER_INFO(THEATHER_NUM)
);

/* 12. 영화 감독 */
CREATE TABLE MOVIE_DIRECTOR (
    director_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_DIRECTOR_DIRECTOR_CODE REFERENCES DIRECTOR(DIRECTOR_CODE),
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_DIRECTOR_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 13. 출연진 */
CREATE TABLE CAST (
    actor_code VARCHAR2(30) NOT NULL CONSTRAINT FK_CAST_ACTOR_CODE REFERENCES ACTOR(ACTOR_CODE),
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_CAST_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 14. 상영 정보 */
CREATE TABLE SCREEN_INFO (
    screen_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    screen_open DATE NOT NULL,
    screen_end DATE NOT NULL,
    screen_price NUMBER NOT NULL,
    screen_date DATE NOT NULL,
    screen_delete CHAR(10) NOT NULL,
    screen_showing CHAR(10) NOT NULL,
    theather_num VARCHAR2(20) NOT NULL CONSTRAINT FK_SCREEN_INFO_THEATHER_NUM REFERENCES THEATHER_INFO(THEATHER_NUM),
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SCREEN_INFO_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 15. 예매 */
CREATE TABLE BOOK (
    book_num VARCHAR2(30) NOT NULL PRIMARY KEY,
    book_time VARCHAR2(30) NOT NULL,
    book_state VARCHAR2(30) NOT NULL,
    book_cancel DATE,
    total_book NUMBER NOT NULL,
    screen_code VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_SCREEN_CODE REFERENCES SCREEN_INFO(SCREEN_CODE),
    users_id VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_USERS_ID REFERENCES USERS(USERS_ID)
);

/* 16. 예매 좌석 */
CREATE TABLE SEAT_BOOK (
    seat_book_code VARCHAR2(30) NOT NULL,
    seat_code VARCHAR2(30) NOT NULL,
    screen_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_SCREEN_CODE REFERENCES SCREEN_INFO(SCREEN_CODE),
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_BOOK_NUM REFERENCES BOOK(BOOK_NUM),
    discount_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_DISCOUNT_CODE REFERENCES DISCOUNT(DISCOUNT_CODE),
    CONSTRAINT PK_SEAT_BOOK PRIMARY KEY (seat_book_code)
);

/* 17. 결제 */
CREATE TABLE PAYMENT (
    payment_code VARCHAR2(30) NOT NULL PRIMARY KEY,
    payment_price NUMBER NOT NULL,
    payment_method VARCHAR2(30) NOT NULL,
    payment_time DATE NOT NULL,
    payment_state VARCHAR2(30) NOT NULL,
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_PAYMENT_BOOK_NUM REFERENCES BOOK(BOOK_NUM)
);

/* 18. 리뷰 */
CREATE TABLE REVIEW (
    review_num VARCHAR2(30) NOT NULL,
    review_content VARCHAR2(3000) NOT NULL,
    review_score NUMBER NOT NULL,
    review_date DATE NOT NULL,
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_REVIEW_BOOK_NUM REFERENCES BOOK(BOOK_NUM),
    users_id VARCHAR2(100) NOT NULL CONSTRAINT FK_REVIEW_USERS_ID REFERENCES USERS(USERS_ID)
);

/* 19. 트레일러 */
CREATE TABLE TRAILER (
    trailer_code VARCHAR2(20) NOT NULL PRIMARY KEY,
    url_path VARCHAR2(300) NOT NULL,
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_TRAILER_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 20. 이미지 */
CREATE TABLE MOVIE_IMAGE (
    img_code VARCHAR2(20) NOT NULL PRIMARY KEY,
    img_path VARCHAR2(300) NOT NULL,
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_IMAGE_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)
);

/* 21. 공지사항 */
CREATE TABLE ANNOUNCE (
    announce_num NUMBER NOT NULL PRIMARY KEY,
    announce_name VARCHAR2(1000) NOT NULL,
    announce_content VARCHAR2(3000) NOT NULL,
    announce_views NUMBER NOT NULL,
    announce_date DATE NOT NULL,
    ADMIN_id VARCHAR2(100) NOT NULL CONSTRAINT FK_ANNOUNCE_ADMIN_ID REFERENCES ADMIN(ADMIN_ID)
);

/* ============================================== */
/* 데이터 삽입 (INSERT)              */
/* ============================================== */

/* 1. 유저 */
INSERT INTO USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
VALUES('test1', '1234', 'test@naver.com', '이정우', '2000-10-13','남자', 'default.jpg', SYSDATE, '2025-11-18', '비활성','010-1111-1111');

INSERT INTO USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
VALUES('test2', 'q1w2e3', 'qq@naver.com', '테스트', '1999-05-23','여자', 'default.jpg', SYSDATE, '2025-10-18', '활성','010-4554-1111');

INSERT INTO USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
VALUES('test3', '1', 'user@naver.com', '유저', '1991-10-13','남자', 'default.jpg', SYSDATE, '2023-11-18', '활성', '010-1234-2231');

/* 2. 관리자 */
INSERT INTO ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) VALUES('admin','1234',SYSDATE);
INSERT INTO ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) VALUES('admin2','admin',SYSDATE);
INSERT INTO ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) VALUES('ad','1',SYSDATE);

/* 3. 할인 (dc1 -> dc001) */
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc001','조조','0.5','청소년');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc002','조조','0.6','성인');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc003','조조','0.4','경로');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc004','일반','0.7','청소년');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc005','일반','1','성인');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc006','일반','0.6','경로');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc007','심야','0.6','청소년');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc008','심야','0.7','성인');
INSERT INTO DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) VALUES('dc009','심야','0.5','경로');

/* 4. 감독 (dt1 -> dt001) */
INSERT INTO DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) VALUES('dt001','봉준호');
INSERT INTO DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) VALUES('dt002','헐리우드');
INSERT INTO DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) VALUES('dt003','박찬혹');

/* 5. 배우 (at1 -> at001) */
INSERT INTO ACTOR(ACTOR_CODE, ACTOR_NAME) VALUES('at001','송강호');
INSERT INTO ACTOR(ACTOR_CODE, ACTOR_NAME) VALUES('at002','나미라');
INSERT INTO ACTOR(ACTOR_CODE, ACTOR_NAME) VALUES('at003','덕화');

/* 6. 영화관 정보 (cn1 -> cn001) */
INSERT INTO CINEMA_INFO(CINEMA_NUM, CINEMA_NAME, CINEMA_LOCATION) VALUES ('cn001','쌍용시네마','H타워');

/* 7. 영화 (mc001 유지) */
INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc001','극장판 체인소맨 : 폭탄편','액션','120','15세 이용가', '2025-10-20',
'압도적 배틀 액션이 스크린에서 폭발한다!  데블 헌터로 일하는 소년 ''덴지''는 조직의 배신으로 죽음에 내몰린 순간 전기톱 악마견 ''포치타''와의 계약으로 하나로 합쳐져  누구도 막을 수 없는 존재 ''체인소 맨''으로 다시 태어난다.  악마와 사냥꾼, 그리고 정체불명의 적들이 얽힌 잔혹한 전쟁 속에서  ''레제''라는 이름의 미스터리한 소녀가 ''덴지'' 앞에 나타나는데…  ''덴지''는 사랑이라는 감정에 이끌려 지금껏 가장 위험한 배틀에 몸을 던진다! ',
'mc001_poster.jpg','mc001_bg.jpg','15000','3000000','F','상영중');

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc002','더 퍼스트 슬램덩크','스포츠','124','전체 이용가', '2025-01-04',
'전국 제패를 꿈꾸는 북산고 농구부 5인방의 이야기를 그린 작품. 이번 극장판은 ''송태섭''을 중심으로 그의 과거와 현재가 교차되며 펼쳐지는 박진감 넘치는 경기를 담아냈다. 구판 애니메이션에서 미처 다루지 못한, 많은 팬들이 그토록 원했던 원작 최종 보스 산왕공고(산노)와의 인터하이 32강전을 영상화한 작품으로, 큰 틀에선 원작과 같으면서도 세부적으론 다른 연출과 스토리텔링을 사용한 게 돋보인다. ',
'mc002_poster.jpg','mc002_bg.jpg','12000','4800000','F','상영중');

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc003','엘리멘탈','애니메이션','109','전체 이용가', '2025-06-14',
'불, 물, 흙, 공기 4개의 원소들이 살고 있는 ''엘리멘트 시티''. 재치 있고 불 같은 성격의 ''앰버''는 낯설고 새로운 세상에서 우연히 유쾌하고 감성적이며 물 흐르듯 사는 ''웨이드''를 만나 특별한 우정을 쌓아간다. 한 불 원소 부부가 돛단배를 타고 안개에 뒤덮인 바다를 가르며 어딘가로 향하는 모습을 비추면서 영화가 시작된다. 그렇게 도착한 곳은 여러 원소들이 함께 어울려 사는 도시인 엘리멘트 시티. 짐을 챙기고 배에서 내린 부부는 입국을 위해 검문소로 향한다.',
'mc003_poster.jpg','mc003_bg.jpg','8000','7200000','F','상영중');

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc004','엣지 오브 투모로우','액션/SF','113','12세 이용가', '2025-12-20',
'외계 종족 ''미믹''의 침공으로 멸망 위기에 놓인 지구. 훈련 한번 받지않은 소심한 공보관 빌 케이지 소령(톰 크루즈)은 전투에 투입되자마자 외계인의 피를 뒤집어쓰고 사망한다. 그런데 눈을 뜨니 자신이 과거로 돌아와 같은 날을 반복하고 있다. 그는 반복되는 시간 속에서 전설적인 전사 리타 브라타스키(에밀리 블런트)를 만나 외계 종족을 이길 방법을 찾기 위해 끝없이 싸우고, 죽고, 다시 태어나는 지옥 같은 운명을 겪는다. 이 타임 루프를 멈추고 전쟁을 끝낼 수 있을까?',
'mc004_poster.jpg','mc004_bg.jpg','5000','4699307','F','상영중');


INSERT ALL
-- 오펜하이머 (mc005) (따옴표 수정 완료)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc005','오펜하이머','드라마/역사','180','15세 이용가', '2023-08-15',
'1940년대, 제2차 세계대전이 한창이던 시기. 천재 물리학자 J. 로버트 오펜하이머는 미 육군의 레슬리 그로브스 장군에게 발탁되어 극비리에 진행되는 ''맨해튼 프로젝트''의 총 책임자로 임명된다. 그는 인류의 미래를 건 핵무기 개발이라는 막중한 임무를 수행하며, 과학적 성취와 도덕적 딜레마 사이에서 고뇌한다. 그의 연구는 세상을 영원히 바꿀 결과를 초래하게 되고, 오펜하이머는 자신이 만든 창조물의 무게를 감당해야만 한다. 이 영화는 한 천재 과학자의 빛과 그림자를 심도 있게 조명하며, 원자 폭탄 개발 과정과 그 이후의 격변을 드라마틱하게 그려낸다.',
'mc005_poster.jpg','mc005_bg.jpg','6000','3200000','F','상영중')

-- 스즈메의 문단속 (mc006)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc006','스즈메의 문단속','애니메이션/판타지','121','12세 이용가', '2023-03-08',
'규슈의 한적한 마을에 사는 17세 소녀 스즈메는 ''문을 찾는다''는 이상한 청년 소타를 만난다. 호기심에 그를 쫓아 산속 폐허에서 낡은 문을 발견하고, 문을 열자 재난을 부르는 ''미미즈''가 나타난다. 소타는 재난을 막기 위해 전국을 떠돌며 문을 ''닫는'' 사명을 지닌 ''토지시''였고, 실수로 그를 어린 의자로 변하게 만든 스즈메는 자신의 잘못을 되돌리고 미미즈로 인해 발생할 수 있는 재난을 막기 위해 소타와 함께 일본 전역의 폐허에 나타나는 재난의 문을 닫기 위한 여정을 시작한다. 두 사람은 이 특별하고 신비한 여행을 통해 성장과 인연의 의미를 깨닫게 된다.',
'mc006_poster.jpg','mc006_bg.jpg','4500','5540000','F','상영중')

-- 아바타 물의 길 (mc007)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc007','아바타 물의 길','SF/액션/어드벤처','192','12세 이용가', '2022-12-14',
'제이크 설리와 네이티리가 가족을 이루고 평화로운 삶을 이어가던 판도라. 하지만 지구인들의 재침공으로 다시금 평화가 깨지고, 제이크는 가족을 지키기 위해 낯선 바다로 피신한다. 그곳에서 그는 신비로운 물의 부족 ''멧케이나''족과 조우하며 바다에서 살아가는 법과 그들의 문화를 배운다. 그러나 인간들의 위협은 계속되고, 제이크 가족은 낯선 환경과 새로운 삶의 방식에 적응하면서도 사랑하는 사람들을 지키기 위한 필사적인 사투를 벌이게 된다. 아름답고 광활한 수중 세계를 배경으로 펼쳐지는 이들의 서사는 가족의 의미와 자연과의 조화를 다시 한번 생각하게 한다.',
'mc007_poster.jpg','mc007_bg.jpg','3000','10800000','F','상영중')

-- 가디언즈 오브 갤럭시3 (mc008)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc008','가디언즈 오브 갤럭시3','액션/어드벤처/SF','150','12세 이용가', '2023-05-03',
'사랑하는 이를 잃은 슬픔에 빠진 스타로드(피터 퀼)와 가디언즈 멤버들은 더 이상 평화로운 은둔 생활을 이어가지 못한다. 팀의 과거와 깊이 얽힌 새로운 위협이 등장하며, 로켓의 목숨이 걸린 중대한 임무를 수행해야 하는 상황에 놓인다. 로켓의 잔혹한 탄생 배경과 숨겨진 과거가 드러나면서, 가디언즈는 그를 구하기 위한 절박하고 위험한 여정에 뛰어든다. 이번 미션에 실패하면 가디언즈의 존재 자체가 위태로워질 수 있기에, 멤버들은 모든 것을 걸고 헌신한다. 유쾌함 속에 숨겨진 진한 우정과 감동이 우주를 배경으로 펼쳐진다.',
'mc008_poster.jpg','mc008_bg.jpg','5500','4200000','F','상영중')

-- 탑건 매버릭 (mc009)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc009','탑건 매버릭','액션/드라마','130','15세 이용가', '2022-06-22',
'최고의 파일럿이자 전설적인 인물 매버릭(피트 미첼)은 30년이 넘는 세월 동안 해군에서 복무하며 파일럿의 길을 고수한다. 어느 날, 그는 해군 파일럿 엘리트들의 교육을 담당하는 ''탑건'' 스쿨의 교관으로 복귀하게 된다. 그곳에서 매버릭은 과거 자신의 파트너 ''구스''의 아들인 ''루스터''를 비롯한 젊은 정예 요원들을 만나게 된다. 매버릭은 목숨을 건 위험천만한 임무를 위해 그들을 훈련시키면서, 과거의 그림자와 마주하게 되고 자신의 깊은 내면과도 싸워야 한다. 한계를 뛰어넘는 비행 액션과 함께 뜨거운 감동이 스크린을 가득 채운다.',
'mc009_poster.jpg','mc009_bg.jpg','7000','8190000','F','상영중')

-- 기생충 (mc010) (따옴표 수정 완료)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc010','기생충','드라마','131','15세 이용가', '2019-05-30',
'전원 백수인 기택 가족은 반지하에 살며 힘든 생활을 이어간다. 그러던 중, 장남 기우가 고액 과외 면접을 위해 IT 기업 CEO인 박 사장의 대저택을 찾아가게 되면서 두 가족의 삶이 걷잡을 수 없는 방향으로 얽히기 시작한다. 기택 가족은 부유한 박 사장 가족에게 한 명씩 완벽하게 ''취업''하는 기상천외한 계획을 세우고, 곧 그들의 삶은 예상치 못한 방향으로 흘러간다. 이 영화는 두 극과 극의 가족을 통해 현대 사회의 빈부 격차와 계층 간의 문제를 날카롭게 풍자하며, 예측 불가능한 전개와 서스펜스로 관객을 사로잡는다. 칸 영화제 황금종려상 수상작.',
'mc010_poster.jpg','mc010_bg.jpg','2000','10310375','T','상영종료')
SELECT * FROM dual;


INSERT ALL
-- 노량: 죽음의 바다 (mc011)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc011','노량: 죽음의 바다','액션/전쟁/드라마','153','12세 이용가', '2023-12-20',
'1598년 12월, 임진왜란 발발 후 7년이 지난 시점. 왜군의 수장 히데요시가 사망하자 왜군들은 본국으로 서둘러 퇴각하려 한다. 이순신 장군은 조선의 안위를 위해 왜군을 완벽하게 섬멸하는 것이 사명이라 판단하고, 마지막 전투를 준비한다. 그는 명나라 수군 도독 진린과 연합해 노량 해협에 매복하고, 사력을 다해 도주하는 왜군과 처절한 해상 전투를 벌인다. 이순신 장군이 바다에서 펼치는 마지막 전투와 그의 희생을 다룬 감동적인 서사이다. 조선, 명, 왜 세 진영이 얽힌 노량의 밤바다는 필사의 사투와 죽음으로 가득 찬다.',
'mc011_poster.jpg','mc011_bg.jpg','4000','7230000','F','상영중')

-- 서울의 봄 (mc012)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc012','서울의 봄','드라마/역사','141','12세 이용가', '2023-11-22',
'1979년 12월 12일, 수도 서울이 총성으로 뒤덮인 날. 대한민국 현대사의 격동적인 순간을 다룬 이 영화는 전두환을 중심으로 한 신군부 세력이 권력을 장악하기 위해 일으킨 군사 반란을 긴박하게 그린다. 불의에 맞서 나라를 지키려는 수도경비사령관 이태신과 그를 막으려는 육군 내 진압 세력 간의 9시간에 걸친 숨 막히는 사투가 펼쳐진다. 하루 아침에 뒤집힌 대한민국의 운명, 그리고 그 중심에 있던 인물들의 첨예한 갈등과 선택을 통해 역사의 무게와 정의의 의미를 되새긴다. 1000만 관객을 돌파한 화제작으로, 그날의 긴장감을 생생하게 전달한다.',
'mc012_poster.jpg','mc012_bg.jpg','8500','13120000','F','상영중')

-- 인사이드 아웃 2 (mc013) (엘리멘탈 대체)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc013','인사이드 아웃 2','애니메이션/코미디','96','전체 관람가', '2024-06-12',
'사춘기에 접어든 라일리의 머릿속 ''감정 컨트롤 본부''에 갑자기 비상이 걸린다. 기존의 감정들인 ''기쁨'', ''슬픔'', ''버럭'', ''까칠'', ''소심''은 라일리의 복잡해진 마음을 이해하기 위해 노력하지만, 본부에 새로운 감정들이 등장하며 모든 것이 뒤섞인다. ''불안'', ''당황'', ''따분'', ''부럽'' 같은 새로운 감정들은 라일리가 겪는 청소년기의 복잡다단한 변화를 주도하며 통제권을 차지하려 한다. 이 영화는 라일리의 성장과 함께 우리의 머릿속 감정 세계가 얼마나 다채롭고 때로는 혼란스러운지 유쾌하면서도 깊이 있게 탐구한다. 새로운 감정들과의 좌충우돌 스토리가 펼쳐진다.',
'mc013_poster.jpg','mc013_bg.jpg','7500','10000000','F','상영중')

-- 범죄도시3 (mc014)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc014','범죄도시3','액션/범죄','105','15세 이용가', '2023-05-31',
'대체 불가 괴물 형사 마석도(마동석)가 서울 광역수사대로 이동 후, 마약 사건의 배후를 추적하던 중 새로운 빌런 주성철과 일본 야쿠자 리키를 맞닥뜨린다. 마석도는 국경과 조직을 넘나드는 글로벌 범죄 조직의 실체에 접근하게 되고, 비열하고 잔인한 두 악당을 일망타진하기 위해 강력한 주먹을 휘두른다. 특유의 시원한 액션과 유머가 결합된 마석도의 통쾌한 활약은 여전하며, 이번에는 두 명의 강력한 빌런과의 대결을 통해 더욱 커진 스케일과 액션 쾌감을 선사한다. 나쁜 놈들은 끝까지 잡는 그의 무자비한 수사가 다시 시작된다.',
'mc014_poster.jpg','mc014_bg.jpg','1500','10680000','T','상영종료')

-- 한산: 용의 출현 (mc015)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc015','한산: 용의 출현','액션/전쟁','129','12세 이용가', '2022-07-27',
'1592년 7월, 임진왜란 발발 후 조선은 절체절명의 위기에 놓인다. 연전연패의 상황 속에서 이순신 장군은 압도적인 전력의 왜군을 맞아 한산도 앞바다에서 학익진 전술을 펼친다. 그는 불리한 상황을 극복하고, 조선의 운명을 바꿀 대규모 해전을 준비하며 깊은 고뇌에 빠진다. 장군의 뛰어난 지략과 조선 수군의 용맹함이 절묘하게 어우러진 이 전투는 전쟁의 판세를 뒤집는 결정적 계기가 된다. 이 영화는 명량해전 5년 전, 왜군을 격파하며 조선을 구한 한산도 대첩의 과정을 웅장하고 박진감 넘치게 재현한다.',
'mc015_poster.jpg','mc015_bg.jpg','2800','7260000','T','상영종료')

-- 밀수 (mc016)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc016','밀수','범죄/액션/드라마','129','15세 이용가', '2023-07-26',
'1970년대, 평화롭던 작은 바닷가 마을 군천. 해녀들은 생계를 위해 밀수판에 가담하게 되고, 전국구 밀수왕 권 상사의 지시 아래 위험한 일에 뛰어든다. 그러나 의도치 않은 사건으로 인해 두 여성 춘자와 진숙의 관계는 틀어지게 되고, 마을은 밀수 범죄로 인해 생존의 위협에 직면한다. 깊은 바닷속을 무대로 펼쳐지는 짜릿한 밀수 작전과 그 속에서 피어나는 인물들의 갈등, 그리고 그들이 엮어내는 화려한 범죄 스토리가 흥미진진하게 그려진다. 시원한 바다를 배경으로 펼쳐지는 통쾌한 해양 액션 범죄 활극이다.',
'mc016_poster.jpg','mc016_bg.jpg','3200','5140000','T','상영종료')

-- 콘크리트 유토피아 (mc017)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc017','콘크리트 유토피아','드라마/스릴러','130','15세 이용가', '2023-08-09',
'대지진으로 인해 서울이 하루 아침에 폐허로 변한 뒤, 유일하게 무너지지 않고 살아남은 ''황궁 아파트''. 외부 생존자들이 몰려들면서 아파트는 위기를 맞고, 주민들은 생존을 위해 외부인을 배척하고 내부 질서를 구축하기 시작한다. 주민 대표 ''영탁''을 중심으로 그들만의 규칙을 만들고 극한의 생존을 이어가는 과정에서, 인간의 이기심과 도덕성이 시험대에 오른다. 생존이 걸린 상황 속에서 펼쳐지는 주민들의 광기와 선택은 과연 무엇이 옳은 ''유토피아''인지를 묻는다. 재난 상황 속에서 인간 본성을 깊이 파고드는 블랙 코미디 스릴러이다.',
'mc017_poster.jpg','mc017_bg.jpg','1800','3850000','T','상영종료')

-- 듄 (Dune) (mc018)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc018','듄 (Dune)','SF/어드벤처/드라마','155','12세 이용가', '2021-10-20',
'미래 우주의 가장 중요한 자원인 ''스파이스''를 생산하는 사막 행성 ''아라키스''를 둘러싼 가문들의 암투와 전쟁. 아트레이데스 가문의 후계자인 폴은 황제의 명령으로 위험한 행성 ''아라키스''로 이주한다. 그곳에서 그는 모래 벌레를 피해 살아가야 하는 위험과 함께, 자신의 특별한 능력과 운명을 깨닫게 된다. 가문의 멸망과 새로운 세상의 질서를 위해 고군분투하는 폴의 여정은 광활하고 신비로운 사막의 풍경 속에서 펼쳐진다. 우주의 운명을 짊어진 소년의 성장과 복수를 그린 장대한 서사극이다.',
'mc018_poster.jpg','mc018_bg.jpg','1000','1640000','T','상영종료')

-- 인터스텔라 (mc019)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc019','인터스텔라','SF/모험/드라마','169','12세 이용가', '2014-11-06',
'황폐해진 지구, 인류의 멸망이 예고된 상황에서 인류를 구할 마지막 희망을 찾아 나선 탐험대. 전직 파일럿이었던 ''쿠퍼''는 시공간을 초월할 수 있는 ''웜홀''을 발견하고, 인류의 새로운 보금자리를 찾기 위해 우주로 향한다. 그는 사랑하는 딸과 아들을 뒤로하고 미지의 우주 공간에서 시간과 중력의 법칙을 거스르는 위험천만한 임무를 수행한다. 이 영화는 우주의 광활함과 신비로움을 압도적인 스케일로 보여주며, 인류의 생존이라는 거대한 주제와 아버지의 희생이라는 개인적인 감동을 동시에 전달하는 걸작이다.',
'mc019_poster.jpg','mc019_bg.jpg','900','10320000','T','상영종료')

-- 명탐정 코난: 흑철의 어영 (mc020)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc020','명탐정 코난: 흑철의 어영','애니메이션/미스터리','109','12세 이용가', '2023-07-20',
'인터폴의 해양 시설 ''퍼시픽 부이''에서 세계 각국의 CCTV 영상을 연결하는 핵심 기술이 개발된다. 코난과 친구들은 이 시설에서 고래 관찰을 하던 중, 검은 조직이 시설에 침투해 한 엔지니어를 납치하는 사건을 목격한다. 게다가 검은 조직의 멤버 ''베르무트''에게 하이바라 아이의 정체가 발각될 위기에 처한다. 코난은 하이바라를 구하고 검은 조직의 음모를 막기 위해 필사의 추리를 시작한다. 바다 위 거대 시설을 배경으로 펼쳐지는 코난의 흥미진진한 추리와 검은 조직과의 정면 대결이 팬들을 사로잡는 극장판이다.',
'mc020_poster.jpg','mc020_bg.jpg','1200','4860000','T','상영종료')

-- 파묘 (mc021)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc021','파묘','오컬트/미스터리','134','15세 이용가', '2024-02-22',
'거액의 의뢰를 받은 무당 ''화림''과 장의사 ''영근''은 미국에서 기이한 병에 시달리는 재벌가의 장손을 만난다. 조상 묏자리가 화근임을 직감한 화림은 최고의 풍수사 ''상덕''과 합류해 문제의 묘를 파헤치기로 한다. 인적 없는 산골 깊은 곳에 자리한 음산한 묘를 발견하고, 그들은 묘를 파헤치는 순간 불길한 기운을 느낀다. 결국, 파묘를 진행한 이들에게 멈출 수 없는 기이한 사건들이 연달아 발생하며 목숨을 위협한다. 이 영화는 한국적인 오컬트와 미스터리를 결합하여 관객에게 강렬하고 긴장감 넘치는 경험을 선사한다.',
'mc021_poster.jpg','mc021_bg.jpg','9500','12000000','F','상영중')

-- 아쿠아맨과 로스트 킹덤 (mc022)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc022','아쿠아맨과 로스트 킹덤','액션/판타지/어드벤처','124','12세 이용가', '2023-12-20',
'아틀란티스의 왕이 된 아쿠아맨(아서) 앞에 숙적 ''블랙 만타''가 더욱 강력해진 힘을 가지고 나타난다. 블랙 만타는 고대의 저주받은 무기 ''블랙 트라이던트''를 손에 넣어 아틀란티스와 지상 세계 모두를 위협한다. 아쿠아맨은 이 위험에 맞서기 위해 감옥에 갇혀 있던 이복 동생 ''옴''에게 도움을 청하고, 두 형제는 과거의 갈등을 넘어 새로운 동맹을 맺는다. 아서와 옴은 미지의 ''로스트 킹덤''을 찾아 나서며 세상을 구하기 위한 마지막 여정을 시작한다. 화려한 수중 액션과 광활한 미지의 세계가 펼쳐지는 DC 히어로물이다.',
'mc022_poster.jpg','mc022_bg.jpg','2000','980000','T','상영종료')

-- 스파이더맨: 어크로스 더 유니버스 (mc023)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc023','스파이더맨: 어크로스 더 유니버스','애니메이션/액션','140','12세 이용가', '2023-06-21',
'평범한 10대 소년에서 뉴욕의 스파이더맨으로 성장한 ''마일스 모랄레스''. 그는 멀티버스 속에서 만난 또 다른 스파이더맨 ''그웬 스테이시''와 재회하고, 모든 차원의 스파이더맨들을 관리하는 ''스파이더 소사이어티''에 합류한다. 하지만 스파이더 소사이어티의 리더인 ''미겔 오하라''와 마일스는 세상을 구하는 방식에 대한 근본적인 충돌을 겪게 된다. 마일스는 자신이 믿는 정의를 위해 수많은 스파이더맨과 맞서 싸우는 위험한 선택을 한다. 혁신적인 애니메이션 스타일과 상상을 초월하는 멀티버스의 모험이 펼쳐진다.',
'mc023_poster.jpg','mc023_bg.jpg','3500','4400000','T','상영종료')

-- 외계+인 2부 (mc024)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc024','외계+인 2부','SF/액션/판타지','122','12세 이용가', '2024-01-10',
'치열한 신검 쟁탈전 끝에 과거에 갇혀 버린 ''이안''. 시간의 문을 열 수 있는 ''천둥''을 다시 찾아 현재로 돌아가려 한다. 한편, 현재에서는 모든 비밀을 알고 있는 ''가드''와 ''무륵'', 그리고 신검을 되찾으려는 ''두 신선''이 이안을 돕기 위해 움직인다. 외계인들의 탈옥 계획이 현실화되면서 모두가 위험에 빠지고, 시간의 문이 열리기까지 남은 시간은 단 48분. 이들은 과거와 현재를 넘나들며 외계인과 맞서 인류를 구해야 하는 마지막 싸움을 시작한다. 시간 여행과 도술, 외계인이 혼합된 독특한 세계관의 결말이 펼쳐진다.',
'mc024_poster.jpg','mc024_bg.jpg','1500','1500000','T','상영종료')

-- 위시 (mc025)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc025','위시','애니메이션/뮤지컬','92','전체 관람가', '2024-01-03',
'소원이 이루어지는 왕국 ''로사스''에 살고 있는 총명한 소녀 ''아샤''. 로사스의 왕 ''매그니피코''는 주민들의 가장 소중한 소원을 모아 간직하고 있지만, 그 소원을 돌려주지 않고 스스로의 힘을 유지한다. 아샤는 왕의 비밀을 알게 된 후, 모두의 소원을 돌려주기 위해 밤하늘에 간절히 소원을 빈다. 그 순간, 하늘에서 특별한 힘을 가진 별 ''스타''가 떨어진다. 아샤는 스타와 함께 왕국의 주민들을 일깨우고, 소원의 진정한 의미를 찾아가는 모험을 시작한다. 디즈니 100주년을 기념하는 특별한 뮤지컬 애니메이션이다.',
'mc025_poster.jpg','mc025_bg.jpg','800','1350000','T','상영종료')

-- 혹성탈출: 새로운 시대 (mc026)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc026','혹성탈출: 새로운 시대','SF/액션/어드벤처','145','12세 이용가', '2024-05-08',
'''시저''의 시대 이후 수백 년이 지난 미래. 지배권을 차지한 유인원 문명은 번성했지만, 인간들은 야생화되어 숨어 지낸다. 한 유인원 부족의 지도자는 시저의 가르침을 왜곡하여 자신의 제국을 건설하려 하고, 이는 다른 유인원 부족과 인간들에게까지 위협이 된다. 한 젊은 유인원 ''노아''는 이 독재자의 손아귀에서 벗어나기 위해 위험한 여정을 시작하며, 인간 소녀 ''메이''와 동행하게 된다. 노아는 시저의 진정한 유산을 재발견하고 유인원과 인간의 미래를 결정할 중대한 선택에 직면한다.',
'mc026_poster.jpg','mc026_bg.jpg','4500','2500000','F','상영중')

-- 베테랑 2 (mc027)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc027','베테랑 2','액션/범죄','120','15세 이용가', '2024-09-00',
'서도철 형사(황정민)가 이끄는 강력반에 막내 형사 ''박선우''가 합류하면서 팀워크가 새롭게 다져진다. 그들은 연쇄 살인 사건을 수사하던 중, 경찰 내부를 뒤흔드는 예상치 못한 배후를 발견하게 된다. 서도철은 이 사건이 단순한 범죄가 아님을 직감하고, 집요하고 끈질긴 방식으로 범인의 정체에 접근한다. 그러나 범인은 이전보다 훨씬 영리하고 조직적이며, 경찰 조직 전체를 조롱하듯 수사를 방해한다. 서도철은 자신의 모든 것을 걸고 이 거대한 악에 맞서 다시 한번 통쾌한 정의를 실현하기 위해 나선다.',
'mc027_poster.jpg','mc027_bg.jpg','5000','6500000','F','상영중')

-- 데드풀과 울버린 (mc028)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc028','데드풀과 울버린','액션/코미디/SF','127','청소년 관람불가', '2024-07-24',
'평화로운 일상을 보내던 데드풀(웨이드 윌슨)에게 ''시간 변동 관리국(TVA)''이 찾아와 우주를 구원할 막중한 임무를 제안한다. 하지만 이 임무를 위해서는 절대적으로 함께할 파트너가 필요하다. 웨이드는 숙적이었던 ''울버린(로건)''을 찾아 나서고, 강제로 그와 팀을 이루게 된다. 서로 성격도, 스타일도 극과 극인 두 히어로는 멀티버스를 넘나들며 역대급 위기에 맞서 싸우지만, 시종일관 충돌하며 예측 불가능한 코믹 액션을 선보인다. MCU에 공식 합류한 데드풀의 화려한 복귀작이자, 팬들이 염원했던 두 캐릭터의 유쾌한 협업이다.',
'mc028_poster.jpg','mc028_bg.jpg','6000','4000000','F','상영중')

-- 노매드랜드 (mc029)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc029','노매드랜드','드라마','108','12세 이용가', '2021-04-23',
'경제 불황으로 인해 모든 것을 잃은 ''펀''은 도시를 떠나 밴에서 생활하며 비정규직 노동을 하는 ''노매드''의 삶을 선택한다. 그녀는 광활한 미국 서부를 떠돌아다니며, 자신과 비슷한 처지에 놓인 다른 노매드들을 만나 공동체를 이루고 지혜를 나눈다. 펀의 여정은 단순히 경제적 어려움을 극복하는 것을 넘어, 현대 사회에서 소외된 이들이 느끼는 자유와 고독, 그리고 삶의 의미를 탐색하는 과정이다. 아름다운 자연 경관을 배경으로, 물질주의를 벗어난 삶의 방식과 인간적인 연결의 소중함을 담담하게 그려낸다.',
'mc029_poster.jpg','mc029_bg.jpg','100','230000','T','상영종료')

-- 테넷 (Tenet) (mc030)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc030','테넷 (Tenet)','액션/SF/스릴러','150','12세 이용가', '2020-08-26',
'세계적인 거대한 위협에 맞서기 위해 투입된 요원 ''주인공''. 그는 미래에서 온 공격에 대비해야 하는 임무를 부여받는다. 이 위협은 ''인버전''이라는 기술을 통해 시간의 흐름을 역행시키는 무기를 사용하는 방식으로 작동한다. 주인공은 이 새로운 개념을 이해하고 마스터하기 위해 노력하며, 시간을 거슬러 움직이는 적과의 싸움을 시작한다. 그는 러시아의 사업가 ''사토르''를 중심으로 얽힌 거대한 음모의 실체를 파헤친다. 시간을 순행하는 인물과 역행하는 인물이 동시에 충돌하는 복잡하고 흥미진진한 첩보 액션 영화이다.',
'mc030_poster.jpg','mc030_bg.jpg','600','1990000','T','상영종료')

-- 라라랜드 (mc031)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc031','라라랜드','뮤지컬/멜로/드라마','127','12세 이용가', '2016-12-07',
'꿈을 꾸는 사람들의 도시 ''LA''에서 재즈 피아니스트 ''세바스찬''과 배우 지망생 ''미아''가 만나 사랑에 빠진다. 성공이라는 꿈과 현실의 벽 사이에서 갈등하던 두 사람은 서로의 꿈을 응원하며 열렬히 사랑한다. 하지만 각자의 꿈을 향해 나아가면서 그들의 관계는 시험에 들게 되고, 선택의 기로에 놓인다. 이 영화는 화려하고 아름다운 뮤지컬 시퀀스를 통해 꿈을 향한 열정, 사랑의 희생, 그리고 청춘의 아름답고도 아련한 순간들을 담아낸다. 꿈과 현실, 사랑과 성공 사이의 균형을 찾는 모든 이들에게 바치는 로맨스 드라마이다.',
'mc031_poster.jpg','mc031_bg.jpg','500','3740000','T','상영종료')

-- 닥터 스트레인지: 대혼돈의 멀티버스 (mc032)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc032','닥터 스트레인지: 대혼돈의 멀티버스','SF/판타지/액션','126','12세 이용가', '2022-05-04',
'하나의 차원에서 다른 차원으로 이동하는 능력을 가진 십대 ''아메리카 차베즈''를 보호하기 위해 닥터 스트레인지가 나선다. 스트레인지는 멀티버스의 붕괴 위협 속에서 이 소녀의 능력을 노리는 강력한 존재와 마주하게 된다. 그는 옛 동료 ''완다 막시모프(스칼렛 위치)''에게 도움을 요청하지만, 곧 그녀의 어둠을 직면한다. 우주의 운명을 걸고, 스트레인지는 미스터리한 새로운 동맹과 함께 위험천만한 멀티버스 속으로 뛰어든다. 상상조차 할 수 없는 현실들이 교차하며 벌어지는 광란의 시공간 어드벤처가 펼쳐진다.',
'mc032_poster.jpg','mc032_bg.jpg','1500','5880000','T','상영종료')

-- 토이 스토리 4 (mc033)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc033','토이 스토리 4','애니메이션/코미디','100','전체 관람가', '2019-06-20',
'''우디''와 그의 친구들은 새로운 주인인 ''보니''의 손에 들어간 후 평화로운 나날을 보내던 중, 보니가 만든 임시 장난감 ''포키''가 등장하며 큰 혼란이 발생한다. 포키는 자신이 장난감이 아님을 주장하며 탈출을 감행하고, 우디는 포키를 되찾기 위한 여정을 떠난다. 우디는 이 여정에서 오랫동안 헤어졌던 옛 친구 ''보핍''을 우연히 다시 만나게 된다. 보핍은 이제 자유로운 삶을 즐기는 장난감이 되어 있었고, 우디는 자신이 진정으로 원하는 삶이 무엇인지 깊이 고민하게 된다. 장난감들의 존재 이유와 새로운 모험을 그린 감동적인 이야기이다.',
'mc033_poster.jpg','mc033_bg.jpg','700','3400000','T','상영종료')

-- 킹스맨: 골든 서클 (mc034)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc034','킹스맨: 골든 서클','액션/코미디','141','청소년 관람불가', '2017-09-27',
'국제적인 비밀 첩보 조직 ''킹스맨''의 본부가 무자비한 악당 ''포피''의 공격으로 철저히 파괴된다. 유일하게 살아남은 요원 ''에그시''와 ''멀린''은 절망적인 상황 속에서 미국에 본부를 둔 형제 조직 ''스테이츠맨''의 존재를 알게 되고 도움을 요청한다. 이들은 킹스맨의 스타일과는 정반대인 카우보이 스타일의 스테이츠맨 요원들과 협력하여 세계를 위협하는 포피의 ''골든 서클'' 조직을 무너뜨려야 한다. 영국과 미국을 넘나드는 두 첩보 조직의 문화적 충돌과 화려하고 독창적인 액션이 펼쳐진다.',
'mc034_poster.jpg','mc034_bg.jpg','1800','4950000','T','상영종료')

-- 조커 (mc035)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc035','조커','드라마/스릴러','123','청소년 관람불가', '2019-10-02',
'고담시의 외로운 코미디언 지망생 ''아서 플렉''. 그는 병든 어머니를 간병하며 살아가지만, 사회로부터 끊임없이 외면당하고 조롱받는다. 사람들에게 웃음을 주려 했던 그의 꿈은 좌절되고, 그는 세상의 무관심과 폭력 속에 점차 무너져 내린다. 결국, 아서는 내면에 숨겨왔던 어둠을 폭발시키며 광기로 물든 ''조커''로 변모한다. 이 영화는 한 개인의 정신적 붕괴와 그 과정이 사회 전체에 미치는 파급 효과를 깊이 있게 탐구한다. DC 코믹스의 상징적인 악당이 탄생하는 비극적인 과정을 현실적으로 그려낸다.',
'mc035_poster.jpg','mc035_bg.jpg','1200','5250000','T','상영종료')

-- 보헤미안 랩소디 (mc036)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc036','보헤미안 랩소디','드라마/뮤지컬','134','12세 이용가', '2018-10-31',
'독특한 음색과 개성을 가진 이민자 출신의 ''파루크 불사라''는 자신의 이름을 ''프레디 머큐리''로 바꾸고 밴드 ''퀸''에 합류한다. 그의 천재적인 음악적 재능과 폭발적인 무대 매너는 퀸을 세계적인 밴드로 이끈다. 하지만 성공의 정점에서 그는 고독과 갈등을 겪으며 방황하기도 한다. 이 영화는 프레디 머큐리의 삶과 퀸의 음악 여정을 감동적으로 담아내며, 특히 1985년 ''라이브 에이드'' 공연 장면은 관객들에게 전율을 선사한다. 편견을 깨고 자신만의 방식으로 세상을 뒤흔든 전설적인 아티스트의 전기 영화이다.',
'mc036_poster.jpg','mc036_bg.jpg','300','9940000','T','상영종료')

-- 어벤져스: 엔드게임 (mc037)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc037','어벤져스: 엔드게임','액션/SF/드라마','181','12세 이용가', '2019-04-24',
'인피니티 워에서 ''타노스''의 손가락 튕기기로 인해 전 우주 생명체의 절반이 사라진 지 5년 후. 살아남은 어벤져스 멤버들은 깊은 슬픔과 상실감 속에 절망적인 시간을 보낸다. 하지만 ''앤트맨''의 예상치 못한 등장으로 희망의 실마리를 찾게 되고, 마지막 남은 힘과 지혜를 모아 ''시간 여행''이라는 불가능한 계획을 시도한다. 그들은 사라진 동료들을 되찾고 타노스를 물리쳐 세상을 되돌리기 위한 최후의 전쟁에 모든 것을 건다. MCU의 10년 역사를 마무리 짓는 장대한 클라이맥스이자, 전 세계 팬들에게 잊지 못할 감동을 선사한 걸작이다.',
'mc037_poster.jpg','mc037_bg.jpg','500','13970000','T','상영종료')

-- 센과 치히로의 행방불명 (mc038)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc038','센과 치히로의 행방불명','애니메이션/판타지','126','전체 관람가', '2002-06-28',
'이사 가던 길, 낯선 터널을 지나 신들의 세계에 발을 들인 10살 소녀 ''치히로''. 그녀의 부모님은 신들의 음식을 탐하다가 돼지로 변해버리고, 치히로는 미지의 세계에 홀로 남겨진다. 치히로는 부모님을 구하고 인간 세계로 돌아가기 위해 마녀 ''유바바''의 온천장에서 ''센''이라는 이름으로 일하게 된다. 그녀는 수수께끼의 소년 ''하쿠''의 도움을 받아 낯선 세상에서 겪는 역경과 시련을 이겨내며 성장해나간다. 미야자키 하야오 감독의 대표작으로, 환상적인 상상력과 깊은 메시지를 담은 명작 애니메이션이다.',
'mc038_poster.jpg','mc038_bg.jpg','200','1000000','T','상영종료')

-- 7번방의 선물 (mc039)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc039','7번방의 선물','코미디/드라마','127','15세 이용가', '2013-01-23',
'6살 지능을 가진 아빠 ''용구''와 7살 딸 ''예승''은 행복한 단칸방 생활을 한다. 하지만 용구는 예기치 않은 사건에 휘말려 누명을 쓰고 교도소 7번방에 수감된다. 흉악범들이 모인 7번방의 방장과 죄수들은 용구가 딸을 끔찍이 사랑한다는 사실을 알고, 용구와 예승을 만나게 해주기 위해 위험한 작전을 모의한다. 교도소라는 극한의 공간에서 피어나는 용구와 예승의 순수한 사랑, 그리고 7번방 동료들의 따뜻한 우정은 관객들에게 웃음과 눈물을 동시에 선사한다. 천만 관객을 동원한 가슴 따뜻한 휴먼 코미디이다.',
'mc039_poster.jpg','mc039_bg.jpg','400','12810000','T','상영종료')

-- 아바타 (Avatar) (mc040)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc040','아바타 (Avatar)','SF/액션/모험','162','12세 이용가', '2009-12-17',
'지구의 에너지가 고갈되자, 인류는 외계 행성 ''판도라''에서 대체 자원 ''언옵타늄''을 채굴하려 한다. 전직 해병대원 ''제이크 설리''는 하반신 마비의 몸으로, 원격 조종되는 ''아바타''를 통해 판도라의 토착 종족인 ''나비족''이 사는 세계로 투입된다. 그는 나비족 여성 ''네이티리''를 만나 그들의 문화와 자연과의 교감을 배우며 점차 임무와 나비족 사이에서 갈등한다. 결국 제이크는 인류의 파괴적인 계획에 맞서 나비족과 함께 싸우기로 결심한다. 혁신적인 3D 기술로 구현된 경이로운 판도라 행성이 관객을 압도한다.',
'mc040_poster.jpg','mc040_bg.jpg','100','10750000','T','상영종료')

-- 극한직업 (mc041)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc041','극한직업','코미디/액션','111','15세 이용가', '2019-01-23',
'해체 위기에 놓인 마약반 5인방(류승룡, 이하늬, 진선규, 이동휘, 공명). 실적 압박에 시달리던 그들은 국제 범죄 조직을 감시하기 위해 잠복 장소로 위장 치킨집을 인수한다. 하지만 어설프게 시작한 치킨 사업이 대박을 터뜨리며, 마약반은 ''수원 왕갈비 통닭'' 맛집으로 뜻밖의 유명세를 얻게 된다. 본업인 수사는 뒷전이 되고 장사만 승승장구하자 형사들은 정체성의 혼란을 겪는다. 치킨 사업으로 번 돈을 수사 자금으로 쓰려던 계획은 점점 꼬여가고, 결국 그들은 위장과 본업 사이에서 좌충우돌하며 마지막 대결을 펼친다.',
'mc041_poster.jpg','mc041_bg.jpg','200','16260000','T','상영종료')

-- 인터스텔라 (재개봉) (mc042)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc042','인터스텔라 (재개봉)','SF/모험/드라마','169','12세 이용가', '2020-04-01',
'2014년에 개봉했던 명작 SF 영화의 재개봉작. 인류의 멸망 위기 속에서 시공간을 초월하는 ''웜홀''을 발견하고, 인류의 새로운 보금자리를 찾기 위해 우주로 떠나는 탐험대의 이야기이다. 전직 파일럿 ''쿠퍼''가 사랑하는 딸을 위해 목숨을 건 여정을 감행하며, 시간과 중력의 법칙을 탐험하는 과정을 그린다. 재개봉을 통해 관객들은 압도적인 스케일과 사운드를 다시 한번 극장에서 경험할 수 있게 되었다. 과학적인 상상력과 부성애가 결합된 이 영화는 여전히 많은 팬들에게 깊은 울림을 선사한다.',
'mc042_poster.jpg','mc042_bg.jpg','80','500000','T','상영종료')

-- 신과함께-죄와 벌 (mc043)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc043','신과함께-죄와 벌','판타지/드라마','139','12세 이용가', '2017-12-20',
'불의의 사고로 사망한 소방관 ''자홍''은 저승의 국선 변호사 ''강림''을 비롯한 세 명의 차사들과 함께 49일 동안 7개의 지옥 관문을 통과해야 하는 재판을 받는다. 살인, 나태, 기만, 불의, 배신, 폭력, 천륜 등 각 지옥에서 자홍은 자신의 삶을 돌아보고 변론을 받는다. 저승의 법에 따라 망자가 환생을 하기 위해서는 이 모든 재판을 통과하고 무죄를 입증해야 한다. 차사들은 망자가 환생할 수 있도록 돕는 동시에, 이승의 현재에 영향을 미치는 비밀스러운 사건에도 개입하며 예측 불가능한 스토리를 전개한다.',
'mc043_poster.jpg','mc043_bg.jpg','350','14410000','T','상영종료')

-- 범죄도시4 (mc044)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc044','범죄도시4','액션/범죄','109','15세 이용가', '2024-04-24',
'마석도 형사(마동석)는 사이버 범죄수사팀과 함께 대규모 온라인 불법 도박 조직을 소탕하는 임무를 맡는다. 이 조직은 필리핀을 거점으로 움직이며 잔혹한 살인과 폭력을 일삼는 빌런 ''백창기''와 IT 천재 ''장동철''에 의해 운영된다. 마석도는 빌런들을 잡기 위해 온라인과 오프라인을 넘나드는 글로벌 공조 수사를 시작한다. 강력한 전투력과 무자비함을 지닌 백창기와의 일대일 대결은 시리즈 사상 가장 위험하고 통쾌한 액션을 선사한다. 마석도의 시원한 핵주먹이 펼치는 새로운 범죄 소탕 작전이 시작된다.',
'mc044_poster.jpg','mc044_bg.jpg','12000','11560000','F','상영중')

-- 겨울왕국 2 (mc045)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc045','겨울왕국 2','애니메이션/판타지/뮤지컬','103','전체 관람가', '2019-11-21',
'평화로운 아렌델 왕국에 어느 날 정체를 알 수 없는 목소리가 들려온다. 엘사는 자신의 신비한 힘의 기원과 그 목소리의 정체를 찾아 언니 ''안나'', 크리스토프, 올라프, 그리고 스벤과 함께 위험천만한 미지의 세계로 모험을 떠난다. 그들은 아렌델 왕국에 내려진 저주의 비밀과 엘사의 과거에 얽힌 진실을 파헤치기 위해 마법의 숲으로 들어선다. 이 모험은 엘사가 자신의 정체성을 온전히 받아들이고, 안나는 왕국의 진정한 지도자로 성장하는 계기가 된다. 아름다운 영상미와 새로운 OST가 가득한 디즈니의 명작 속편이다.',
'mc045_poster.jpg','mc045_bg.jpg','400','13750000','T','상영종료')

-- 웡카 (mc046) (기존 기생충 재개봉 데이터 대체)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc046','웡카','판타지/뮤지컬/어드벤처','116','전체 관람가', '2024-01-31',
'모두가 사랑하는 초콜릿 공장장 ''윌리 웡카''의 젊은 시절 이야기. 세상에서 가장 달콤한 초콜릿을 만들겠다는 꿈을 안고 도시로 온 청년 웡카는 뛰어난 마법과 상상력으로 사람들을 사로잡지만, 이 도시의 초콜릿 카르텔은 웡카의 등장을 질투하며 그를 위험에 빠뜨린다. 웡카는 가난한 환경과 질투하는 경쟁자들 속에서도 굴하지 않고, 자신만의 독창적인 초콜릿 제조법으로 세상을 놀라게 할 계획을 세운다. 전설적인 공장장이 되기까지 겪는 좌절과 모험, 그리고 희망을 유쾌하고 환상적으로 그려낸 프리퀄 뮤지컬 판타지이다.',
'mc046_poster.jpg','mc046_bg.jpg','3800','3530000','F','상영중')

-- 미션 임파서블: 데드 레코닝 PART ONE (mc047)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc047','미션 임파서블: 데드 레코닝 PART ONE','액션/첩보','163','15세 이용가', '2023-07-12',
'IMF 요원 ''에단 헌트''와 그의 팀은 인류 전체를 위협하는 강력하고 새로운 무기를 추적하는 임무를 맡는다. 이 무기가 악당들의 손에 넘어가지 않도록 막아야 하지만, 그들의 앞에는 과거의 그림자와 숙적들이 다시 나타나 에단을 압박한다. 에단은 임무와 개인적인 삶, 그리고 팀원들의 안전 사이에서 선택의 기로에 놓인다. 이 영화는 전 세계를 무대로 펼쳐지는 상상을 초월하는 스케일의 액션과 스턴트를 선보이며, 시리즈 특유의 긴장감 넘치는 첩보 스토리를 담고 있다. 에단의 가장 위험한 미션의 시작이다.',
'mc047_poster.jpg','mc047_bg.jpg','2200','4020000','T','상영종료')

-- 명량 (mc048)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc048','명량','액션/전쟁','128','15세 이용가', '2014-07-30',
'1597년 임진왜란 6년. 파죽지세로 한양을 향해 북상하는 왜군에 맞서 조선 수군은 궤멸 직전에 놓인다. 이순신 장군은 백의종군하여 재등장하지만, 남은 함선은 단 12척뿐. 그는 절망적인 상황 속에서도 "신에게는 아직 12척의 배가 남아있사옵니다"라는 결의로 백성들과 병사들을 독려한다. 장군은 단 12척의 배로 330척에 달하는 왜군 함대를 명량 해협으로 유인하여 대결한다. 압도적인 전력 차를 극복하고 조선을 지킨 세계사적인 해전, ''명량대첩''을 스펙터클하고 드라마틱하게 재현한 천만 관객 영화이다.',
'mc048_poster.jpg','mc048_bg.jpg','100','17610000','T','상영종료')

-- 겨울왕국 (mc049)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc049','겨울왕국','애니메이션/판타지/뮤지컬','108','전체 관람가', '2014-01-16',
'태어날 때부터 모든 것을 얼려버리는 마법의 능력을 가진 언니 ''엘사''. 실수로 자신의 동생 ''안나''에게 상처를 입힌 후, 엘사는 세상과 단절된 채 살아간다. 성인이 되어 여왕이 된 엘사는 대관식 날, 감정을 조절하지 못하고 아렌델 왕국 전체를 영원한 겨울에 빠뜨린 채 홀로 산 속으로 도망친다. 안나는 얼어붙은 왕국을 구하고 언니를 되찾기 위해 산을 오르며 모험을 시작하고, 그 여정에서 순수한 눈사람 ''올라프''와 산사람 ''크리스토프''를 만난다. 진정한 사랑과 자매애를 노래하는 디즈니 애니메이션의 전설적인 흥행작이다.',
'mc049_poster.jpg','mc049_bg.jpg','200','10300000','T','상영종료')

-- 베놈 2: 렛 데어 비 카니지 (mc050)
INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc050','베놈 2: 렛 데어 비 카니지','액션/SF/스릴러','97','15세 이용가', '2021-10-13',
'기자 ''에디 브록''과 외계 생명체 ''베놈''은 티격태격하면서도 아슬아슬한 동거를 이어가고 있다. 에디는 연쇄 살인마 ''클리터스 캐서디''를 인터뷰하게 되고, 이 과정에서 클리터스는 에디의 몸속 베놈의 일부를 흡수하여 또 다른 강력한 심비오트인 ''카니지''를 탄생시킨다. 카니지는 베놈보다 더욱 파괴적이고 잔혹한 존재로, 클리터스의 광기와 결합해 도시를 혼란에 빠뜨린다. 베놈은 세상을 구하기 위해 숙적인 카니지와 목숨을 건 대결을 펼쳐야 한다. 에디와 베놈의 유머러스한 관계와 심비오트 간의 치열한 싸움이 돋보이는 액션 영화이다.',
'mc050_poster.jpg','mc050_bg.jpg','300','2130000','T','상영종료')
SELECT * FROM dual;



/* 8. 예매율 (br1 -> br001) */
INSERT INTO BOOK_RATE(BOOKRATE_CODE, BOOK_RATE, MOVIE_CODE) VALUES('br001', 55.3, 'mc001');
INSERT INTO BOOK_RATE(BOOKRATE_CODE, BOOK_RATE, MOVIE_CODE) VALUES('br002', 30.5, 'mc002');
INSERT INTO BOOK_RATE(BOOKRATE_CODE, BOOK_RATE, MOVIE_CODE) VALUES('br003', 14.2, 'mc003');

/* 9. 사운드 시스템 (tn1 -> tn001) */
INSERT INTO SOUND(SOUND_CODE, SOUND_NAME) VALUES ('tn001','Dolby Digital 7.1');
INSERT INTO SOUND(SOUND_CODE, SOUND_NAME) VALUES ('tn002','DTS Digital Surround');
INSERT INTO SOUND(SOUND_CODE, SOUND_NAME) VALUES ('tn003','Dolby Atmos');

/* 10. 상영관 정보 (tn1 -> tn001, cn1 -> cn001) */
INSERT INTO THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
VALUES ('tn001', 'cinema1', 100, 'T', 'cn001', 'tn001');

INSERT INTO THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
VALUES ('tn002', 'cinema2', 100, 'F', 'cn001', 'tn002');

INSERT INTO THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
VALUES ('tn003', 'cinema3', 100, 'T', 'cn001', 'tn003');

/* 11. 좌석 (st1 -> st001, tn1 -> tn001) */
INSERT INTO SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
VALUES ('st001', 'A', '1', 'T', 'tn001');

INSERT INTO SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
VALUES ('st002', 'A', '2', 'T', 'tn001');

INSERT INTO SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
VALUES ('st003', 'B', '1', 'T', 'tn002');

/* 12. 영화 감독 (dt1 -> dt001) */
INSERT INTO MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) VALUES ('dt001', 'mc001');
INSERT INTO MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) VALUES ('dt002', 'mc002');
INSERT INTO MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) VALUES ('dt003', 'mc003');

/* 13. 출연진 (at1 -> at001) */
INSERT INTO CAST(ACTOR_CODE, MOVIE_CODE) VALUES ('at001','mc001');
INSERT INTO CAST(ACTOR_CODE, MOVIE_CODE) VALUES ('at002','mc002');
INSERT INTO CAST(ACTOR_CODE, MOVIE_CODE) VALUES ('at003','mc003');

/* 14. 상영 정보 (scc1 -> scc001, tn1 -> tn001) */
INSERT INTO SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
VALUES ('scc001', TO_DATE('2025-10-11 11:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 14:30', 'YYYY-MM-DD HH24:MI'), 14000, TO_DATE('2025-10-11', 'YYYY-MM-DD'), 'F', 'Y', 'tn001', 'mc001');

INSERT INTO SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
VALUES ('scc002', TO_DATE('2025-10-11 15:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 17:30', 'YYYY-MM-DD HH24:MI'), 14000, TO_DATE('2025-10-11', 'YYYY-MM-DD'), 'T', 'N', 'tn002', 'mc002');

INSERT INTO SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
VALUES ('scc003', TO_DATE('2025-10-11 18:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 21:30', 'YYYY-MM-DD HH24:MI'), 14000, TO_DATE('2025-10-11', 'YYYY-MM-DD'), 'F', 'Y', 'tn003', 'mc003');

/* 15. 예매 (bn1 -> bn001, scc1 -> scc001) */
INSERT INTO BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
VALUES ('bn001',TO_DATE('2025-10-11 11:10', 'YYYY-MM-DD HH24:MI'),'T',3,'scc001','test1');

INSERT INTO BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
VALUES ('bn002',TO_DATE('2025-10-13 15:10', 'YYYY-MM-DD HH24:MI'),'T',2,'scc002','test2');

INSERT INTO BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
VALUES ('bn003',TO_DATE('2025-10-15 17:10', 'YYYY-MM-DD HH24:MI'),'T',1,'scc003','test3');

/* 16. 예매 좌석 (sb1 -> sb001, st1 -> st001, scc1 -> scc001, bn1 -> bn001, dc1 -> dc001) */
INSERT INTO SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
VALUES ('sb001', 'st001', 'scc001', 'bn001', 'dc001');

INSERT INTO SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
VALUES ('sb002', 'st002', 'scc001', 'bn001', 'dc002');

INSERT INTO SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
VALUES ('sb003', 'st003', 'scc002', 'bn002', 'dc005');

/* 17. 결제 (pc1 -> pc001, bn1 -> bn001) */
INSERT INTO PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
VALUES ('pc001',28000,'신용카드',SYSDATE,'결제 완료','bn001');

INSERT INTO PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
VALUES ('pc002',42000,'신용카드',SYSDATE,'결제 완료','bn002');

INSERT INTO PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
VALUES ('pc003',14000,'신용카드',SYSDATE,'결제 완료','bn003');

/* 18. 리뷰 (rn1 -> rn001, bn1 -> bn001) */
INSERT INTO REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
VALUES ('rn001', '이영화재밌네요',75,SYSDATE,'bn001','test1');

INSERT INTO REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
VALUES ('rn002', '이건 좀 별로에요',55,SYSDATE,'bn002','test2');

INSERT INTO REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
VALUES ('rn003', '잘 자다 왔어요',99,SYSDATE,'bn003','test3');

/* 19. 트레일러 (tc001 유지) */
INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc001','fRqegBxEvEc','mc001');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc002','NBsQkBc_Jsc','mc001');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc003','dOihGQCIw_w','mc001');

/* --- [mc002] 더 퍼스트 슬램덩크 트레일러 3개 --- */
INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc004','cGNUpsevAk4','mc002');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc005','O0Bpy4Kfw-U','mc002');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc006','9QmTRDIhkvw','mc002');


/* --- [mc003] 엘리멘탈 트레일러 3개 --- */
INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc007','BOqFRHCrN-k','mc003');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc008','DwuJeGYlYyw','mc003');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc009','bCrP2fA-jxw','mc003');


/* --- [mc004] 엣지 오브 투모로우 트레일러 3개 --- */
INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc010','kzj8p61RmVc','mc004');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc011','DVkAC4b6SWQ','mc004');

INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES ('tc012','1qg_ynu8FdU','mc004');

INSERT ALL
/* --- [mc005] 오펜하이머 트레일러 3개 (tc013 '' tc015) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc013','oSqK_v6zPoM','mc005')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc014','uYPbbksJxIg','mc005')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc015','mm8XfSs4JoA','mc005')

/* --- [mc006] 스즈메의 문단속 트레일러 3개 (tc016 '' tc018) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc016','7kVu6Io4A4Y','mc006')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc017','4AX-we2X338','mc006')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc018','5suRaBCI21I','mc006')

/* --- [mc007] 아바타: 물의 길 트레일러 3개 (tc019 '' tc021) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc019','d9MyW72ELq0','mc007')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc020','72KSf1Em1Jk','mc007')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc021','5vbMoYrViDw','mc007')

/* --- [mc008] 가디언즈 오브 갤럭시 Vol.3 트레일러 3개 (tc022 '' tc024) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc022','XyHr-s3MfCQ','mc008')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc023','u3V5KDHRQvk','mc008')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc024','rMJ8qLe6q3A','mc008')

/* --- [mc009] 탑건 매버릭 트레일러 3개 (tc025 '' tc027) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc025','BVa34EM3Lvw','mc009')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc026','-yVzb0bqx84','mc009')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc027','htAIuC6DTeE','mc009')

/* --- [mc010] 기생충 트레일러 3개 (tc028 '' tc030) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc028','SEUXfv87Wpk','mc010')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc029','jBdRhhSt3Bc','mc010')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc030','V5tv6bfCG14','mc010')
SELECT * FROM dual;

--insert All로 한번에 삽입.
INSERT ALL
/* --- [mc011] 노량: 죽음의 바다 트레일러 3개 (tc031 '' tc033) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc031','_Qe4b0U6T-I','mc011')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc032','0A6J8yU9D-w','mc011')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc033','wXz1p2T7U_r','mc011')

/* --- [mc012] 서울의 봄 트레일러 3개 (tc034 '' tc036) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc034','R9r5s0V7X-Q','mc012')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc035','1B8K9zV0E-x','mc012')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc036','yYz2q3U8V_s','mc012')

/* --- [mc013] 인사이드 아웃 2 트레일러 3개 (tc037 '' tc039) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc037','G0t6c1W8Y-R','mc013')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc038','2C9L0aW1F-y','mc013')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc039','zZa3r4V9W_t','mc013')

/* --- [mc014] 범죄도시3 트레일러 3개 (tc040 '' tc042) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc040','H1u7d2X9Z-S','mc014')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc041','3D0M1bX2G-z','mc014')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc042','aAb4s5W0X_u','mc014')

/* --- [mc015] 한산: 용의 출현 트레일러 3개 (tc043 '' tc045) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc043','I2v8e3Y0A-T','mc015')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc044','4E1N2cX3H-a','mc015')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc045','bBc5t6X1Y_v','mc015')

/* --- [mc016] 밀수 트레일러 3개 (tc046 '' tc048) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc046','J3w9f4Z1B-U','mc016')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc047','5F2O3dY4I-b','mc016')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc048','cCd6u7Y2Z_w','mc016')

/* --- [mc017] 콘크리트 유토피아 트레일러 3개 (tc049 '' tc051) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc049','K4x0g5A2C-V','mc017')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc050','6G3P4eZ5J-c','mc017')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc051','dDe7v8Z3A_x','mc017')

/* --- [mc018] 듄 (Dune) 트레일러 3개 (tc052 '' tc054) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc052','L5y1h6B3D-W','mc018')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc053','7H4Q5fA6K-d','mc018')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc054','eEf8w9A4B_y','mc018')

/* --- [mc019] 인터스텔라 트레일러 3개 (tc055 '' tc057) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc055','M6z2i7C4E-X','mc019')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc056','8I5R6gB7L-e','mc019')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc057','fFg9x0B5C_z','mc019')

/* --- [mc020] 명탐정 코난: 흑철의 어영 트레일러 3개 (tc058 '' tc060) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc058','N7a3j8D5F-Y','mc020')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc059','9J6S7hC8M-f','mc020')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc060','gGh0y1C6D_a','mc020')

/* --- [mc021] 파묘 트레일러 3개 (tc061 '' tc063) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc061','O8b4k9E6G-Z','mc021')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc062','A0K7T8iD9N-g','mc021')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc063','hHi1z2D7E_b','mc021')

/* --- [mc022] 아쿠아맨과 로스트 킹덤 트레일러 3개 (tc064 '' tc066) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc064','P9c5l0F7H-a','mc022')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc065','B1L8U9jE0O-h','mc022')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc066','iIj2a3E8F_c','mc022')

/* --- [mc023] 스파이더맨: 어크로스 더 유니버스 트레일러 3개 (tc067 '' tc069) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc067','Q0d6m1G8I-b','mc023')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc068','C2M9V0kF1P-i','mc023')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc069','jJk3b4F9G_d','mc023')

/* --- [mc024] 외계+인 2부 트레일러 3개 (tc070 '' tc072) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc070','R1e7n2H9J-c','mc024')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc071','D3N0W1lG2Q-j','mc024')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc072','kKl4c5G0H_e','mc024')

/* --- [mc025] 위시 트레일러 3개 (tc073 '' tc075) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc073','S2f8o3I0K-d','mc025')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc074','E4O1X2mH3R-k','mc025')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc075','lLm5d6H1I_f','mc025')

/* --- [mc026] 혹성탈출: 새로운 시대 트레일러 3개 (tc076 '' tc078) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc076','T3g9p4J1L-e','mc026')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc077','F5P2Y3nG4S-l','mc026')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc078','mMp6e7I2J_g','mc026')

/* --- [mc027] 베테랑 2 트레일러 3개 (tc079 '' tc081) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc079','U4h0q5K2M-f','mc027')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc080','G6Q3Z4oI5T-m','mc027')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc081','nNq7f8J3K_h','mc027')

/* --- [mc028] 데드풀과 울버린 트레일러 3개 (tc082 '' tc084) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc082','V5i1r6L3N-g','mc028')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc083','H7R4A5pH6U-n','mc028')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc084','oOr8g9K4L_i','mc028')

/* --- [mc029] 노매드랜드 트레일러 3개 (tc085 '' tc087) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc085','W6j2s7M4O-h','mc029')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc086','I8S5B6qJ7V-o','mc029')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc087','pPs9h0L5M_j','mc029')

/* --- [mc030] 테넷 (Tenet) 트레일러 3개 (tc088 '' tc090) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc088','X7k3t8N5P-i','mc030')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc089','J9T6C7rK8W-p','mc030')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc090','qQt0i1M6N_k','mc030')


/* --- [mc031] 라라랜드 트레일러 3개 (tc091 '' tc093) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc091','JeA_dYq4sLw','mc031')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc092','04qj72Qv60o','mc031')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc093','m3qU8q5A-F4','mc031')

/* --- [mc032] 닥터 스트레인지: 대혼돈의 멀티버스 트레일러 3개 (tc094 '' tc096) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc094','aI3v_0YgI_0','mc032')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc095','c6o1n1wK-f8','mc032')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc096','KjJz6S-yG7g','mc032')

/* --- [mc033] 토이 스토리 4 트레일러 3개 (tc097 '' tc099) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc097','T5_J6J8W_0U','mc033')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc098','2L-d_x-BQtQ','mc033')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc099','ePj2_L-u-qU','mc033')

/* --- [mc034] 킹스맨: 골든 서클 트레일러 3개 (tc100 '' tc102) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc100','_WjU-mE6T5g','mc034')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc101','0eFqLqUoV0k','mc034')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc102','W_U0K7W1O_w','mc034')

/* --- [mc035] 조커 트레일러 3개 (tc103 '' tc105) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc103','yUuM0iT3KkU','mc035')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc104','eD5_q4LwY_8','mc035')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc105','uU5q9dF0Y_U','mc035')

/* --- [mc036] 보헤미안 랩소디 트레일러 3개 (tc106 '' tc108) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc106','7oP8H4s2T_Y','mc036')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc107','kL-u_p0Y_oW','mc036')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc108','L2b_q1W7T_o','mc036')

/* --- [mc037] 어벤져스: 엔드게임 트레일러 3개 (tc109 '' tc111) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc109','k2gE5qX9oKk','mc037')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc110','p7qU9wT6O_U','mc037')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc111','sK-W9q2X_yT','mc037')

/* --- [mc038] 센과 치히로의 행방불명 트레일러 3개 (tc112 '' tc114) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc112','Q_0w7L-uY_w','mc038')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc113','O5qK9wT0Y_U','mc038')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc114','pL-W0q2X_tY','mc038')

/* --- [mc039] 7번방의 선물 트레일러 3개 (tc115 '' tc117) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc115','wL-w9q7W_oE','mc039')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc116','uY-W0q4X_uT','mc039')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc117','qK-y2t7W_pU','mc039')

/* --- [mc040] 아바타 (Avatar) 트레일러 3개 (tc118 '' tc120) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc118','cO-P9wT1Y_w','mc040')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc119','kL-u7q0X_oW','mc040')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc120','pQ-T1w7Y_oU','mc040')

/* --- [mc041] 극한직업 트레일러 3개 (tc121 '' tc123) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc121','sO-P0wT2Y_o','mc041')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc122','uK-W9q0X_pE','mc041')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc123','qL-t2w7T_yW','mc041')

/* --- [mc042] 인터스텔라 (재개봉) 트레일러 3개 (tc124 '' tc126) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc124','pO-q8wT0Y_t','mc042')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc125','wK-u7q1X_pQ','mc042')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc126','oL-w2t7T_uE','mc042')

/* --- [mc043] 신과함께-죄와 벌 트레일러 3개 (tc127 '' tc129) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc127','rO-P9wT1Y_t','mc043')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc128','vK-u0q4X_oW','mc043')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc129','qL-w2t1Y_pE','mc043')

/* --- [mc044] 범죄도시4 트레일러 3개 (tc130 '' tc132) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc130','sO-q9wT2Y_w','mc044')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc131','tK-u7q5X_oQ','mc044')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc132','rL-w0t7T_uO','mc044')

/* --- [mc045] 겨울왕국 2 트레일러 3개 (tc133 '' tc135) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc133','pO-q9wT3Y_t','mc045')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc134','wK-u7q6X_pE','mc045')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc135','oL-w0t8T_uO','mc045')

/* --- [mc046] 웡카 트레일러 3개 (tc136 '' tc138) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc136','rO-q9wT4Y_w','mc046')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc137','tK-u7q7X_oQ','mc046')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc138','qL-w0t9T_uE','mc046')

/* --- [mc047] 미션 임파서블: 데드 레코닝 PART ONE 트레일러 3개 (tc139 '' tc141) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc139','sO-q9wT5Y_t','mc047')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc140','uK-u7q8X_pQ','mc047')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc141','rL-w0t0T_uW','mc047')

/* --- [mc048] 명량 트레일러 3개 (tc142 '' tc144) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc142','pO-q9wT6Y_o','mc048')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc143','wK-u7q9X_pE','mc048')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc144','oL-w0t1T_uO','mc048')

/* --- [mc049] 겨울왕국 트레일러 3개 (tc145 '' tc147) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc145','rO-q9wT7Y_w','mc049')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc146','tK-u7q0X_oQ','mc049')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc147','qL-w0t2T_uE','mc049')

/* --- [mc050] 베놈 2: 렛 데어 비 카니지 트레일러 3개 (tc148 '' tc150) --- */
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc148','sO-q9wT8Y_t','mc050')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc149','uK-u7q1X_pW','mc050')
INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE) VALUES ('tc150','rL-w0t3T_uO','mc050')
SELECT * FROM dual;
/* 20. 이미지 테이블 데이터 생성 (4개씩 반영) */
--insert All로 한번에 삽입.

 INSERT ALL
/* --- [mc001] 이미지 6개 (img001 '' img006) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img001','mc001_still_001.jpg','mc001')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img002','mc001_still_002.jpg','mc001')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img003','mc001_still_003.jpg','mc001')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img004','mc001_still_004.jpg','mc001')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img005','mc001_still_005.jpg','mc001')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img006','mc001_still_006.jpg','mc001')

/* --- [mc002] 이미지 6개 (img007 '' img012) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img007','mc002_still_001.jpg','mc002')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img008','mc002_still_002.jpg','mc002')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img009','mc002_still_003.jpg','mc002')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img010','mc002_still_004.jpg','mc002')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img011','mc002_still_005.jpg','mc002')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img012','mc002_still_006.jpg','mc002')

/* --- [mc003] 이미지 6개 (img013 '' img018) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img013','mc003_still_001.jpg','mc003')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img014','mc003_still_002.jpg','mc003')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img015','mc003_still_003.jpg','mc003')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img016','mc003_still_004.jpg','mc003')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img017','mc003_still_005.jpg','mc003')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img018','mc003_still_006.jpg','mc003')

/* --- [mc004] 이미지 6개 (img019 '' img024) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img019','mc004_still_001.jpg','mc004')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img020','mc004_still_002.jpg','mc004')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img021','mc004_still_003.jpg','mc004')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img022','mc004_still_004.jpg','mc004')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img023','mc004_still_005.jpg','mc004')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img024','mc004_still_006.jpg','mc004')

SELECT * FROM DUAL;--이걸로 insertAll을 종료함.


/*========insert all로 이미지 삽입==============*/
INSERT ALL
-- 오펜하이머 (mc005) 이미지 6개 (img025 '' img030)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img025','mc005_still_001.jpg','mc005')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img026','mc005_still_002.jpg','mc005')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img027','mc005_still_003.jpg','mc005')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img028','mc005_still_004.jpg','mc005')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img029','mc005_still_005.jpg','mc005')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img030','mc005_still_006.jpg','mc005')

-- 스즈메의 문단속 (mc006) 이미지 6개 (img031 '' img036)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img031','mc006_still_001.jpg','mc006')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img032','mc006_still_002.jpg','mc006')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img033','mc006_still_003.jpg','mc006')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img034','mc006_still_004.jpg','mc006')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img035','mc006_still_005.jpg','mc006')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img036','mc006_still_006.jpg','mc006')

-- 아바타 물의 길 (mc007) 이미지 6개 (img037 '' img042)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img037','mc007_still_001.jpg','mc007')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img038','mc007_still_002.jpg','mc007')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img039','mc007_still_003.jpg','mc007')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img040','mc007_still_004.jpg','mc007')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img041','mc007_still_005.jpg','mc007')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img042','mc007_still_006.jpg','mc007')

-- 가디언즈 오브 갤럭시3 (mc008) 이미지 6개 (img043 '' img048)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img043','mc008_still_001.jpg','mc008')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img044','mc008_still_002.jpg','mc008')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img045','mc008_still_003.jpg','mc008')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img046','mc008_still_004.jpg','mc008')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img047','mc008_still_005.jpg','mc008')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img048','mc008_still_006.jpg','mc008')

-- 탑건 매버릭 (mc009) 이미지 6개 (img049 '' img054)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img049','mc009_still_001.jpg','mc009')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img050','mc009_still_002.jpg','mc009')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img051','mc009_still_003.jpg','mc009')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img052','mc009_still_004.jpg','mc009')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img053','mc009_still_005.jpg','mc009')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img054','mc009_still_006.jpg','mc009')

-- 기생충 (mc010) 이미지 6개 (img055 '' img060)
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img055','mc010_still_001.jpg','mc010')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img056','mc010_still_002.jpg','mc010')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img057','mc010_still_003.jpg','mc010')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img058','mc010_still_004.jpg','mc010')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img059','mc010_still_005.jpg','mc010')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img060','mc010_still_006.jpg','mc010')
SELECT * FROM dual;

/*========insert all로 이미지 삽입==============*/

INSERT ALL
/* --- [mc011] 노량: 죽음의 바다 이미지 6개 (img061 '' img066) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img061','mc011_still_001.jpg','mc011')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img062','mc011_still_002.jpg','mc011')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img063','mc011_still_003.jpg','mc011')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img064','mc011_still_004.jpg','mc011')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img065','mc011_still_005.jpg','mc011')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img066','mc011_still_006.jpg','mc011')

/* --- [mc012] 서울의 봄 이미지 6개 (img067 '' img072) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img067','mc012_still_001.jpg','mc012')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img068','mc012_still_002.jpg','mc012')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img069','mc012_still_003.jpg','mc012')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img070','mc012_still_004.jpg','mc012')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img071','mc012_still_005.jpg','mc012')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img072','mc012_still_006.jpg','mc012')

/* --- [mc013] 인사이드 아웃 2 이미지 6개 (img073 '' img078) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img073','mc013_still_001.jpg','mc013')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img074','mc013_still_002.jpg','mc013')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img075','mc013_still_003.jpg','mc013')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img076','mc013_still_004.jpg','mc013')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img077','mc013_still_005.jpg','mc013')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img078','mc013_still_006.jpg','mc013')

/* --- [mc014] 범죄도시3 이미지 6개 (img079 '' img084) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img079','mc014_still_001.jpg','mc014')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img080','mc014_still_002.jpg','mc014')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img081','mc014_still_003.jpg','mc014')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img082','mc014_still_004.jpg','mc014')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img083','mc014_still_005.jpg','mc014')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img084','mc014_still_006.jpg','mc014')

/* --- [mc015] 한산: 용의 출현 이미지 6개 (img085 '' img090) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img085','mc015_still_001.jpg','mc015')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img086','mc015_still_002.jpg','mc015')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img087','mc015_still_003.jpg','mc015')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img088','mc015_still_004.jpg','mc015')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img089','mc015_still_005.jpg','mc015')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img090','mc015_still_006.jpg','mc015')

/* --- [mc016] 밀수 이미지 6개 (img091 '' img096) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img091','mc016_still_001.jpg','mc016')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img092','mc016_still_002.jpg','mc016')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img093','mc016_still_003.jpg','mc016')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img094','mc016_still_004.jpg','mc016')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img095','mc016_still_005.jpg','mc016')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img096','mc016_still_006.jpg','mc016')

/* --- [mc017] 콘크리트 유토피아 이미지 6개 (img097 '' img102) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img097','mc017_still_001.jpg','mc017')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img098','mc017_still_002.jpg','mc017')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img099','mc017_still_003.jpg','mc017')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img100','mc017_still_004.jpg','mc017')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img101','mc017_still_005.jpg','mc017')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img102','mc017_still_006.jpg','mc017')

/* --- [mc018] 듄 (Dune) 이미지 6개 (img103 '' img108) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img103','mc018_still_001.jpg','mc018')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img104','mc018_still_002.jpg','mc018')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img105','mc018_still_003.jpg','mc018')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img106','mc018_still_004.jpg','mc018')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img107','mc018_still_005.jpg','mc018')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img108','mc018_still_006.jpg','mc018')

/* --- [mc019] 인터스텔라 이미지 6개 (img109 '' img114) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img109','mc019_still_001.jpg','mc019')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img110','mc019_still_002.jpg','mc019')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img111','mc019_still_003.jpg','mc019')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img112','mc019_still_004.jpg','mc019')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img113','mc019_still_005.jpg','mc019')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img114','mc019_still_006.jpg','mc019')

/* --- [mc020] 명탐정 코난: 흑철의 어영 이미지 6개 (img115 '' img120) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img115','mc020_still_001.jpg','mc020')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img116','mc020_still_002.jpg','mc020')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img117','mc020_still_003.jpg','mc020')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img118','mc020_still_004.jpg','mc020')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img119','mc020_still_005.jpg','mc020')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img120','mc020_still_006.jpg','mc020')

/* --- [mc021] 파묘 이미지 6개 (img121 '' img126) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img121','mc021_still_001.jpg','mc021')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img122','mc021_still_002.jpg','mc021')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img123','mc021_still_003.jpg','mc021')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img124','mc021_still_004.jpg','mc021')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img125','mc021_still_005.jpg','mc021')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img126','mc021_still_006.jpg','mc021')

/* --- [mc022] 아쿠아맨과 로스트 킹덤 이미지 6개 (img127 '' img132) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img127','mc022_still_001.jpg','mc022')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img128','mc022_still_002.jpg','mc022')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img129','mc022_still_003.jpg','mc022')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img130','mc022_still_004.jpg','mc022')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img131','mc022_still_005.jpg','mc022')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img132','mc022_still_006.jpg','mc022')

/* --- [mc023] 스파이더맨: 어크로스 더 유니버스 이미지 6개 (img133 '' img138) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img133','mc023_still_001.jpg','mc023')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img134','mc023_still_002.jpg','mc023')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img135','mc023_still_003.jpg','mc023')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img136','mc023_still_004.jpg','mc023')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img137','mc023_still_005.jpg','mc023')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img138','mc023_still_006.jpg','mc023')

/* --- [mc024] 외계+인 2부 이미지 6개 (img139 '' img144) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img139','mc024_still_001.jpg','mc024')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img140','mc024_still_002.jpg','mc024')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img141','mc024_still_003.jpg','mc024')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img142','mc024_still_004.jpg','mc024')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img143','mc024_still_005.jpg','mc024')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img144','mc024_still_006.jpg','mc024')

/* --- [mc025] 위시 이미지 6개 (img145 '' img150) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img145','mc025_still_001.jpg','mc025')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img146','mc025_still_002.jpg','mc025')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img147','mc025_still_003.jpg','mc025')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img148','mc025_still_004.jpg','mc025')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img149','mc025_still_005.jpg','mc025')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img150','mc025_still_006.jpg','mc025')

/* --- [mc026] 혹성탈출: 새로운 시대 이미지 6개 (img151 '' img156) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img151','mc026_still_001.jpg','mc026')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img152','mc026_still_002.jpg','mc026')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img153','mc026_still_003.jpg','mc026')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img154','mc026_still_004.jpg','mc026')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img155','mc026_still_005.jpg','mc026')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img156','mc026_still_006.jpg','mc026')

/* --- [mc027] 베테랑 2 이미지 6개 (img157 '' img162) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img157','mc027_still_001.jpg','mc027')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img158','mc027_still_002.jpg','mc027')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img159','mc027_still_003.jpg','mc027')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img160','mc027_still_004.jpg','mc027')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img161','mc027_still_005.jpg','mc027')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img162','mc027_still_006.jpg','mc027')

/* --- [mc028] 데드풀과 울버린 이미지 6개 (img163 '' img168) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img163','mc028_still_001.jpg','mc028')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img164','mc028_still_002.jpg','mc028')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img165','mc028_still_003.jpg','mc028')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img166','mc028_still_004.jpg','mc028')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img167','mc028_still_005.jpg','mc028')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img168','mc028_still_006.jpg','mc028')

/* --- [mc029] 노매드랜드 이미지 6개 (img169 '' img174) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img169','mc029_still_001.jpg','mc029')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img170','mc029_still_002.jpg','mc029')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img171','mc029_still_003.jpg','mc029')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img172','mc029_still_004.jpg','mc029')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img173','mc029_still_005.jpg','mc029')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img174','mc029_still_006.jpg','mc029')

/* --- [mc030] 테넷 (Tenet) 이미지 6개 (img175 '' img180) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img175','mc030_still_001.jpg','mc030')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img176','mc030_still_002.jpg','mc030')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img177','mc030_still_003.jpg','mc030')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img178','mc030_still_004.jpg','mc030')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img179','mc030_still_005.jpg','mc030')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img180','mc030_still_006.jpg','mc030')

/* --- [mc031] 라라랜드 이미지 6개 (img181 '' img186) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img181','mc031_still_001.jpg','mc031')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img182','mc031_still_002.jpg','mc031')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img183','mc031_still_003.jpg','mc031')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img184','mc031_still_004.jpg','mc031')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img185','mc031_still_005.jpg','mc031')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img186','mc031_still_006.jpg','mc031')

/* --- [mc032] 닥터 스트레인지: 대혼돈의 멀티버스 이미지 6개 (img187 '' img192) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img187','mc032_still_001.jpg','mc032')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img188','mc032_still_002.jpg','mc032')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img189','mc032_still_003.jpg','mc032')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img190','mc032_still_004.jpg','mc032')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img191','mc032_still_005.jpg','mc032')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img192','mc032_still_006.jpg','mc032')

/* --- [mc033] 토이 스토리 4 이미지 6개 (img193 '' img198) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img193','mc033_still_001.jpg','mc033')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img194','mc033_still_002.jpg','mc033')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img195','mc033_still_003.jpg','mc033')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img196','mc033_still_004.jpg','mc033')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img197','mc033_still_005.jpg','mc033')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img198','mc033_still_006.jpg','mc033')

/* --- [mc034] 킹스맨: 골든 서클 이미지 6개 (img199 '' img204) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img199','mc034_still_001.jpg','mc034')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img200','mc034_still_002.jpg','mc034')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img201','mc034_still_003.jpg','mc034')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img202','mc034_still_004.jpg','mc034')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img203','mc034_still_005.jpg','mc034')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img204','mc034_still_006.jpg','mc034')

/* --- [mc035] 조커 이미지 6개 (img205 '' img210) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img205','mc035_still_001.jpg','mc035')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img206','mc035_still_002.jpg','mc035')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img207','mc035_still_003.jpg','mc035')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img208','mc035_still_004.jpg','mc035')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img209','mc035_still_005.jpg','mc035')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img210','mc035_still_006.jpg','mc035')

/* --- [mc036] 보헤미안 랩소디 이미지 6개 (img211 '' img216) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img211','mc036_still_001.jpg','mc036')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img212','mc036_still_002.jpg','mc036')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img213','mc036_still_003.jpg','mc036')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img214','mc036_still_004.jpg','mc036')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img215','mc036_still_005.jpg','mc036')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img216','mc036_still_006.jpg','mc036')


/* --- [mc037] 어벤져스: 엔드게임 이미지 6개 (img217 '' img222) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img217','mc037_still_001.jpg','mc037')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img218','mc037_still_002.jpg','mc037')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img219','mc037_still_003.jpg','mc037')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img220','mc037_still_004.jpg','mc037')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img221','mc037_still_005.jpg','mc037')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img222','mc037_still_006.jpg','mc037')

/* --- [mc038] 센과 치히로의 행방불명 이미지 6개 (img223 '' img228) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img223','mc038_still_001.jpg','mc038')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img224','mc038_still_002.jpg','mc038')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img225','mc038_still_003.jpg','mc038')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img226','mc038_still_004.jpg','mc038')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img227','mc038_still_005.jpg','mc038')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img228','mc038_still_006.jpg','mc038')

/* --- [mc039] 7번방의 선물 이미지 6개 (img229 '' img234) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img229','mc039_still_001.jpg','mc039')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img230','mc039_still_002.jpg','mc039')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img231','mc039_still_003.jpg','mc039')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img232','mc039_still_004.jpg','mc039')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img233','mc039_still_005.jpg','mc039')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img234','mc039_still_006.jpg','mc039')

/* --- [mc040] 아바타 (Avatar) 이미지 6개 (img235 '' img240) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img235','mc040_still_001.jpg','mc040')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img236','mc040_still_002.jpg','mc040')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img237','mc040_still_003.jpg','mc040')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img238','mc040_still_004.jpg','mc040')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img239','mc040_still_005.jpg','mc040')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img240','mc040_still_006.jpg','mc040')

/* --- [mc041] 극한직업 이미지 6개 (img241 '' img246) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img241','mc041_still_001.jpg','mc041')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img242','mc041_still_002.jpg','mc041')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img243','mc041_still_003.jpg','mc041')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img244','mc041_still_004.jpg','mc041')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img245','mc041_still_005.jpg','mc041')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img246','mc041_still_006.jpg','mc041')

/* --- [mc042] 인터스텔라 (재개봉) 이미지 6개 (img247 '' img252) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img247','mc042_still_001.jpg','mc042')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img248','mc042_still_002.jpg','mc042')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img249','mc042_still_003.jpg','mc042')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img250','mc042_still_004.jpg','mc042')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img251','mc042_still_005.jpg','mc042')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img252','mc042_still_006.jpg','mc042')

/* --- [mc043] 신과함께-죄와 벌 이미지 6개 (img253 '' img258) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img253','mc043_still_001.jpg','mc043')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img254','mc043_still_002.jpg','mc043')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img255','mc043_still_003.jpg','mc043')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img256','mc043_still_004.jpg','mc043')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img257','mc043_still_005.jpg','mc043')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img258','mc043_still_006.jpg','mc043')

/* --- [mc044] 범죄도시4 이미지 6개 (img259 '' img264) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img259','mc044_still_001.jpg','mc044')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img260','mc044_still_002.jpg','mc044')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img261','mc044_still_003.jpg','mc044')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img262','mc044_still_004.jpg','mc044')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img263','mc044_still_005.jpg','mc044')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img264','mc044_still_006.jpg','mc044')

/* --- [mc045] 겨울왕국 2 이미지 6개 (img265 '' img270) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img265','mc045_still_001.jpg','mc045')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img266','mc045_still_002.jpg','mc045')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img267','mc045_still_003.jpg','mc045')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img268','mc045_still_004.jpg','mc045')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img269','mc045_still_005.jpg','mc045')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img270','mc045_still_006.jpg','mc045')

/* --- [mc046] 웡카 이미지 6개 (img271 '' img276) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img271','mc046_still_001.jpg','mc046')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img272','mc046_still_002.jpg','mc046')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img273','mc046_still_003.jpg','mc046')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img274','mc046_still_004.jpg','mc046')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img275','mc046_still_005.jpg','mc046')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img276','mc046_still_006.jpg','mc046')

/* --- [mc047] 미션 임파서블: 데드 레코닝 PART ONE 이미지 6개 (img277 '' img282) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img277','mc047_still_001.jpg','mc047')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img278','mc047_still_002.jpg','mc047')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img279','mc047_still_003.jpg','mc047')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img280','mc047_still_004.jpg','mc047')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img281','mc047_still_005.jpg','mc047')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img282','mc047_still_006.jpg','mc047')

/* --- [mc048] 명량 이미지 6개 (img283 '' img288) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img283','mc048_still_001.jpg','mc048')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img284','mc048_still_002.jpg','mc048')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img285','mc048_still_003.jpg','mc048')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img286','mc048_still_004.jpg','mc048')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img287','mc048_still_005.jpg','mc048')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img288','mc048_still_006.jpg','mc048')

/* --- [mc049] 겨울왕국 이미지 6개 (img289 '' img294) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img289','mc049_still_001.jpg','mc049')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img290','mc049_still_002.jpg','mc049')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img291','mc049_still_003.jpg','mc049')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img292','mc049_still_004.jpg','mc049')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img293','mc049_still_005.jpg','mc049')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img294','mc049_still_006.jpg','mc049')

/* --- [mc050] 베놈 2: 렛 데어 비 카니지 이미지 6개 (img295 '' img300) --- */
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img295','mc050_still_001.jpg','mc050')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img296','mc050_still_002.jpg','mc050')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img297','mc050_still_003.jpg','mc050')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img298','mc050_still_004.jpg','mc050')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img299','mc050_still_005.jpg','mc050')
INTO MOVIE_IMAGE(IMG_CODE, IMG_PATH, MOVIE_CODE) VALUES ('img300','mc050_still_006.jpg','mc050')
SELECT * FROM dual;

/* 21. 공지사항 */
INSERT INTO ANNOUNCE(ANNOUNCE_NUM, ANNOUNCE_NAME, ANNOUNCE_CONTENT, ANNOUNCE_VIEWS, ANNOUNCE_DATE, ADMIN_ID)
VALUES (1,'[공지] 2025학년도 대학수학능력시험 수험생 할인 이벤트 안내', '고생하신 수험생 여러분을 위해 특별한 할인을 준비했습니다.\n수험표를 지참하시면 본인 및 동반 1인까지 영화 7천원 관람 가능!\n\n기간: 11/14 '' 12/15\n방법: 현장에서 수험표 제시',451,SYSDATE,'admin');

INSERT INTO ANNOUNCE(ANNOUNCE_NUM, ANNOUNCE_NAME, ANNOUNCE_CONTENT, ANNOUNCE_VIEWS, ANNOUNCE_DATE, ADMIN_ID)
VALUES (2,'[시스템] 11월 정기 서버 점검 안내 (11/19)', '안정적인 서비스 제공을 위해 정기 점검을 진행합니다.\n점검 시간: 02:00 '' 05:00 (3시간)\n해당 시간 동안 예매 및 취소가 제한됩니다.',451,SYSDATE,'admin');

insert into ANNOUNCE(ANNOUNCE_NUM, ANNOUNCE_NAME, ANNOUNCE_CONTENT, ANNOUNCE_VIEWS, ANNOUNCE_DATE, ADMIN_ID)
values (3,'[무대인사] 영화 <서울의 밤> 개봉주 무대인사 일정', '영화 <서울의 밤> 주연 배우들과 함께하는 무대인사!\n일시: 11월 22일(토)\n참석: 황정민, 정우성 외\n예매 오픈: 11월 16일 오전 10시',1980,sysdate,'admin');



/* 최종 확정 */
COMMIT;

/* ============================================== */
/* 데이터 확인 (SELECT)              */
/* ============================================== */
SELECT * FROM ANNOUNCE;
SELECT * FROM MOVIE_IMAGE;
SELECT * FROM TRAILER;
SELECT * FROM REVIEW;
SELECT * FROM PAYMENT;
SELECT * FROM SEAT_BOOK;
SELECT * FROM BOOK;
SELECT * FROM SCREEN_INFO;
SELECT * FROM CAST;
SELECT * FROM MOVIE_DIRECTOR;
SELECT * FROM SEAT;
SELECT * FROM SOUND;
SELECT * FROM THEATHER_INFO;
SELECT * FROM MOVIE;
SELECT * FROM CINEMA_INFO;
SELECT * FROM ACTOR;
SELECT * FROM DIRECTOR;
SELECT * FROM DISCOUNT;
SELECT * FROM ADMIN;
SELECT * FROM USERS;

/* OFFSET 테스트 (페이징) */
SELECT *
FROM ANNOUNCE
ORDER BY announce_num DESC
OFFSET 2 ROWS FETCH NEXT 2 ROWS ONLY;

/* 테스트용 에리어 */
SELECT * FROM MOVIE;
SELECT * FROM MOVIE_IMAGE;
SELECT * FROM TRAILER;

SELECT MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING
 FROM MOVIE
	WHERE MOVIE_CODE='mc001';


SELECT IMG_CODE, IMG_PATH, MOVIE_CODE
FROM MOVIE_IMAGE
WHERE MOVIE_CODE='mc001';


select  img_code, img_path, movie_code  from movie_image  where movie_code='mc001';

SELECT TRAILER_CODE, URL_PATH, MOVIE_CODE
FROM TRAILER
WHERE MOVIE_CODE = 'mc001';
