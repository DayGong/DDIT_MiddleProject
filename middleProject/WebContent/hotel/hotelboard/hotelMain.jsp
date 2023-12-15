<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath() %>/js/jquery-3.7.1.min.js"></script>
<script src="<%=request.getContextPath() %>/js/hotel.js"></script>
<script src="<%=request.getContextPath() %>/js/reserveHotel.js"></script>
<script src="<%=request.getContextPath() %>/js/jquery.serializejson.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

 <link rel= "stylesheet"  href="<%=request.getContextPath() %>/css/hotel.css">



</head>

<body>
<!-- 상단 메뉴바 -->
<jsp:include page="/view/main/top.jsp"/>
       <div id ="category-container"  style="margin-top: 130px;">
         <div class="big-buttons">
        <button class="cateBtn" name="tourList" id="tourListBtn">주요관광지</button>
        <button class="cateBtn" name="resList"> 식당 </button>
        <button class="cateBtn" name="hotelList">숙박업소</button>
        <button class="cateBtn" name="list" id="tashuBtn">타슈</button>
        </div>
        <!-- 나머지 버튼들도 유사하게 추가할 수 있습니다 -->
        <br><br>
        <p style="font-size: 15px;">지역</p>
        <div class="sub-buttons">
        <button class="cateBtn" name="daeAll" >전체</button>
        <button class="cateBtn" name="daeYou" >유성구</button>
        <button class="cateBtn" name="daeSeo" >서구</button>
        <button class="cateBtn" name="daeJung" >중구</button>
        <button class="cateBtn" name="daeDong" >동구</button>
        <button class="cateBtn" name="daeDae" >대덕구</button>
        <!-- 다른 세부 카테고리 버튼들도 유사하게 추가 -->
        </div>
        </div>        
        
        <hr>
        <div id="search-container" style="margin-top: 130px;">
        <form id ="boxandbutton" >
        <input type="text" id="searchbox" name="searchbox" placeholder="이름으로 검색합니다" style="width: 80%;">
        <input type="button" id="searchBtn" name="searchbutton" value="검색" style="width: 20%;" >
        </form>
        <hr>
        <ul id="placesList"></ul>
        <div id="pagination"></div>
    </div>
        
        <hr>
      <!--   장소 목록 표시를 위한 ul 엘리먼트 
        <ul id="placesList"></ul>
        페이지네이션 표시를 위한 엘리먼트
        <div id="pagination"></div>
    </div> -->
      
    <div id="map-container" style="margin-top: 130px;">
        <div class="map_wrap">
            <!-- 지도를 표시할 div 엘리먼트 -->
            <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
        </div>
    </div>
    
    
  <!-- 상세정보 The Modal -->
<div class="modal" id="wModal">
  <div class="modal-dialog">
    <div class="modal-content">

     
      <div class="modal-header">
        <h4 class="modal-title">호텔 상세정보</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        
     
      </div>

      
      <div class="modal-body">        
       
      </div>

     
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div> 


<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=81f61c0a7b90a0b0dfd08d8188731b77&libraries=services"></script>
<script>
            data={};
            mypath='<%=request.getContextPath()%>';  
        var markers = [];
        // 지도 객체 생성 및 설정
        var mapContainer = document.getElementById('map'),
            mapOption = {
                center: new kakao.maps.LatLng(36.3519957, 127.39131469),
                level: 6
            };
        var map = new kakao.maps.Map(mapContainer, mapOption);
        // 장소 검색 서비스 객체 생성
        var ps = new kakao.maps.services.Places();
        // 인포윈도우 생성
        var  infowindow = new kakao.maps.InfoWindow({
            zIndex: 1
        });
        var geocoder = new kakao.maps.services.Geocoder();
        var pagination;
        var infowindows = [];
    
        $(()=>{
        	resetMap();
        	  $.ajax({
        			url:`${mypath}/hotel/hotelList.do`,
        			type:'get',
        	 		success: function(res){   // ajax로 가져온 json데이터 res를 for문으로 돌린다			    		   
        				res.forEach(function(item) { // tour_addr값을 주소로하여 마커를 찍는다
        				geocoder.addressSearch(item.hotel_addr, function(result, status) {
        	 			if (status === kakao.maps.services.Status.OK) {
        				var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
        	 			var marker = new kakao.maps.Marker({
        				map: map,
        				position: coords
        				});
        				markers.push(marker);
        				var  infowindow = new kakao.maps.InfoWindow({
        					content: `<div id="infowindow" > 
        					${item.hotel_name}<p>
        								</div>`
        					});
        					kakao.maps.event.addListener(marker, 'mouseover', function() {
        					infowindow.open(map, marker);
        					 });

        					kakao.maps.event.addListener(marker, 'mouseout', function() {
        					infowindow.close();
        					}); 
        						// 리스트에 아이템 추가
        				var listItem = $('<li></li>')
        					.html(`<p>숙소명: ${item.hotel_name}</p><p>주소: ${item.hotel_addr}</p><p>전화번호: ${item.hotel_tel}</p><p><hr>`);

        					// 클릭 이벤트 추가
        					listItem.on('click', function() {
        						infowindows.forEach(function(window) {
        						window.close();
        						});
        						infowindow.open(map, marker);
        						infowindows.push(infowindow);
        						moveToHotelDetail (`${item.hotel_no}`);   
        						
        						map.panTo(coords);                     
        					setTimeout(function() {
        					infowindow.close();
        					 }, 3500);
        						}); 

        					// 리스트를 출력할 요소에 추가
        					$('#placesList').append(listItem);
        						 }
        					});
        				});
        	             
        					},
        			error: function(xhr){
        				alert(xhr.status);
        					},
        			dataType: 'json'			
        			})
 
        		
        })

</script>
<!-- 숙소의 상세 정보를 출력하는 모달창 시작 -->
<div class="modal" id="hotelDetailModal">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
		
			<!-- 모달 헤더 -->
			<div class="modal-header" id="hotelModalHeader">
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<!-- 모달 몸통(내용 출력) -->
			<div class="modal-body" id="hotelModalBody">
				<div id="left-modal-body"></div> 	<!-- 상세 정보 폼 -->
				<div id="right-modal-body"></div> 	<!-- 예약 입력 폼 -->
			</div>

			<!-- 모달 하단(후기 출력) -->
			<div class="modal-footer">
				<button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div> <!-- 숙소의 상세 정보를 출력하는 모달창 끝 -->
</body>
</html>