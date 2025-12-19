/*==============업데이트 내용============================*/
/*
2025-12-11 : movie, trailer, MOVIE_IMAGE  테이블 구조 및 가데이터 수정


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
    users_id VARCHAR2(30) NOT NULL PRIMARY KEY, /* 아이디 */
    users_pass VARCHAR2(30) NOT NULL, /* 비밀번호 */
    email VARCHAR2(60) NOT NULL, /* 이메일 */
    users_name VARCHAR2(40) NOT NULL, /* 이름 */
    birth DATE NOT NULL, /* 생년월일 */
    gender CHAR(10) NOT NULL, /* 성별 */
    users_image VARCHAR2(100) NOT NULL, /* 사용자 이미지 */
    recent_login DATE NOT NULL, /* 최근 로그인 */
    join_date DATE NOT NULL, /* 가입일 */
    active CHAR(10) NOT NULL, /* 활성화 여부 */
    phone_num VARCHAR2(30) NOT NULL /* 전화번호 */
);

/* 2. 관리자 */
CREATE TABLE ADMIN (
    admin_id VARCHAR2(40) NOT NULL PRIMARY KEY, /* 아이디 */
    admin_pass VARCHAR2(40) NOT NULL, /* 비번 */
    create_date DATE NOT NULL /* 계정 생성일 */
);

/* 3. 할인 */
CREATE TABLE DISCOUNT (
    discount_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 할인 번호 */
    discount_type VARCHAR2(30) NOT NULL, /* 유형 */
    discount_rate NUMBER NOT NULL, /* 할인율 */
    discount_people VARCHAR2(30) NOT NULL /* 인원타입 */
);

/* 4. 감독 */
CREATE TABLE DIRECTOR (
    director_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 감독 코드 */
    director_name VARCHAR2(40) NOT NULL /* 감독명 */
);

/* 5. 배우 */
CREATE TABLE ACTOR (
    actor_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 배우 코드 */
    actor_name VARCHAR2(50) NOT NULL /* 배우명 */
);

/* 6. 영화관 정보 */
CREATE TABLE CINEMA_INFO (
    cinema_num VARCHAR2(30) NOT NULL PRIMARY KEY, /* 영화관 코드 */
    cinema_name VARCHAR2(30) NOT NULL, /* 영화관명 */
    cinema_location VARCHAR2(60) NOT NULL /* 위치 */
);


/* 7.영화 */
CREATE TABLE MOVIE (
	movie_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 영화 코드 */
	movie_name VARCHAR2(90) NOT NULL, /* 제목 */
	movie_genre VARCHAR2(50) NOT NULL, /* 장르 */
	running_time VARCHAR2(30) NOT NULL, /* 영화 상영 시간 */
	movie_grade VARCHAR2(30) NOT NULL, /* 관람 등급 */
	release_date VARCHAR2(30) NOT NULL, /* 개봉일 */
	intro VARCHAR2(999) NOT NULL, /* 소개 */
	main_image VARCHAR2(60) NOT NULL, /* 메인 이미지 */
	bg_image VARCHAR2(60) NOT NULL, /* 배경 이미지 */
	daily_audience VARCHAR2(30) NOT NULL, /* 일별 관객수 */
	total_audience VARCHAR2(30) NOT NULL, /* 누적 관객수 */
	movie_delete CHAR(10) NOT NULL, /* 삭제 FLAG */
	showing VARCHAR2(30) NOT NULL /* 상영여부 */
);

/* 예매율 */
CREATE TABLE BOOK_RATE(
    bookrate_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 예매율 코드 */
    book_rate NUMBER NOT NULL, /* 예매율 */
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_RATE_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE) /* 영화코드 */
);

/* 8. 사운드 시스템 */
CREATE TABLE SOUND (
    sound_code VARCHAR2(20) NOT NULL PRIMARY KEY, /* 사운드 시스템 코드 */
    sound_name VARCHAR2(60) NOT NULL /* 사운드 시스템명 */
);

