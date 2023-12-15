/**
 * 
 */
//조회수 증가 
UpdateHitServer  = function(){
	
	$.ajax({
		
		url : `${mypath}/notice/hit.do`,
		type : 'get',
		data : {"num" : vidx},
		success : function(res){
			
			//성공 했ㅇ다면 
			if(res.flag== "성공"){
				
				//조회수의 위치값 검색 
				vhit = $(gthis).parents('.card').find('.hit');
				
				//그위치에서 현재 값을 가져온다   + 1
				hitvalue =   parseInt($(vhit).text().trim()) + 1;
				
				// 화면의 조회수 값을 변경 
				$(vhit).text(hitvalue);
			}
		},
		error : function(xhr){
			alert("오류 상태 : " + xhr.status)
		},
		dataType : 'json'
	})
	
	
	
}