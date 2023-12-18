/**
 * 회원이 숙소 예약 리스트와 취소 리스트를 볼 때 사용하는 js
 */

// 경로 path 설정
const pathName = "/" + window.location.pathname.split("/")[1];
const origin = window.location.origin;
const path = origin + pathName;

$(function() {
	
	// 숙소 예약 테이블 폼
	memberHotelReserveForm();
	
	// 숙소 예약 List를 테이블 <tbody>에 넣기
	addMemberHotelReserve();

	// 숙소 예약 취소 테이블 폼
	memberHotelReserveCancelForm();
		
	// 숙소 예약 취소 List를 테이블 <tbody>에 넣기
	addMemberHotelReserveCancel();

})

// 숙소 예약 테이블 폼
memberHotelReserveForm = function()
{
	hotelReserveForm = `
		<table border='1'>
	 		<tr>
	 			<td>예약번호</td><td>숙소명</td><td>예약시작일</td><td>예약종료일</td>
	 			<td>인원수</td><td>객실정보</td><td>결제금액</td><td></td>
	 		</tr>
	 		<tbody id="addMemberHotelReserve"></tbody>
		 </table>
	`;
	
	$('#memberHotelReserveList').html(hotelReserveForm);
}

// 숙소 예약 List를 테이블 <tbody>에 넣기
addMemberHotelReserve = function()
{
	$.ajax
	 ({
		 url: `${path}/reserve/hotelMemberReserveList.do`,
		 type: 'POST',
		 data: 
		 {
			 "mem_id" : mem_id
		 },
		 success: function(res)
		 {
			var hotelReserveList = null;
			if (res == null)
			{
				hotelReserveList += `
				<tr>
					<td colspan="8">예약 목록이 없습니다.</td>
				</tr>
				`;
			} else 
			{				 
				console.log(res);
				$.each(res, function(i, v)
				{
					hotelReserveList += `
					<tr>
						<td>${v.HOTEL_RSV_NO}</td>
					 	<td>${v.HOTEL_NAME}</td>
					 	<td>${v.HOTEL_RSV_STARTDATE}</td>
					 	<td>${v.HOTEL_RSV_ENDDATE}</td>
					 	<td>${v.HOTEL_RSV_COUNT}</td>
					 	<td>${v.HOTEL_RSV_ROOM}</td>
					 	<td>${v.HOTEL_TOTALAMT}</td>
						<td><input type="button" value="예약 취소" id="${v.HOTEL_RSV_NO}" 
									onclick="hotelReserveCancel(this.id)"></td>
					 </tr>
					 `;
				 })
			 }
		
			$('#addMemberHotelReserve').html(hotelReserveList);
		 },
		 error: function(xhr)
		 {
			 console.log('숙소 예약 리스트 불러오기 오류 ==> ' + xhr);
		 },
		 dataType: 'json'
	 })

}

// 숙소 예약 취소
hotelReserveCancel = function(hotel_rsv_no)
{
	$.ajax
	({
		url: `${path}/reserve/hotelReserveCancel.do`,
		type: 'POST',
		data:
		{
			"hotel_rsv_no" : hotel_rsv_no
		},
		success: function()
		{
			swal("숙소 예약이 취소되었습니다.", "", "success");
			// location.href=`${path}/reserveBtnTemp.jsp`; // 이동할 회원 관리 페이지
		},
		error: function(xhr)
		{
			console.log('숙소 예약 취소 실패 ==> ' + xhr);
		}
	})
}

// 숙소 예약 취소 테이블 폼
memberHotelReserveCancelForm = function()
{
	hotelReserveCancelForm = `
		<table border='1'>
	 		<tr>
	 			<td>예약번호</td><td>숙소명</td><td>예약시작일</td><td>예약종료일</td>
	 			<td>인원수</td><td>객실정보</td><td>결제금액</td><td></td>
	 		</tr>
	 		<tbody id="addMemberHotelReserveCancel"></tbody>
		 </table>
	`;
	
	$('#memberHotelCancelList').html(hotelReserveCancelForm);
}

// 숙소 예약 취소 List를 테이블 <tbody>에 넣기
addMemberHotelReserveCancel = function()
{
	$.ajax
	 ({
		 url: `${path}/reserve/hotelMemberReserveCancelList.do`,
		 type: 'POST',
		 data: 
		 {
			 "mem_id" : mem_id
		 },
		 success: function(res)
		 {
			var hotelReserveList = null;
			if (res == null)
			{
				hotelReserveList += `
				<tr>
					<td colspan="8">예약 목록이 없습니다.</td>
				</tr>
				`;
			} else 
			{				 
				console.log(res);
				$.each(res, function(i, v)
				{
					hotelReserveList += `
					<tr>
						<td>${v.HOTEL_RSV_NO}</td>
					 	<td>${v.HOTEL_NAME}</td>
					 	<td>${v.HOTEL_RSV_STARTDATE}</td>
					 	<td>${v.HOTEL_RSV_ENDDATE}</td>
					 	<td>${v.HOTEL_RSV_COUNT}</td>
					 	<td>${v.HOTEL_RSV_ROOM}</td>
					 	<td>${v.HOTEL_TOTALAMT}</td>
						<td><input type="button" value="취소 완료" disabled></td>
					 </tr>
					 `;
				 })
			 }
		
			$('#addMemberHotelReserveCancel').html(hotelReserveList);
		 },
		 error: function(xhr)
		 {
			 console.log('숙소 예약 리스트 불러오기 오류 ==> ' + xhr);
		 },
		 dataType: 'json'
	 })

}