/* 9. 상영관 정보 */
CREATE TABLE THEATHER_INFO (
    theather_num VARCHAR2(20) NOT NULL PRIMARY KEY, /* 상영관 번호 */
    theather_name VARCHAR2(30) NOT NULL, /* 상영관 이름 */
    total_seat NUMBER NOT NULL, /* 총 좌석 */
    availability CHAR(10) NOT NULL, /* 사용 가능 여부 */
    cinema_num VARCHAR2(30) NOT NULL CONSTRAINT FK_THEATHER_INFO_CINEMA_NUM REFERENCES CINEMA_INFO(CINEMA_NUM), /* 영화관 코드 */
    sound_code VARCHAR2(20) NOT NULL CONSTRAINT FK_THEATHER_INFO_SOUND_CODE REFERENCES SOUND(SOUND_CODE) /* 사운드 시스템 코드 */
);

/* 10. 좌석 */
CREATE TABLE SEAT (
    seat_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 좌석 코드 */
    seat_row VARCHAR2(30) NOT NULL, /* 좌석 행 */
    seat_col VARCHAR2(30) NOT NULL, /* 좌석 열 */
    available_seat VARCHAR2(20) NOT NULL, /* 예매가능 여부 */
    theather_num VARCHAR2(20) NOT NULL CONSTRAINT FK_SEAT_THEATHER_NUM REFERENCES THEATHER_INFO(THEATHER_NUM)/* 상영관 번호 */
);

/* 11. 영화 감독 */
CREATE TABLE MOVIE_DIRECTOR (
    director_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_DIRECTOR_DIRECTOR_CODE REFERENCES DIRECTOR(DIRECTOR_CODE), /* 감독 코드 */
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_DIRECTOR_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)/* 영화 코드 */
);

/* 12. 출연진 */
CREATE TABLE CAST (
    actor_code VARCHAR2(30) NOT NULL CONSTRAINT FK_CAST_ACTOR_CODE REFERENCES ACTOR(ACTOR_CODE), /* 배우 코드 */
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_CAST_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE) /* 영화 코드 */
);

/* 13. 상영 정보 */
CREATE TABLE SCREEN_INFO (
    screen_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 상영 코드 */
    screen_open DATE NOT NULL, /* 상영 시작 시간 */
    screen_end DATE NOT NULL, /* 상영 끝 시간 */
    screen_price NUMBER NOT NULL, /* 가격 */
    screen_date DATE NOT NULL, /* 상영 날짜 */
    screen_delete CHAR(10) NOT NULL, /* 삭제 FLAG */
    screen_showing CHAR(10) NOT NULL, /* 상영 여뷰 */
    theather_num VARCHAR2(20) NOT NULL CONSTRAINT FK_SCREEN_INFO_THEATHER_NUM REFERENCES THEATHER_INFO(THEATHER_NUM), /* 상영관 번호 */
    movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SCREEN_INFO_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)/* 영화 코드 */
);

/* 14.예매 */
/* 수정: book_cancel은 초기 예매 시 NULL일 수밖에 없으므로 NOT NULL 제거 */
CREATE TABLE BOOK (
    book_num VARCHAR2(30) NOT NULL PRIMARY KEY, /* 예매 번호 */
    book_time VARCHAR2(30) NOT NULL, /* 예매 일시 */
    book_state VARCHAR2(30) NOT NULL, /* 예매 상태 */
    book_cancel DATE, /* 예매 취소 일시 (NULL 허용) */
    total_book NUMBER NOT NULL, /* 총 인원 */
    screen_code VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_SCREEN_CODE REFERENCES SCREEN_INFO(SCREEN_CODE), /* 상영 코드 */
    users_id VARCHAR2(30) NOT NULL CONSTRAINT FK_BOOK_USERS_ID REFERENCES USERS(USERS_ID) /* 아이디 */
);

