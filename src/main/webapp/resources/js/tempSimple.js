
      $(document).ready(function () {
        // Sample data with ratings
        const moviesData = [
          {
            id: 1,
            title: "위키드: 포굿",
            rating: "all",
            ratingText: "ALL",
            genre: "뮤지컬/판타지",
          },
          {
            id: 2,
            title: "주토피아 2",
            rating: "all",
            ratingText: "ALL",
            genre: "애니메이션",
          },
          {
            id: 3,
            title: "나무 우 씨 미 3",
            rating: "12",
            ratingText: "12",
            genre: "코미디/액션",
          },
          {
            id: 4,
            title: "극장판 제0식: 맨: 레제넨",
            rating: "15",
            ratingText: "15",
            genre: "애니메이션",
          },
          {
            id: 5,
            title: "가타카 1도시 레이더 PICK",
            rating: "15",
            ratingText: "15",
            genre: "SF",
          },
          {
            id: 6,
            title: "정보원",
            rating: "15",
            ratingText: "15",
            genre: "액션",
          },
          {
            id: 7,
            title: "나불자 프린스",
            rating: "12",
            ratingText: "12",
            genre: "애니메이션",
          },
          {
            id: 8,
            title: "국보",
            rating: "15",
            ratingText: "15",
            genre: "액션",
          },
          {
            id: 9,
            title: "부끄니아",
            rating: "19",
            ratingText: "19",
            genre: "드라마",
          },
          {
            id: 10,
            title: "극장판 귀멸의 칼날: 무현성편",
            rating: "15",
            ratingText: "15",
            genre: "애니메이션",
          },
          {
            id: 11,
            title: "외수작이 소녀",
            rating: "15",
            ratingText: "15",
            genre: "드라마",
          },
          {
            id: 12,
            title: "프레데터: 축음의 땅",
            rating: "15",
            ratingText: "15",
            genre: "액션/SF",
          },
          {
            id: 13,
            title: "빠미아어 헌터 D",
            rating: "15",
            ratingText: "15",
            genre: "애니메이션",
          },
          {
            id: 14,
            title: "사랑과 고기",
            rating: "12",
            ratingText: "12",
            genre: "로맨스",
          },
          {
            id: 15,
            title: "반지의 제왕 : 반지원정대",
            rating: "12",
            ratingText: "12",
            genre: "판타지",
          },
        ];

        const showtimesData = {
          1: [
            // 위키드: 포굿
            {
              time: "10:00",
              endTime: "12:27",
              theater: "인성스타브랜드",
              screen: "2D Dolby(2관)",
              seats: 166,
              total: 254,
            },
            {
              time: "10:50",
              endTime: "13:17",
              theater: "인성스타브랜드",
              screen: "2D(2관)",
              seats: 250,
              total: 262,
            },
            {
              time: "11:40",
              endTime: "14:07",
              theater: "인성스타브랜드",
              screen: "2D(2관)",
              seats: 178,
              total: 181,
            },
            {
              time: "12:45",
              endTime: "15:12",
              theater: "인성스타브랜드",
              screen: "2D Dolby(2관)",
              seats: 229,
              total: 254,
            },
            {
              time: "13:35",
              endTime: "16:02",
              theater: "인성스타브랜드",
              screen: "2D(2관)",
              seats: 255,
              total: 262,
            },
            {
              time: "14:25",
              endTime: "16:52",
              theater: "인성스타브랜드",
              screen: "2D(2관)",
              seats: 171,
              total: 181,
            },
            {
              time: "15:30",
              endTime: "17:57",
              theater: "인성스타브랜드",
              screen: "(한국 게스트) 위키드: 포굿",
              seats: 214,
              total: 254,
            },
            {
              time: "16:40",
              endTime: "19:07",
              theater: "인성스타브랜드",
              screen: "2D Dolby(2관)",
              seats: 201,
              total: 254,
            },
            {
              time: "17:20",
              endTime: "19:47",
              theater: "인성스타브랜드",
              screen: "2D(3관)",
              seats: 125,
              total: 136,
            },
            {
              time: "18:10",
              endTime: "20:37",
              theater: "인성스타브랜드",
              screen: "2D(2관)",
              seats: 132,
              total: 181,
            },
            {
              time: "19:45",
              endTime: "22:12",
              theater: "인성스타브랜드",
              screen: "2D Dolby(2관)",
              seats: 178,
              total: 254,
            },
          ],
          2: [
            // 주토피아 2
            {
              time: "10:30",
              endTime: "12:15",
              theater: "인성스타브랜드",
              screen: "2D(1관)",
              seats: 89,
              total: 120,
            },
            {
              time: "12:50",
              endTime: "14:35",
              theater: "인성스타브랜드",
              screen: "2D(1관)",
              seats: 102,
              total: 120,
            },
            {
              time: "15:10",
              endTime: "16:55",
              theater: "인성스타브랜드",
              screen: "2D(1관)",
              seats: 95,
              total: 120,
            },
          ],
        };

        let selectedMovie = null;
        let selectedDate = null;
        let selectedHour = null;

        // Generate dates
        function generateDates() {
          const dateScroll = $("#dateScroll");
          const today = new Date(2025, 10, 19); // November 19, 2025
          const weekdays = ["일", "월", "화", "수", "목", "금", "토"];

          for (let i = 0; i < 30; i++) {
            const date = new Date(today);
            date.setDate(today.getDate() + i);

            const dateItem = $("<div>")
              .addClass("date-item")
              .attr("data-date", date.toISOString().split("T")[0]).html(`
                            <div class="date-day">${date.getDate()}·${
              weekdays[date.getDay()]
            }</div>
                        `);

            if (i === 4) {
              // Select Nov 23 by default
              dateItem.addClass("active");
              selectedDate = dateItem.attr("data-date");
            }

            dateScroll.append(dateItem);
          }
        }

        // Generate hour selector
        function generateHourSelector() {
          const hourSelector = $("#hourSelector");
          hourSelector.empty();

          for (let i = 6; i <= 15; i++) {
            const hourBtn = $("<button>")
              .addClass("time-badge")
              .attr("data-hour", i.toString().padStart(2, "0"))
              .text(i.toString().padStart(2, "0"));

            if (i === 10) {
              hourBtn.addClass("active");
              selectedHour = i.toString().padStart(2, "0");
            }

            hourSelector.append(hourBtn);
          }
        }

        // Get rating class
        function getRatingClass(rating) {
          const ratingMap = {
            all: "rating-all",
            12: "rating-12",
            15: "rating-15",
            19: "rating-19",
          };
          return ratingMap[rating] || "rating-all";
        }

        // Load movies
        function loadMovies(filterRating = "all") {
          const movieList = $("#movieList");
          movieList.empty();

          const filteredMovies =
            filterRating === "all" || filterRating === "all-rating"
              ? moviesData
              : moviesData.filter((m) => m.rating === filterRating);

          if (filteredMovies.length === 0) {
            movieList.html(`
                        <div class="empty-state">
                            <div class="empty-state-icon">🎬</div>
                            <p>해당 등급의 영화가 없습니다</p>
                        </div>
                    `);
            return;
          }

          filteredMovies.forEach((movie, index) => {
            setTimeout(() => {
              const movieItem = $("<div>")
                .addClass("movie-item")
                .attr("data-movie-id", movie.id).html(`
                                <div class="movie-title">
                                    <span class="movie-rating ${getRatingClass(
                                      movie.rating
                                    )}">${movie.ratingText}</span>
                                    <span>${movie.title}</span>
                                </div>
                                <button class="favorite-btn">♡</button>
                            `);

              movieList.append(movieItem);
            }, index * 30);
          });
        }

        // Load showtimes
        function loadShowtimes(movieId, filterHour = null) {
          const showtimeList = $("#showtimeList");
          showtimeList.empty();

          if (!showtimesData[movieId]) {
            showtimeList.html(`
                        <div class="empty-state">
                            <div class="empty-state-icon">⏰</div>
                            <p>상영 시간이 없습니다</p>
                        </div>
                    `);
            return;
          }

          let showtimes = showtimesData[movieId];

          // Filter by hour if selected
          if (filterHour) {
            showtimes = showtimes.filter((s) => s.time.startsWith(filterHour));
          }

          if (showtimes.length === 0) {
            showtimeList.html(`
                        <div class="empty-state">
                            <div class="empty-state-icon">⏰</div>
                            <p>해당 시간대의 상영이 없습니다</p>
                        </div>
                    `);
            return;
          }

          showtimes.forEach((showtime, index) => {
            setTimeout(() => {
              const showtimeItem = $("<div>").addClass("showtime-item").html(`
                                <div class="showtime-header">
                                    <div class="showtime-time">${showtime.time}</div>
                                    <div class="showtime-end">~${showtime.endTime}</div>
                                </div>
                                <div class="showtime-details">
                                    <div class="showtime-screen">${showtime.screen}</div>
                                    <div class="showtime-theater">${showtime.screen}</div>
                                </div>
                                <div class="showtime-info-right">
                                    <div class="showtime-badge">${showtime.theater}</div>
                                    <div style="margin-top: 8px;">
                                        <button class="book-btn" onclick="bookTicket('${showtime.time}')">
                                            컴포트2관(현관이나)<br>
                                            <span class="seat-available">${showtime.seats}/${showtime.total}</span>
                                        </button>
                                    </div>
                                </div>
                            `);

              showtimeList.append(showtimeItem);
            }, index * 40);
          });
        }

        // Event handlers
        $(document).on("click", ".date-item", function () {
          $(".date-item").removeClass("active");
          $(this).addClass("active");
          selectedDate = $(this).attr("data-date");

          if (selectedMovie) {
            loadShowtimes(selectedMovie, selectedHour);
          }
        });

        $(document).on("click", ".movie-item", function () {
          $(".movie-item").removeClass("selected");
          $(this).addClass("selected");
          selectedMovie = $(this).attr("data-movie-id");

          loadShowtimes(selectedMovie, selectedHour);
        });

        $(document).on("click", "#hourSelector .time-badge", function () {
          $("#hourSelector .time-badge").removeClass("active");
          $(this).addClass("active");
          selectedHour = $(this).attr("data-hour");

          if (selectedMovie) {
            loadShowtimes(selectedMovie, selectedHour);
          }
        });

        $(document).on("click", ".tab-btn[data-tab]", function () {
          $(this).siblings().removeClass("active");
          $(this).addClass("active");
          const tab = $(this).attr("data-tab");
          loadMovies(tab);
        });

        $(document).on("click", ".favorite-btn", function (e) {
          e.stopPropagation();
          $(this).toggleClass("favorited");
          $(this).text($(this).hasClass("favorited") ? "♥" : "♡");
        });

        // Initialize
        generateDates();
        generateHourSelector();
        loadMovies();
      });

      // Book ticket function
      function bookTicket(time) {
        alert(`${time} 상영시간 예매를 진행합니다!`);
      }
