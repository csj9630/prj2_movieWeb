drop sequence emp_seq;

CREATE SEQUENCE emp_seq
       INCREMENT BY 1
       START WITH 500
       MINVALUE 1
       MAXVALUE 1000
       CYCLE
       NOCACHE
       NOORDER;


commit;
SELECT movie_seq.currval
  FROM dual;


INSERT INTO TRAILER(TRAILER_CODE, URL_PATH, MOVIE_CODE)
VALUES (concat('tc',lpad(emp_seq.nextval,3,0)),'9QmTRDIhkvw','mc002');

SELECT * FROM TRAILER;


INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES (concat('mc',lpad(emp_seq.nextval,3,0)),'가장 위험한 배틀에 몸을 던진다! ',
 concat('mc',lpad(emp_seq.curval,3)) ,'mc001_bg.jpg','15000','3000000','F','상영중');


INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES (concat('mc',lpad(emp_seq.nextval,3,0))  ,'더 퍼sdsd스트 슬램덩크','스포츠','124','전체 이용가', '2025-01-04',
'전국 제패를 꿈꾸는 북산고 농구부 5인방의 이야기를 그린 작품. 이번 극장판은 ''송태섭''을 중심으로 그의 과거와 현재가 교차되며 펼쳐지는 박진감 넘치는 경기를 담아냈다. 구판 애니메이션에서 미처 다루지 못한, 많은 팬들이 그토록 원했던 원작 최종 보스 산왕공고(산노)와의 인터하이 32강전을 영상화한 작품으로, 큰 틀에선 원작과 같으면서도 세부적으론 다른 연출과 스토리텔링을 사용한 게 돋보인다. ',
'mc'||lpad(emp_seq.currval,3)||'_poster.jpg','mc'||lpad(emp_seq.currval,3)||'_bg.jpg','12000','4800000','F','상영중');

SELECT * FROM TRAILER;
SELECT MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, BG_IMAGE, MAIN_IMAGE FROM movie order by movie_code desc;


INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES (
    'mz' || LPAD(movie_seq.nextval, 3, '0'),
    '극장판 체인소맨 : 폭탄편',
    '액션',
    '120',
    '15세 이용가',
    '2025-10-20',
    '압도적 배틀 액션이 스크린에서 폭발한다! 데블 헌터로 일하는 소년 ''덴지''는 조직의 배신으로 죽음에 내몰린 순간 전기톱 악마견 ''포치타''와의 계약으로 하나로 합쳐져 누구도 막을 수 없는 존재 ''체인소 맨''으로 다시 태어난다. 악마와 사냥꾼, 그리고 정체불명의 적들이 얽힌 잔혹한 전쟁 속에서 ''레제''라는 이름의 미스터리한 소녀가 ''덴지'' 앞에 나타나는데… ''덴지''는 사랑이라는 감정에 이끌려 지금껏 가장 위험한 배틀에 몸을 던진다! ',
    -- 파일명에도 새로 생성된 시퀀스 값 사용 (currval 대신 nextval 호출 후 새로운 nextval 사용)
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_poster.jpg',
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_bg.jpg',
    '15000',
    '3000000',
    'F',
    '상영중'
);

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES (
    'mzc' || LPAD(movie_seq.nextval, 3, '0'),
    '더 퍼스트 슬램덩크',
    '스포츠',
    '124',
    '전체 이용가',
    '2025-01-04',
    '전국 제패를 꿈꾸는 북산고 농구부 5인방의 이야기를 그린 작품. 이번 극장판은 ''송태섭''을 중심으로 그의 과거와 현재가 교차되며 펼쳐지는 박진감 넘치는 경기를 담아냈다. 구판 애니메이션에서 미처 다루지 못한, 많은 팬들이 그토록 원했던 원작 최종 보스 산왕공고(산노)와의 인터하이 32강전을 영상화한 작품으로, 큰 틀에선 원작과 같으면서도 세부적으론 다른 연출과 스토리텔링을 사용한 게 돋보인다. ',
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_poster.jpg',
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_bg.jpg',
    '12000',
    '4800000',
    'F',
    '상영중'
);

INSERT INTO MOVIE(MOVIE_CODE, MOVIE_NAME, MOVIE_GENRE, RUNNING_TIME, MOVIE_GRADE, RELEASE_DATE, INTRO, MAIN_IMAGE, BG_IMAGE, DAILY_AUDIENCE, TOTAL_AUDIENCE, MOVIE_DELETE, SHOWING)
VALUES (
    'mzc' || LPAD(movie_seq.nextval, 3, '0'),
    '엘리멘탈',
    '애니메이션',
    '109',
    '전체 이용가',
    '2025-06-14',
    '불, 물, 흙, 공기 4개의 원소들이 살고 있는 ''엘리멘트 시티''. 재치 있고 불 같은 성격의 ''앰버''는 낯설고 새로운 세상에서 우연히 유쾌하고 감성적이며 물 흐르듯 사는 ''웨이드''를 만나 특별한 우정을 쌓아간다. 한 불 원소 부부가 돛단배를 타고 안개에 뒤덮인 바다를 가르며 어딘가로 향하는 모습을 비추면서 영화가 시작된다. 그렇게 도착한 곳은 여러 원소들이 함께 어울려 사는 도시인 엘리멘트 시티. 짐을 챙기고 배에서 내린 부부는 입국을 위해 검문소로 향한다.',
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_poster.jpg',
    'mc' || LPAD(movie_seq.currval, 3, '0') || '_bg.jpg',
    '8000',
    '7200000',
    'F',
    '상영중'
);