/* 15. 예매 좌석 */
CREATE TABLE SEAT_BOOK (
    seat_book_code VARCHAR2(30) NOT NULL, /* 예매 좌석 코드 */
    seat_code VARCHAR2(30) NOT NULL, /* 좌석 코드 */
    screen_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_SCREEN_CODE REFERENCES SCREEN_INFO(SCREEN_CODE), /* 상영 코드 */
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_BOOK_NUM REFERENCES BOOK(BOOK_NUM), /* 예매 번호 */
    discount_code VARCHAR2(30) NOT NULL CONSTRAINT FK_SEAT_BOOK_DISCOUNT_CODE REFERENCES DISCOUNT(DISCOUNT_CODE),
    CONSTRAINT PK_SEAT_BOOK PRIMARY KEY (seat_book_code) -- PK 추가 권장
);

/* 16. 결제 */
CREATE TABLE PAYMENT (
    payment_code VARCHAR2(30) NOT NULL PRIMARY KEY, /* 결제 코드 */
    payment_price NUMBER NOT NULL, /* 결제 금액 */
    payment_method VARCHAR2(30) NOT NULL, /* 결제 수단 */
    payment_time DATE NOT NULL, /* 결제 시간 */
    payment_state VARCHAR2(30) NOT NULL, /* 결제 상태 */
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_PAYMENT_BOOK_NUM REFERENCES BOOK(BOOK_NUM) /* 예매 번호 */
);

/* 17. 리뷰 */
CREATE TABLE REVIEW (
    review_num VARCHAR2(30) NOT NULL, /* 리뷰 번호 */
    review_content VARCHAR2(3000) NOT NULL, /* 내용 */
    review_score NUMBER NOT NULL, /* 점수 */
    review_date DATE NOT NULL, /* 작성일 */
    book_num VARCHAR2(30) NOT NULL CONSTRAINT FK_REVIEW_BOOK_NUM REFERENCES BOOK(BOOK_NUM), /* 예매 번호 */
    users_id VARCHAR2(100) NOT NULL CONSTRAINT FK_REVIEW_USERS_ID REFERENCES USERS(USERS_ID) /* 사용자 아이디 */
);

/* 19. 트레일러 */
CREATE TABLE TRAILER (
	trailer_code VARCHAR2(20) NOT NULL PRIMARY KEY, /* 트레일러 코드 */
	url_path VARCHAR2(300) NOT NULL, /* URL 경로 */
	movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_TRAILER_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)/* 영화 코드 */
);

/* 20. 이미지 */

CREATE TABLE MOVIE_IMAGE (
	img_code VARCHAR2(20) NOT NULL PRIMARY KEY, /* 트레일러 코드 */
	img_path VARCHAR2(300) NOT NULL, /* 포스터 이미지 */
	movie_code VARCHAR2(30) NOT NULL CONSTRAINT FK_MOVIE_IMAGE_MOVIE_CODE REFERENCES MOVIE(MOVIE_CODE)/* 영화 코드 */
);

/* 21. 공지사항 */
CREATE TABLE ANNOUNCE (
    announce_num NUMBER NOT NULL PRIMARY KEY, /* 공지사항 번호 */
    announce_name VARCHAR2(1000) NOT NULL, /* 제목 */
    announce_content VARCHAR2(3000) NOT NULL, /* 내용 */
    announce_views NUMBER NOT NULL, /* 조회수 */
    announce_date DATE NOT NULL, /* 작성일 */
    ADMIN_id VARCHAR2(100) NOT NULL CONSTRAINT FK_ANNOUNCE_ADMIN_ID REFERENCES ADMIN(ADMIN_ID)/* 아이디 */
);

/* ============================================== */
/* 데이터 삽입 (INSERT)              */
/* ============================================== */

/* 1. 유저 (users_image 컬럼 데이터 추가) */
insert into USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
values('test1', '1234', 'test@naver.com', '이정우', '2000-10-13','남자', 'default.jpg', sysdate, '2025-11-18', '비활성','010-1111-1111');

insert into USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
values('test2', 'q1w2e3', 'qq@naver.com', '테스트', '1999-05-23','여자', 'default.jpg', sysdate, '2025-10-18', '활성','010-4554-1111');

insert into USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER, USERS_IMAGE, RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM)
values('test3', '1', 'user@naver.com', '유저', '1991-10-13','남자', 'default.jpg', sysdate, '2023-11-18', '활성', '010-1234-2231');

/* 2. 관리자 */
insert into ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) values('admin','1234',sysdate);
insert into ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) values('admin2','admin',sysdate);
insert into ADMIN(ADMIN_ID, ADMIN_PASS, CREATE_DATE) values('ad','1',sysdate);

/* 3. 할인 */
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc1','조조','0.5','청소년');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc2','조조','0.6','성인');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc3','조조','0.4','경로');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc4','일반','0.7','청소년');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc5','일반','1','성인');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc6','일반','0.6','경로');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc7','심야','0.6','청소년');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc8','심야','0.7','성인');
insert into DISCOUNT(DISCOUNT_CODE, DISCOUNT_TYPE, DISCOUNT_RATE, DISCOUNT_PEOPLE) values('dc9','심야','0.5','경로');

/* 4. 감독 */
insert into DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) values('dt1','봉존호');
insert into DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) values('dt2','헐리우드');
insert into DIRECTOR(DIRECTOR_CODE, DIRECTOR_NAME) values('dt3','박찬혹');

/* 5. 배우 */
insert into ACTOR(ACTOR_CODE, ACTOR_NAME) values('at1','순강호');
insert into ACTOR(ACTOR_CODE, ACTOR_NAME) values('at2','나미라');
insert into ACTOR(ACTOR_CODE, ACTOR_NAME) values('at3','덕화');

/* 6. 영화관 정보 */
insert into CINEMA_INFO(CINEMA_NUM, CINEMA_NAME, CINEMA_LOCATION) values ('cn1','쌍용시네마','H타워');

/* 7.영화 */
insert into MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO,
 main_image,bg_image, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
values ('mc001','체인소맨','액션','120','15세 이용가', '2025-10-20',
'압도적 배틀 액션이 스크린에서 폭발한다!  데블 헌터로 일하는 소년 ''덴지''는 조직의 배신으로 죽음에 내몰린 순간 전기톱 악마견 ''포치타''와의 계약으로 하나로 합쳐져  누구도 막을 수 없는 존재 ''체인소 맨''으로 다시 태어난다.  악마와 사냥꾼, 그리고 정체불명의 적들이 얽힌 잔혹한 전쟁 속에서  ''레제''라는 이름의 미스터리한 소녀가 ''덴지'' 앞에 나타나는데…  ''덴지''는 사랑이라는 감정에 이끌려 지금껏 가장 위험한 배틀에 몸을 던진다! ',
'poster.jpg','bg.jpg','15000','3000000','F','상영중');

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO,
main_image,bg_image, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc002','슬램덩크: 더 퍼스트','스포츠','124','전체 이용가', '2025-01-04',
'전국 제패를 꿈꾸는 북산고 농구부 5인방의 이야기를 그린 작품. 이번 극장판은 ''송태섭''을 중심으로 그의 과거와 현재가 교차되며 펼쳐지는 박진감 넘치는 경기를 담아냈다.',
'poster.jpg','bg.jpg','12000','4800000','F','상영중');

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO,
main_image,bg_image, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES ('mc003','엘리멘탈','애니메이션','109','전체 이용가', '2025-06-14',
'불, 물, 흙, 공기 4개의 원소들이 살고 있는 ‘엘리멘트 시티’. 재치 있고 불 같은 성격의 ''앰버''는 낯설고 새로운 세상에서 우연히 유쾌하고 감성적이며 물 흐르듯 사는 ''웨이드''를 만나 특별한 우정을 쌓아간다.',
'poster.jpg','bg.jpg','8000','7200000','F','상영중');

/* 8. 예매율 */
insert into BOOK_RATE(BOOKRATE_CODE, BOOK_RATE, MOVIE_CODE) values('1', '55.3', 'mc1');

/* 9. 사운드 시스템 */
insert into SOUND(SOUND_CODE, SOUND_NAME) values ('tn1','Dolby Digital 7.1');
insert into SOUND(SOUND_CODE, SOUND_NAME) values ('tn2','DTS Digital Surround');
insert into SOUND(SOUND_CODE, SOUND_NAME) values ('tn3','Dolby Atmos');

/* 10. 상영관 정보 */
insert into THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
values ('tn1', 'cinema2', 100, 'T', 'cn1', 'tn1');

insert into THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
values ('tn2', 'cinema2', 100, 'F', 'cn1', 'tn2');

insert into THEATHER_INFO(THEATHER_NUM, THEATHER_NAME, TOTAL_SEAT, AVAILABILITY, CINEMA_NUM, SOUND_CODE)
values ('tn3', 'cinema3', 100, 'T', 'cn1', 'tn3');

/* 11. 좌석 */
insert into SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
values ('st1', 'A', '1', 'T', 'tn1');

insert into SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
values ('st2', 'A', '2', 'T', 'tn1');

insert into SEAT(SEAT_CODE, SEAT_ROW, SEAT_COL, AVAILABLE_SEAT, THEATHER_NUM)
values ('st3', 'B', '1', 'T', 'tn2');

/* 12. 영화 감독 */
insert into MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) values ('dt1', 'mc1');
insert into MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) values ('dt2', 'mc2');
insert into MOVIE_DIRECTOR(DIRECTOR_CODE, MOVIE_CODE) values ('dt3', 'mc3');

/* 13. 출연진 */
insert into CAST(ACTOR_CODE, MOVIE_CODE) values ('at1','mc1');
insert into CAST(ACTOR_CODE, MOVIE_CODE) values ('at2','mc2');
insert into CAST(ACTOR_CODE, MOVIE_CODE) values ('at3','mc3');

/* 14. 상영 정보 (SCREEN_SHOWING 값 추가) */
insert into SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
values ('scc1', TO_DATE('2025-10-11 11:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 14:30', 'YYYY-MM-DD HH24:MI'), 14000, '2025-10-11', 'F', 'Y', 'tn1', 'mc1');

insert into SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
values ('scc2', TO_DATE('2025-10-11 15:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 17:30', 'YYYY-MM-DD HH24:MI'), 14000, '2025-10-11', 'T', 'N', 'tn2', 'mc2');

insert into SCREEN_INFO(SCREEN_CODE, SCREEN_OPEN, SCREEN_END, SCREEN_PRICE, SCREEN_DATE, SCREEN_DELETE, SCREEN_SHOWING, THEATHER_NUM, MOVIE_CODE)
values ('scc3', TO_DATE('2025-10-11 18:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-10-11 21:30', 'YYYY-MM-DD HH24:MI'), 14000, '2025-10-11', 'F', 'Y', 'tn3', 'mc3');

/* 15. 예매 */
insert into BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
values ('bn1',TO_DATE('2025-10-11 11:10', 'YYYY-MM-DD HH24:MI'),'T',3,'scc1','test1');

insert into BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
values ('bn2',TO_DATE('2025-10-13 15:10', 'YYYY-MM-DD HH24:MI'),'T',2,'scc2','test2');

insert into BOOK(BOOK_NUM, BOOK_TIME, BOOK_STATE, TOTAL_BOOK, SCREEN_CODE, USERS_ID)
values ('bn3',TO_DATE('2025-10-15 17:10', 'YYYY-MM-DD HH24:MI'),'T',1,'scc3','test3');

/* 16. 예매 좌석 (중복 키 sb2 수정 -> sb3, st3) */
insert into SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
values ('sb1', 'st1', 'scc1', 'bn1', 'dc1');

insert into SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
values ('sb2', 'st2', 'scc1', 'bn1', 'dc2');

insert into SEAT_BOOK(SEAT_BOOK_CODE, SEAT_CODE, SCREEN_CODE, BOOK_NUM, DISCOUNT_CODE)
values ('sb3', 'st3', 'scc1', 'bn1', 'dc2');

/* 17. 결제 */
insert into PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
values ('pc1',28000,'신용카드',sysdate,'결제 완료','bn1');

insert into PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
values ('pc2',42000,'신용카드',sysdate,'결제 완료','bn2');

insert into PAYMENT(PAYMENT_CODE, PAYMENT_PRICE, PAYMENT_METHOD, PAYMENT_TIME, PAYMENT_STATE, BOOK_NUM)
values ('pc3',14000,'신용카드',sysdate,'결제 완료','bn3');

/* 18. 리뷰 */
insert into REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
values ('rn1', '이영화재밌네요',75,sysdate,'bn1','test1');

insert into REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
values ('rn2', '이건 좀 별로에요',55,sysdate,'bn2','test2');

insert into REVIEW(REVIEW_NUM, REVIEW_CONTENT, REVIEW_SCORE, REVIEW_DATE, BOOK_NUM, USERS_ID)
values ('rn3', '잘 자다 왔어요',99,sysdate,'bn3','test3');

/* 19. 트레일러 */
insert into TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
values ('tc001','fRqegBxEvEc','mc001');

insert into TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
values ('tc002','NBsQkBc_Jsc','mc001');

insert into TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
values ('tc003','dOihGQCIw_w','mc001');


/* 20. 이미지 */
insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img001','still_001.jpg','mc001');

insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img002','still_002.jpg','mc001');

insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img003','still_001.jpg','mc002');

insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img004','still_002.jpg','mc002');

insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img005','still_001.jpg','mc003');

insert into MOVIE_IMAGE(img_code, img_path, movie_code)
values ('img006','still_002.jpg','mc003');



/* 21. 공지사항 */
insert into ANNOUNCE(ANNOUNCE_NUM, ANNOUNCE_NAME, ANNOUNCE_CONTENT, ANNOUNCE_VIEWS, ANNOUNCE_DATE, ADMIN_ID)
values (1,'[공지] 2025학년도 대학수학능력시험 수험생 할인 이벤트 안내', '고생하신 수험생 여러분을 위해 특별한 할인을 준비했습니다.\n수험표를 지참하시면 본인 및 동반 1인까지 영화 7천원 관람 가능!\n\n기간: 11/14 ~ 12/15\n방법: 현장에서 수험표 제시',451,sysdate,'admin');

insert into ANNOUNCE(ANNOUNCE_NUM, ANNOUNCE_NAME, ANNOUNCE_CONTENT, ANNOUNCE_VIEWS, ANNOUNCE_DATE, ADMIN_ID)
values (2,'[시스템] 11월 정기 서버 점검 안내 (11/19)', '안정적인 서비스 제공을 위해 정기 점검을 진행합니다.\n점검 시간: 02:00 ~ 05:00 (3시간)\n해당 시간 동안 예매 및 취소가 제한됩니다.',451,sysdate,'admin');

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

/* 주의: EMP 테이블은 이 스크립트에서 생성하지 않았으므로 아래 쿼리는 주석 처리합니다.
   테이블이 존재한다면 주석을 해제하고 실행하세요. */
/*
SELECT * FROM EMP;
SELECT * FROM EMP
ORDER BY EMPNO
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
*/

SELECT * FROM MOVIE;
SELECT * FROM MOVIE_IMAGE;
SELECT * FROM TRAILER;
